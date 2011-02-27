//
//  JSONBenchmarkTest.m
//  JSONBenchmarks
//
//  Created by Martin Brugger on 25.02.11.
//  Copyright 2011 Sam Soffes. All rights reserved.
//

#import "JSONBenchmarkTest.h"
#import "JSONParser.h"
#import "JSONWriter.h"

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
	self.JSONData = [JSON dataWithObject:self.collection options:0 encoding:NSUTF8StringEncoding error:NULL];
	NSAssert1(error == nil, @"JSONBenchmarkTest - prepareData: error serializing data: %@", error);
}


@end
