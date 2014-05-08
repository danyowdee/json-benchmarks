//
//  AppleJSONBenchmarkTest.m
//  JSONBenchmarks
//
//  Created by Martin Brugger on 26.02.11.
//  Copyright 2011 Sam Soffes. All rights reserved.
//

#import "AppleJSONBenchmarkTest.h"

@implementation AppleJSONBenchmarkTest

- (NSString *)benchmarkName
{
	return @"Apple JSON";
}

- (JBTestResult *)runBenchmarkReading
{
	return bench(self.benchmarkName, @"read", ^{ x([NSJSONSerialization JSONObjectWithData:self.JSONData options:0 error:nil]); });
}

- (JBTestResult *)runBenchmarkWriting
{
	return bench(self.benchmarkName, @"write", ^{ x([NSJSONSerialization dataWithJSONObject:self.collection options:0 error:nil]); });
}

- (NSUInteger)serializedSize
{
	return [[NSJSONSerialization dataWithJSONObject:self.collection options:0 error:nil] length];
}


@end
