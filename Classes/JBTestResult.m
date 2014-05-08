//
//  JBTestResult.m
//  JSONBenchmarks
//
//  Created by Daniel Demiss on 07.05.14.
//  Copyright (c) 2014 Sam Soffes. All rights reserved.
//

#import "JBTestResult.h"

@implementation JBTestResult {
    double _duration;
}

- (id)initWithSuiteName:(NSString *)name averageDuration:(double)milliseconds
{
    if (!(self = [super init]))
        return nil;

    _suiteName = [name copy];
    _duration = milliseconds;
    _durationString = [NSString stringWithFormat:@"%.03f ms", milliseconds];

    return self;
}

- (NSComparisonResult)compareToTestResult:(JBTestResult *)other
{
    double mine = _duration, theirs = other->_duration;
    if (mine > theirs)
        return NSOrderedDescending;

    if (mine < theirs)
        return NSOrderedAscending;

    // _Really_ unlikely but possible
    return NSOrderedSame;
}

#pragma mark - NSObject:
- (id)init
{
    return [self initWithSuiteName:nil averageDuration:0];
}

- (NSString *)debugDescription
{
    return [NSString stringWithFormat:@"%@ Suite = %@, avg: %@", [super debugDescription], self.suiteName, self.durationString];
}

@end
