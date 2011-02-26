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
#import <objc/objc-runtime.h>
#import <objc/runtime.h>

#import "JSONParser.h"
#import "JSONWriter.h"

#import "NSObject+Introspection.h"

// Comparer function for sorting
static int _compareResults(NSDictionary *result1, NSDictionary *result2, void *context) {
	return [[result1 objectForKey:JBAverageTimeKey] compare:[result2 objectForKey:JBAverageTimeKey]];
}


// Benchmark function
void xbench(NSString *what, NSString *direction, void (^block)(void), NSDictionary **result)
{	
	SBStatistics *stats = [[SBStatistics new] autorelease];
	
	for (NSInteger i = 0; i < kIterations; i++) {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		NSDate *before = [NSDate date];
		block();
		[stats addDouble:-[before timeIntervalSinceNow] * 1000];
		[pool release];
	}
	
	*result = [NSDictionary dictionaryWithObjectsAndKeys:
						what, JBLibraryKey,
						[NSNumber numberWithDouble:stats.mean], JBAverageTimeKey,
						nil];
	
	NSLog(@"%@ %@ min/mean/max (ms): %.3f/%.3f/%.3f - stddev: %.3f", what, direction, stats.min, stats.mean, stats.max, [stats standardDeviation]);
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
	
	classes = NULL;
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

+ (void)runBenchmarks
{
	// This could obviously be better, but I'm trying to keep things simple.
	
	// Configuration
	NSLog(@"Starting benchmarks with %i iterations for each library", kIterations);
	NSStringEncoding stringEncoding = NSUTF8StringEncoding;
	NSStringEncoding dataEncoding = stringEncoding; // NSUTF32BigEndianStringEncoding;	
	
	// Setup result arrays
	NSMutableArray *readingResults = [[NSMutableArray alloc] init];
	NSMutableArray *writingResults = [[NSMutableArray alloc] init];
	
	// Load JSON string
	NSString *jsonString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"twitter_public_timeline" ofType:@"json"] encoding:stringEncoding error:nil];
	NSData *jsonData = [jsonString dataUsingEncoding:dataEncoding];
	NSArray *array = (NSArray *)[JSON objectWithData:jsonData options:0 error:nil];
	
	
	
	
	
	// generate new data for benchmark
	// given json data can not be serialized to plist (null values?)
	NSInteger totalElements = 1000;
	
	NSMutableArray *generatedData = [NSMutableArray arrayWithCapacity:totalElements];
	for (NSInteger elementCount = 0; elementCount < totalElements; elementCount++)
	{
		[generatedData addObject:@"ABCEDFGHIJKLMNOPQRSTUVWXYZ"];
	}
	
	// overwrite data to be used for benchmark
	array = generatedData;
	jsonString = [JSON stringWithObject:array options:0 error:nil];
	jsonData = [jsonString dataUsingEncoding:dataEncoding];
	
	
	// fetch all classes implementing the BenchmarkTestProtocol
	NSArray *benchmarkClassNames = [BenchmarkTest benchmarkTestClasses];
	
	for (NSString *benchmarkClassName in benchmarkClassNames)
	{
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		
		Class benchmarkClass = NSClassFromString(benchmarkClassName);
		
		// assume only valid classes here, double check
		if ([benchmarkClass conformsToProtocol:@protocol(BenchmarkTestProtocol)]
			&& [benchmarkClass isInheritedFromClass:[BenchmarkTest class]])
		{
			// run benchmark with class
			BenchmarkTest<BenchmarkTestProtocol> *benchmarkObject = [[benchmarkClass alloc] init];
			benchmarkObject.collection = array;
			[benchmarkObject prepareData];
			
			NSDictionary *readingResult = [benchmarkObject runBenchmarkReading];
			NSDictionary *writingResult = [benchmarkObject runBenchmarkWriting];
			
			
			if (readingResult != nil
				&& writingResult != nil)
			{
				[readingResults  addObject:readingResult];
				[writingResults addObject:writingResult];
			}
			else
			{
				NSLog(@"ERROR: missing benchmark results from class: %@", benchmarkClass);
			}
		}
		else
		{
			NSLog(@"ERROR: runnning benchmark with class: %@", benchmarkClass);
		}
		
		[pool drain];
		pool = nil;	
	}
	
	// Sort results
	[readingResults sortUsingFunction:_compareResults context:nil];
	[writingResults sortUsingFunction:_compareResults context:nil];
	
	// Post notification
	NSDictionary *allResults = [[NSDictionary alloc] initWithObjectsAndKeys:
								readingResults, JBReadingKey,
								writingResults, JBWritingKey,
								nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:JBDidFinishBenchmarksNotification object:allResults];
	
	// Clean up
	[readingResults release];
	[writingResults release];
	[allResults release];
}

@end
