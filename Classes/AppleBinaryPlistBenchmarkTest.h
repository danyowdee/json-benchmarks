//
//  AppleBinaryPlistBenchmarkTest.h
//  JSONBenchmarks
//
//  Created by Martin Brugger on 25.02.11.
//  Copyright 2011 Sam Soffes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONBenchmarkTest.h"

@interface AppleBinaryPlistBenchmarkTest : JSONBenchmarkTest<BenchmarkTestProtocol> {
	NSData *binaryPlistData;
}

@property (nonatomic, retain) NSData *binaryPlistData;

@end
