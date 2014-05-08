//
//  JBTestResult.h
//  JSONBenchmarks
//
//  Created by Daniel Demiss on 07.05.14.
//  Copyright (c) 2014 Sam Soffes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JBTestResult : NSObject

- (id)initWithSuiteName:(NSString *)name averageDuration:(double)milliseconds;
@property (readonly, nonatomic) NSString *suiteName;
@property (readonly, nonatomic) NSString *durationString;

- (NSComparisonResult)compareToTestResult:(JBTestResult *)other;

@end
