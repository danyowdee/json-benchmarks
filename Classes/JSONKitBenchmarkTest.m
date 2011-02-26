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

- (NSDictionary *)runBenchmarkReading
{
	NSDictionary *readingResult = nil;
	JSONDecoder *jsonKitDecoder = [JSONDecoder decoder];
	xbench(self.benchmarkName, @"read", ^{ x([jsonKitDecoder parseJSONData:self.JSONData]); }, &readingResult);
	return readingResult;
}

- (NSDictionary *)runBenchmarkWriting
{
	NSDictionary *writingResult = nil;
	xbench(self.benchmarkName, @"write", ^{ x([self.collection JSONString]); }, &writingResult);
	return writingResult;
}


@end
