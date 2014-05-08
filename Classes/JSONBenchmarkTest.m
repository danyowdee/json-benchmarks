//
//  JSONBenchmarkTest.m
//  JSONBenchmarks
//
//  Created by Martin Brugger on 25.02.11.
//  Copyright 2011 Sam Soffes. All rights reserved.
//

#import "JSONBenchmarkTest.h"

@implementation JSONBenchmarkTest

@synthesize JSONData;

- (void)prepareData
{
	NSError *error = nil;
	
	self.JSONData = [NSJSONSerialization dataWithJSONObject:self.collection options:0 error:NULL];

	NSAssert1(error == nil, @"JSONBenchmarkTest - prepareData: error serializing data: %@", error);
}


@end
