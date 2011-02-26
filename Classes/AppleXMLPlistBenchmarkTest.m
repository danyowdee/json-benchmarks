//
//  AppleXMLPlistBenchmarkTest.m
//  JSONBenchmarks
//
//  Created by Martin Brugger on 26.02.11.
//  Copyright 2011 Sam Soffes. All rights reserved.
//

#import "AppleXMLPlistBenchmarkTest.h"


@implementation AppleXMLPlistBenchmarkTest

@synthesize xmlPlistData;

- (void) dealloc
{
	[xmlPlistData release];
	xmlPlistData = nil;
	[super dealloc];
}


- (void)prepareData
{
	NSString *errorDescription = nil;
	self.xmlPlistData = [NSPropertyListSerialization dataFromPropertyList:self.collection
																	  format:NSPropertyListXMLFormat_v1_0
															errorDescription:&errorDescription];
	NSAssert1(self.xmlPlistData != nil, @"error serializing array: %@", errorDescription);
	
}

- (NSString *)benchmarkName
{
	return @"Apple XML plist";
}

- (NSDictionary *)runBenchmarkReading
{
	NSDictionary *readingResult = nil;
	xbench(self.benchmarkName, @"read", ^{ x([NSPropertyListSerialization propertyListWithData:xmlPlistData 
																					   options:NSPropertyListImmutable 
																						format:NULL 
																						 error:NULL]);}, &readingResult);
	return readingResult;
}

- (NSDictionary *)runBenchmarkWriting
{
	NSDictionary *writingResult = nil;
	
	xbench(self.benchmarkName, @"write", ^{ x([NSPropertyListSerialization dataFromPropertyList:self.collection
																						 format:NSPropertyListXMLFormat_v1_0
																			   errorDescription:NULL]);}, &writingResult);
	
	return writingResult;
}

@end
