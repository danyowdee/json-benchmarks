//
//  BenchmarkTest.m
//  JSONBenchmarks
//
//  Created by Martin Brugger on 25.02.11.
//  Copyright 2011 Sam Soffes. All rights reserved.
//

#import "BenchmarkTest.h"
#import "SBStatistics.h"

#import <objc/runtime.h>

#import "NSObject+Introspection.h"

static BOOL shouldCancel;
// Benchmark function
JBTestResult *bench(NSString *what, NSString *direction, void (^block)(void))
{	
	SBStatistics *stats = [SBStatistics new];

	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	for (NSInteger i = 0; i < kIterations; i++) {
        @autoreleasepool {
            if (shouldCancel)
                return nil;

            NSDate *before = [NSDate date];
            block();
            [stats addDouble:-[before timeIntervalSinceNow] * 1000];
            if (i % (kIterations/100) == 0)
            {
                dispatch_async(dispatch_get_main_queue(),^{
                    float progress =  (float)i/(float)kIterations;
                    [center postNotificationName:JBRunningBenchmarkDidProgressNotificaton object:nil userInfo:@{JBRunningBenchmarkProgressKey : @(progress)}];
                });
            }
		}
	}

	return [[JBTestResult alloc] initWithSuiteName:what averageDuration:stats.mean];
}


@implementation BenchmarkTest

@synthesize collection;

- (void)prepareData
{
	NSAssert(NO, @"BenchmarkTest - prepareData: implement in subclass!");
}

+ (NSArray *)benchmarkTestClasses
{
	NSMutableArray *result = [NSMutableArray array];
	int numClasses;
	Class * classes = NULL;
	
	numClasses = objc_getClassList(NULL, 0);
	
	if (numClasses > 0 )
	{
		classes = (Class *)calloc(numClasses, sizeof(Class));
		numClasses = objc_getClassList(classes, numClasses);
				
		for (int currentClass = 0; currentClass < numClasses; currentClass++)
		{
			Class class = classes[currentClass];
			if (class_conformsToProtocol(class, @protocol(BenchmarkTestProtocol)))
			{
				[result addObject:NSStringFromClass(classes[currentClass])];
			}
		}
		free(classes);
	}
	return result;
}

+ (void)runBenchmarksWithTwitterJSONDataIncludingReads:(BOOL)shouldIncludeReads includingWrites:(BOOL)shouldIncludeWrites
{
	NSStringEncoding stringEncoding = NSUTF8StringEncoding;
	NSStringEncoding dataEncoding = stringEncoding; // NSUTF32BigEndianStringEncoding;	
	
	
	// Load JSON string
	NSString *jsonString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"twitter_public_timeline" ofType:@"json"] encoding:stringEncoding error:nil];
	NSData *jsonData = [jsonString dataUsingEncoding:dataEncoding];
	id array = (NSArray *)[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
	[[self class] runBenchmarksWithCollection:array includeReading:shouldIncludeReads includeWriting:shouldIncludeWrites];
}

+ (void)runBenchmarksWithArrayCollectionIncludingReads:(BOOL)shouldIncludeReads includingWrites:(BOOL)shouldIncludeWrites
{
	// generate new data for benchmark
	NSInteger totalElements = 1000;
	
	NSMutableArray *generatedData = [NSMutableArray arrayWithCapacity:totalElements];
	
	for (NSInteger elementCount = 0; elementCount < totalElements; elementCount++)
	{
		NSString *value = [NSString stringWithFormat:@"ABCEDFGHIJKLMNOPQRSTUVWXYZ-%d",(int)elementCount*100000];
		[generatedData addObject:value];
	}
	
	[[self class] runBenchmarksWithCollection:generatedData includeReading:shouldIncludeReads includeWriting:shouldIncludeWrites];
}

+ (void)runBenchmarksWithDictionaryCollectionIncludingReads:(BOOL)shouldIncludeReads includingWrites:(BOOL)shouldIncludeWrites
{
	// generate new data for benchmark
	NSInteger totalElements = 1000;
	
	NSMutableDictionary *generatedData = [NSMutableDictionary dictionaryWithCapacity:totalElements];
	for (NSInteger elementCount = 0; elementCount < totalElements; elementCount++)
	{
		NSString *key = [NSString stringWithFormat:@"key-%ld",(long)elementCount];
		NSString *value = [NSString stringWithFormat:@"ABCEDFGHIJKLMNOPQRSTUVWXYZ-%d",(int)elementCount*100000];
		[generatedData setObject:value forKey:key];
	}

	[[self class] runBenchmarksWithCollection:generatedData includeReading:shouldIncludeReads includeWriting:shouldIncludeWrites];
}

