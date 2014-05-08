//
//  JSONKitBenchmarkTest.m
//  JSONBenchmarks
//
//  Created by Martin Brugger on 25.02.11.
//  Copyright 2011 Sam Soffes. All rights reserved.
//

#import "JSONKitBenchmarkTest.h"
#import "JSONKit.h"

@implementation JSONKitBenchmarkTest

- (NSString *)benchmarkName
{
	return @"JSONKit";
}

- (JBTestResult *)runBenchmarkReading
{
	JSONDecoder *jsonKitDecoder = [JSONDecoder decoder];
	return bench(self.benchmarkName, @"read", ^{ x([jsonKitDecoder parseJSONData:self.JSONData]); });
}

- (JBTestResult *)runBenchmarkWriting
{
	return bench(self.benchmarkName, @"write", ^{ x([self.collection JSONString]); });
}

- (NSUInteger)serializedSize
{
	return [self.collection JSONString].length;
}

@end
