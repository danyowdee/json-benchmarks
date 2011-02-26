//
//  AppleJSONBenchmarkTest.m
//  JSONBenchmarks
//
//  Created by Martin Brugger on 26.02.11.
//  Copyright 2011 Sam Soffes. All rights reserved.
//

#import "AppleJSONBenchmarkTest.h"
#import "JSONParser.h"
#import "JSONWriter.h"

@implementation AppleJSONBenchmarkTest

- (NSString *)benchmarkName
{
	return @"Apple JSON";
}

- (NSDictionary *)runBenchmarkReading
{
	NSDictionary *readingResult = nil;
	xbench(self.benchmarkName, @"read", ^{ x([JSON objectWithData:self.JSONData options:0 error:nil]); }, &readingResult);
	return readingResult;
}

- (NSDictionary *)runBenchmarkWriting
{
	NSDictionary *writingResult = nil;
	xbench(self.benchmarkName, @"write", ^{ x([JSON stringWithObject:self.collection options:0 error:nil]); }, &writingResult);
	return writingResult;
}

@end