+ (void)runBenchmarksWithCollection:(id)theCollection includeReading:(BOOL)shouldIncludeReading includeWriting:(BOOL)shouldIncludeWriting;
{

	// Setup result arrays
	NSMutableArray *readingResults = [NSMutableArray array];
	NSMutableArray *writingResults = [NSMutableArray array];

	// Configuration
	NSLog(@"Starting benchmarks with %i iterations for each library", kIterations);


	// fetch all classes implementing the BenchmarkTestProtocol
	NSArray *benchmarkClassNames = [BenchmarkTest benchmarkTestClasses];

	dispatch_queue_t benchmarkQueue = dispatch_queue_create("com.samsoffes.json-benchmarks.serialQueue", NULL);

	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	NSInteger testCount = 0;
	NSInteger totalTests = benchmarkClassNames.count;
    shouldCancel = NO;
	for (NSString *benchmarkClassName in benchmarkClassNames)
	{
		testCount++;
		float progress = (float)testCount/(float)totalTests;
		dispatch_async(benchmarkQueue,^{
			@autoreleasepool {
                if (shouldCancel)
                    return;

                Class benchmarkClass = NSClassFromString(benchmarkClassName);

                NSMutableDictionary *progressPayload = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                        [NSString stringWithFormat:@"%d/%d", (int)testCount, (int)totalTests], JBBenchmarkSuiteStatusStringKey,
                                                        benchmarkClassName, JBBenchmarkSuiteNameKey,
                                                        nil];

                [center postNotificationName:JBBenchmarkSuiteDidChangeNotification object:self userInfo:progressPayload];

                // assume only valid classes here, double check
                if ([benchmarkClass conformsToProtocol:@protocol(BenchmarkTestProtocol)]
                    && [benchmarkClass isInheritedFromClass:[BenchmarkTest class]])
                {
                    // run benchmark with class
                    BenchmarkTest<BenchmarkTestProtocol> *benchmarkObject = [[benchmarkClass alloc] init];
                    benchmarkObject.collection = theCollection;
                    [benchmarkObject prepareData];



                    JBTestResult *readingResult = nil;

                    if (shouldIncludeReading)
                    {
                        // FIXME: Communicate “reading” status.
                        readingResult = [benchmarkObject runBenchmarkReading];
                        if (readingResult != nil)
                        {
                            [readingResults  addObject:readingResult];
                        }
                        else
                        {
                            NSLog(@"%@\tread\tERROR: missing benchmark results", benchmarkObject.benchmarkName);
                        }

                    }

                    JBTestResult *writingResult = nil;
                    if (shouldIncludeWriting)
                    {
                        // FIXME: Communicate “writing” status
                        writingResult = [benchmarkObject runBenchmarkWriting];
                        NSUInteger serializedSize = [benchmarkObject serializedSize];
                        if (writingResult != nil)
                        {
                            [writingResults addObject:writingResult];
                        }
                        else
                        {
                            NSLog(@"%@\twrite\tERROR: missing benchmark results", benchmarkObject.benchmarkName);
                        }

                    }
                }
                else
                {
                    NSLog(@"ERROR: runnning benchmark with class: %@", benchmarkClass);
                }
                
                
                progressPayload[JBRunningBenchmarkProgressKey] = @(progress);
                [center postNotificationName:JBBenchmarkSuiteDidChangeNotification object:self userInfo:progressPayload];
			}
		});
	}
	
	dispatch_async(benchmarkQueue,^{
        SEL comparator = @selector(compareToTestResult:);
		// Post notification
		NSDictionary *allResults = [NSDictionary dictionaryWithObjectsAndKeys:
									[readingResults sortedArrayUsingSelector:comparator], JBReadingKey,
									[writingResults sortedArrayUsingSelector:comparator], JBWritingKey,
									nil];
        
        [center postNotificationName:JBDidFinishBenchmarksNotification object:self userInfo:allResults];
	});
}

+ (void)cancelRunningBenchmark
{
    shouldCancel = YES;
}

@end

#pragma mark - Notifications:
// Notification names
NSString *const JBDidFinishBenchmarksNotification = @"JBDidFinishBenchmarksNotification";
NSString * const JBBenchmarkSuiteDidChangeNotification = @"JBBenchmarkSuiteDidChangeNotification";
NSString * const JBRunningBenchmarkDidProgressNotificaton = @"JBRunningBenchmarkDidProgressNotificaton";

// Keys
NSString *const JBReadingKey = @"reading";
NSString *const JBWritingKey = @"writing";
NSString *const JBLibraryKey = @"library";
NSString *const JBAverageTimeKey = @"averageTime";

NSString * const JBBenchmarkSuiteNameKey = @"JBBenchmarkSuiteNameKey";
NSString * const JBBenchmarkSuiteStatusStringKey = @"JBBenchmarkSuiteStatusStringKey";

NSString * const JBRunningBenchmarkProgressKey = @"JBRunningBenchmarkProgressKey";
