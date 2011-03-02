//
//  BenchmarkTest.m
//  JSONBenchmarks
//
//  Created by Martin Brugger on 25.02.11.
//  Copyright 2011 Sam Soffes. All rights reserved.
//

#import "BenchmarkTest.h"
#import "SBStatistics.h"
#import "JBConstants.h"

#import <objc/runtime.h>

#import "JSONParser.h"
#import "JSONWriter.h"

#import "NSObject+Introspection.h"

#import "BenchmarkProgressViewController.h"
#import "JBResultsViewController.h"

// Comparer function for sorting
static int _compareResults(NSDictionary *result1, NSDictionary *result2, void *context) {
	return [[result1 objectForKey:JBAverageTimeKey] compare:[result2 objectForKey:JBAverageTimeKey]];
}


// Benchmark function
void bench(NSString *what, NSString *direction, void (^block)(void), NSDictionary **result)
{	
	SBStatistics *stats = [[SBStatistics new] autorelease];
	
	for (NSInteger i = 0; i < kIterations; i++) {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		
		if ([BenchmarkProgressViewController instance].cancelBenchmarkPressed)
		{
			return;
		}
		
		NSDate *before = [NSDate date];
		block();
		[stats addDouble:-[before timeIntervalSinceNow] * 1000];
		if (i % (kIterations/100) == 0)
		{
			dispatch_async(dispatch_get_main_queue(),^{
				float progress =  (float)i/(float)kIterations;
				[BenchmarkProgressViewController instance].currentFrameworkProgressView.progress = progress;
			});
		}
		[pool release];
	}
	
	*result = [NSDictionary dictionaryWithObjectsAndKeys:
						what, JBLibraryKey,
						[NSNumber numberWithDouble:stats.mean], JBAverageTimeKey,
						nil];
	
	//NSLog(@"%@ %@ min/mean/max (ms): %.3f/%.3f/%.3f - stddev: %.3f", what, direction, stats.min, stats.mean, stats.max, [stats standardDeviation]);
	NSLog(@"%@\t%@\t%.3f\t%.3f\t%.3f\t%.3f", what, direction, stats.min, stats.mean, stats.max, [stats standardDeviation]);
}



@implementation BenchmarkTest

@synthesize collection;

- (void) dealloc
{
	[collection release]; collection = nil;
	[super dealloc];
}


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
		classes = malloc(sizeof(Class) * numClasses);
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

+ (void)runBenchmarksWithTwitterJSONData
{
	NSStringEncoding stringEncoding = NSUTF8StringEncoding;
	NSStringEncoding dataEncoding = stringEncoding; // NSUTF32BigEndianStringEncoding;	
	
	
	// Load JSON string
	NSString *jsonString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"twitter_public_timeline" ofType:@"json"] encoding:stringEncoding error:nil];
	NSData *jsonData = [jsonString dataUsingEncoding:dataEncoding];
	id array = (NSArray *)[JSON objectWithData:jsonData options:0 error:nil];
	[[self class] runBenchmarksWithCollection:array];
}

+ (void)runBenchmarksWithArrayCollection
{
	// generate new data for benchmark
	NSInteger totalElements = 1000;
	
	NSMutableArray *generatedData = [NSMutableArray arrayWithCapacity:totalElements];
	
	for (NSInteger elementCount = 0; elementCount < totalElements; elementCount++)
	{
		NSString *value = [NSString stringWithFormat:@"ABCEDFGHIJKLMNOPQRSTUVWXYZ-%d",elementCount*100000];
		[generatedData addObject:value];
	}
	
	[[self class] runBenchmarksWithCollection:generatedData];
}

+ (void)runBenchmarksWithDictionaryCollection
{
	// generate new data for benchmark
	NSInteger totalElements = 1000;
	
	NSMutableDictionary *generatedData = [NSMutableDictionary dictionaryWithCapacity:totalElements];
	for (NSInteger elementCount = 0; elementCount < totalElements; elementCount++)
	{
		NSString *key = [NSString stringWithFormat:@"key-%d",elementCount];
		NSString *value = [NSString stringWithFormat:@"ABCEDFGHIJKLMNOPQRSTUVWXYZ-%d",elementCount*100000];
		[generatedData setObject:value forKey:key];
	}

	[[self class] runBenchmarksWithCollection:generatedData];
}

