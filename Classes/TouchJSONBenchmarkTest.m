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

- (JBTestResult *)runBenchmarkReading
{
	CJSONDeserializer *cjsonDeserialiser = [CJSONDeserializer deserializer];
	return bench(self.benchmarkName, @"read", ^{ x([cjsonDeserialiser deserialize:self.JSONData error:nil]); });
}

- (JBTestResult *)runBenchmarkWriting
{
	CJSONSerializer *cjsonSerializer = [CJSONSerializer serializer];
	return bench(self.benchmarkName, @"write", ^{ x([cjsonSerializer serializeArray:self.collection error:nil]); });
}

- (NSUInteger)serializedSize
{
	CJSONSerializer *cjsonSerializer = [CJSONSerializer serializer];
	return [cjsonSerializer serializeArray:self.collection error:nil].length;
}


@end
