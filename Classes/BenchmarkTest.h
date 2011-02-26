//
//  BenchmarkTest.h
//  JSONBenchmarks
//
//  Created by Martin Brugger on 25.02.11.
//  Copyright 2011 Sam Soffes. All rights reserved.
//

void xbench(NSString *what, NSString *direction, void (^block)(void), NSDictionary **result);

// Number of iterations to run
#define kIterations 100

// Run five times so block overhead is less of a factor
#define x(x) do { x; x; x; x; x; } while (0)

// benchmark is executed on all classes implementing BenchmarkTestProtocol
@protocol BenchmarkTestProtocol
- (NSDictionary *)runBenchmarkReading;
- (NSDictionary *)runBenchmarkWriting;

@property (readonly) NSString *benchmarkName;
@end


@interface BenchmarkTest : NSObject {
	id collection;
}

@property (nonatomic, retain) id collection;
- (void)prepareData;
+ (NSArray *)benchmarkTestClasses;

+ (void)runBenchmarks;
@end