+ (void)runBenchmarksWithCollection:(id)theCollection
{

	// Setup result arrays
	NSMutableArray *readingResults = [NSMutableArray array];
	NSMutableArray *writingResults = [NSMutableArray array];
	
	// Configuration
	NSLog(@"Starting benchmarks with %i iterations for each library", kIterations);
	
	
	// fetch all classes implementing the BenchmarkTestProtocol
	NSArray *benchmarkClassNames = [BenchmarkTest benchmarkTestClasses];
	
	dispatch_queue_t benchmarkQueue = dispatch_queue_create("com.samsoffes.json-benchmarks.serialQueue", NULL);
	
	NSInteger testCount = 0;
	NSInteger totalTests = benchmarkClassNames.count;
	for (NSString *benchmarkClassName in benchmarkClassNames)
	{
		testCount++;
		float progress = (float)testCount/(float)totalTests;
		dispatch_async(benchmarkQueue,^{
			NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
			
			if ([BenchmarkProgressViewController instance].cancelBenchmarkPressed)
			{
				return;
			}
			
			Class benchmarkClass = NSClassFromString(benchmarkClassName);
			
			dispatch_async(dispatch_get_main_queue(),^{
				[BenchmarkProgressViewController instance].frameworkNameLabel.text = benchmarkClassName;
				[BenchmarkProgressViewController instance].frameworkCountLabel.text = [NSString stringWithFormat:@"%d/%d", testCount, totalTests];				
			});
			
			// assume only valid classes here, double check
			if ([benchmarkClass conformsToProtocol:@protocol(BenchmarkTestProtocol)]
				&& [benchmarkClass isInheritedFromClass:[BenchmarkTest class]])
			{
				// run benchmark with class
				BenchmarkTest<BenchmarkTestProtocol> *benchmarkObject = [[[benchmarkClass alloc] init] autorelease];
				benchmarkObject.collection = theCollection;
				[benchmarkObject prepareData];
				

				
				NSDictionary *readingResult = nil;
				
				if ([BenchmarkProgressViewController instance].readSwitch.on)
				{
					dispatch_async(dispatch_get_main_queue(),^{
						[BenchmarkProgressViewController instance].benchmarkDirectionLabel.text = @"reading";
					});
					readingResult = [benchmarkObject runBenchmarkReading];
				}
				
				NSDictionary *writingResult = nil;
				if ([BenchmarkProgressViewController instance].writeSwitch.on)
				{	
					dispatch_async(dispatch_get_main_queue(),^{
						[BenchmarkProgressViewController instance].benchmarkDirectionLabel.text = @"writing";
					});
					writingResult = [benchmarkObject runBenchmarkWriting];
				}
				
				if (writingResult != nil)
				{
					[writingResults addObject:writingResult];
				}
				else
				{
					NSLog(@"%@\twrite\tERROR: missing benchmark results", benchmarkObject.benchmarkName);
				}
				
				if (readingResult != nil)
				{
					[readingResults  addObject:readingResult];
				}
				else
				{
					NSLog(@"%@\tread\tERROR: missing benchmark results", benchmarkObject.benchmarkName);
				}
			}
			else
			{
				NSLog(@"ERROR: runnning benchmark with class: %@", benchmarkClass);
			}
			
			dispatch_async(dispatch_get_main_queue(),^{
				[BenchmarkProgressViewController instance].overallProgressView.progress = progress;	
			});
			
			[pool drain];
			pool = nil;
		});
	}
	
	dispatch_async(benchmarkQueue,^{
		// Sort results
		[readingResults sortUsingFunction:_compareResults context:nil];
		[writingResults sortUsingFunction:_compareResults context:nil];
		
		// Post notification
		NSDictionary *allResults = [NSDictionary dictionaryWithObjectsAndKeys:
									readingResults, JBReadingKey,
									writingResults, JBWritingKey,
									nil];
		
		// dispatch notification in main thread!
		dispatch_async(dispatch_get_main_queue(),^{
			
			if ([BenchmarkProgressViewController instance].cancelBenchmarkPressed)
			{
				// reset BenchmarkProgressViewController
				[[BenchmarkProgressViewController instance] resetBenchmark];
				
			}
			else
			{						
				UINavigationController *navigationController = [BenchmarkProgressViewController instance].navigationController;
				JBResultsViewController *viewController = [[JBResultsViewController alloc] init];
				[navigationController pushViewController:viewController animated:YES];

				[[NSNotificationCenter defaultCenter] postNotificationName:JBDidFinishBenchmarksNotification object:allResults];
				[viewController release];
			}
		});
	});
	dispatch_release(benchmarkQueue);	
}

@end
