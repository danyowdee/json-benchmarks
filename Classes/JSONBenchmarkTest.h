//
//  JSONBenchmarkTest.h
//  JSONBenchmarks
//
//  Created by Martin Brugger on 25.02.11.
//  Copyright 2011 Sam Soffes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BenchmarkTest.h"

@interface JSONBenchmarkTest : BenchmarkTest {
	NSData *JSONData;
}

@property (nonatomic, retain) NSData *JSONData;

@end
