//
//  CJSONBenchmarkTest.m
//  JSONBenchmarks
//
//  Created by Martin Brugger on 26.02.11.
//  Copyright 2011 Sam Soffes. All rights reserved.
//

#import "TouchJSONBenchmarkTest.h"
#import "CJSONDeserializer.h"
#import "CJSONSerializer.h"

@implementation TouchJSONBenchmarkTest

- (NSString *)benchmarkName
{
	return @"TouchJSON";
}

- (NSDictionary *)runBenchmarkReading
{
	NSDictionary *readingResult = nil;
	CJSONDeserializer *cjsonDeserialiser = [CJSONDeserializer deserializer];
	bench(self.benchmarkName, @"read", ^{ x([cjsonDeserialiser deserialize:self.JSONData error:nil]); }, &readingResult);
	return readingResult;
}

- (NSDictionary *)runBenchmarkWriting
{
	NSDictionary *writingResult = nil;
	CJSONSerializer *cjsonSerializer = [CJSONSerializer serializer];
	bench(self.benchmarkName, @"write", ^{ x([cjsonSerializer serializeArray:self.collection error:nil]); }, &writingResult);
	return writingResult;
}

- (NSUInteger)serializedSize
{
	CJSONSerializer *cjsonSerializer = [CJSONSerializer serializer];
	return [cjsonSerializer serializeArray:self.collection error:nil].length;
}


@end
