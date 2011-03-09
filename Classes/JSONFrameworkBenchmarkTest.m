//
//  JSONFrameworkBenchmarkTest.m
//  JSONBenchmarks
//
//  Created by Martin Brugger on 26.02.11.
//  Copyright 2011 Sam Soffes. All rights reserved.
//

#import "JSONFrameworkBenchmarkTest.h"
#import "SBJsonParser.h"
#import "SBJsonWriter.h"

@implementation JSONFrameworkBenchmarkTest

- (NSString *)benchmarkName
{
	return @"JSON Framework";
}

- (NSDictionary *)runBenchmarkReading
{
	NSDictionary *readingResult = nil;
	SBJsonParser *sbjsonParser = [[SBJsonParser new] autorelease];
	bench(self.benchmarkName, @"read", ^{ x([sbjsonParser objectWithData:self.JSONData]); }, &readingResult);
	return readingResult;
}

- (NSDictionary *)runBenchmarkWriting
{
	NSDictionary *writingResult = nil;
	SBJsonWriter *sbjsonWriter = [[SBJsonWriter new] autorelease];
	bench(self.benchmarkName, @"write", ^{ x([sbjsonWriter dataWithObject:self.collection]); }, &writingResult);
	return writingResult;
}

- (NSUInteger)serializedSize
{
	SBJsonWriter *sbjsonWriter = [[SBJsonWriter new] autorelease];
	return [sbjsonWriter dataWithObject:self.collection].length;
}


@end
