//
//  BenchmarkTest.h
//  JSONBenchmarks
//
//  Created by Martin Brugger on 25.02.11.
//  Copyright 2011 Sam Soffes. All rights reserved.
//

#import "JBTestResult.h"

JBTestResult *bench(NSString *what, NSString *direction, void (^block)(void));

// Number of iterations to run must be larger than 100!
#define kIterations 100

// Run five times so block overhead is less of a factor
#define x(x) do { x; x; x; x; x; } while (0)

// benchmark is executed on all classes implementing BenchmarkTestProtocol
@protocol BenchmarkTestProtocol
- (JBTestResult *)runBenchmarkReading;
- (JBTestResult *)runBenchmarkWriting;
- (NSUInteger)serializedSize;

@property (readonly) NSString *benchmarkName;
@end


@interface BenchmarkTest : NSObject {
	id collection;
}

@property (nonatomic, retain) id collection;
- (void)prepareData;
+ (NSArray *)benchmarkTestClasses;

+ (void)runBenchmarksWithArrayCollectionIncludingReads:(BOOL)shouldIncludeReads includingWrites:(BOOL)shouldIncludeWrites;
+ (void)runBenchmarksWithDictionaryCollectionIncludingReads:(BOOL)shouldIncludeReads includingWrites:(BOOL)shouldIncludeWrites;
+ (void)runBenchmarksWithTwitterJSONDataIncludingReads:(BOOL)shouldIncludeReads includingWrites:(BOOL)shouldIncludeWrites;
+ (void)runBenchmarksWithCollection:(id)theCollection includeReading:(BOOL)shouldIncludeReading includeWriting:(BOOL)shouldIncludeWriting;
+ (void)cancelRunningBenchmark;

@end

#pragma mark - Notifications:

// Notification names
extern NSString *const JBDidFinishBenchmarksNotification;
extern NSString * const JBBenchmarkSuiteDidChangeNotification;
extern NSString * const JBRunningBenchmarkDidProgressNotificaton;

// Keys
extern NSString *const JBReadingKey;
extern NSString *const JBWritingKey;
extern NSString *const JBLibraryKey;
extern NSString *const JBAverageTimeKey;

extern NSString * const JBBenchmarkSuiteNameKey;
extern NSString * const JBBenchmarkSuiteStatusStringKey;

extern NSString * const JBRunningBenchmarkProgressKey; // An NSNumber — [0,1)
