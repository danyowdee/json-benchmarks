//
//  AppleBinaryPlistBenchmarkTest.m
//  JSONBenchmarks
//
//  Created by Martin Brugger on 25.02.11.
//  Copyright 2011 Sam Soffes. All rights reserved.
//

#import "AppleBinaryPlistBenchmarkTest.h"


@implementation AppleBinaryPlistBenchmarkTest

@synthesize binaryPlistData;

- (void)prepareData
{
	NSString *errorDescription = nil;
	self.binaryPlistData = [NSPropertyListSerialization dataFromPropertyList:self.collection
																		 format:NSPropertyListBinaryFormat_v1_0
															   errorDescription:&errorDescription];
	//NSAssert1(binaryPlistData != nil, @"error serializing array: %@", errorDescription);
}

- (NSString *)benchmarkName
{
	return @"Apple Binary plist";
}

- (JBTestResult *)runBenchmarkReading
{
	if (!self.binaryPlistData)
		return nil;

	return bench(self.benchmarkName, @"read", ^{ x([NSPropertyListSerialization propertyListWithData:binaryPlistData
																						 options:NSPropertyListImmutable 
																						  format:NULL 
																						   error:NULL]);});
}

- (JBTestResult *)runBenchmarkWriting
{
	if (!self.binaryPlistData)
		return nil;

	return bench(self.benchmarkName, @"write", ^{ x([NSPropertyListSerialization dataFromPropertyList:self.collection
																						 format:NSPropertyListBinaryFormat_v1_0
																			   errorDescription:NULL]);});
}

- (NSUInteger)serializedSize
{
	return [NSPropertyListSerialization dataFromPropertyList:self.collection
													  format:NSPropertyListBinaryFormat_v1_0
											errorDescription:NULL].length;
}

@end
