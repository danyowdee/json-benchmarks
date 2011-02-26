//
//  JBAppDelegate.m
//  JSONBenchmarks
//
//  Created by Sam Soffes on 11/4/09.
//  Copyright 2009 Sam Soffes. All rights reserved.
//

#import "JBAppDelegate.h"
#import "JBResultsViewController.h"
#import "JBConstants.h"

#import "JSONParser.h"
#import "JSONWriter.h"

#import "SBStatistics.h"

#import "NSObject+Introspection.h"
#import "JSONKitBenchmarkTest.h"


// Comparer function for sorting
static int _compareResults(NSDictionary *result1, NSDictionary *result2, void *context) {
	return [[result1 objectForKey:JBAverageTimeKey] compare:[result2 objectForKey:JBAverageTimeKey]];
}



@implementation JBAppDelegate

#pragma mark NSObject

- (void)dealloc {
	[_navigationController release];
	[_window release];
	[super dealloc];
}

#pragma mark Benchmarking


- (void)benchmark {
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


#pragma mark UIApplicationDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	// Setup UI
	_window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	JBResultsViewController *viewController = [[JBResultsViewController alloc] init];
	_navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
	[viewController release];
	[_window addSubview:_navigationController.view];
	[_window makeKeyAndVisible];
	
	// Perform after delay so UI doesn't block
	[self performSelector:@selector(benchmark) withObject:nil afterDelay:0.1];
}

@end
