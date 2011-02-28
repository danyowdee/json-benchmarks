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
#import "CJSONDeserializer.h"
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
	
//	NSStringEncoding stringEncoding = NSUTF8StringEncoding;
//	NSStringEncoding dataEncoding = stringEncoding; // NSUTF32BigEndianStringEncoding;	
//	
//	NSString *jsonString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"twitter_public_timeline" ofType:@"json"] encoding:stringEncoding error:nil];
//	NSData *jsonData = [jsonString dataUsingEncoding:dataEncoding];
//	self.JSONData = jsonData;
//	self.collection = (NSArray *)[[CJSONDeserializer deserializer] deserialize:jsonData error:nil];
	
	self.JSONData = [JSON dataWithObject:self.collection options:0 encoding:NSUTF8StringEncoding error:NULL];
	
	
	NSAssert1(error == nil, @"JSONBenchmarkTest - prepareData: error serializing data: %@", error);
}


@end
