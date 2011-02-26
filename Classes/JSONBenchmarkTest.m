//
//  JSONBenchmarkTest.m
//  JSONBenchmarks
//
//  Created by Martin Brugger on 25.02.11.
//  Copyright 2011 Sam Soffes. All rights reserved.
//

#import "JSONBenchmarkTest.h"
#import "CJSONSerializer.h"

@implementation JSONBenchmarkTest

@synthesize JSONData;

- (void) dealloc
{
	[JSONData release];
	JSONData = nil;
	[super dealloc];
}


- (void)prepareData
{
	NSError *error = nil;
	self.JSONData = [[CJSONSerializer serializer] serializeObject:self.collection error:&error];
	NSAssert1(error == nil, @"JSONBenchmarkTest - prepareData: error serializing data: %@", error);
}


@end
