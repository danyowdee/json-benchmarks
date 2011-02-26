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

@end
