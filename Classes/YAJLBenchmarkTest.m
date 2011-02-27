//
//  YAJLBenchmarkTest.m
//  JSONBenchmarks
//
//  Created by Martin Brugger on 26.02.11.
//  Copyright 2011 Sam Soffes. All rights reserved.
//

#import "YAJLBenchmarkTest.h"
#import "NSObject+YAJL.h"

@implementation YAJLBenchmarkTest

- (NSString *)benchmarkName
{
	return @"YAJL";
}

- (NSDictionary *)runBenchmarkReading
{
	NSDictionary *readingResult = nil;
	bench(self.benchmarkName, @"read", ^{ x([self.JSONData yajl_JSON]); }, &readingResult);
	return readingResult;
}

- (NSDictionary *)runBenchmarkWriting
{
	NSDictionary *writingResult = nil;
	bench(self.benchmarkName, @"write", ^{ x([self.collection yajl_JSONString]); }, &writingResult);
	return writingResult;
}


@end
