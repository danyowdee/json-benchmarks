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

- (JBTestResult *)runBenchmarkReading
{
	return bench(self.benchmarkName, @"read", ^{ x([self.JSONData yajl_JSON]); });
}

- (JBTestResult *)runBenchmarkWriting
{
	return bench(self.benchmarkName, @"write", ^{ x([self.collection yajl_JSONString]); });
}

- (NSUInteger)serializedSize
{
	return [self.collection yajl_JSONString].length;
}


@end
