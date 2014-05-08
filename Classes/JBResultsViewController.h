//
//  JBResultsViewController.h
//  JSONBenchmarks
//
//  Created by Sam Soffes on 9/12/10.
//  Copyright 2010 Sam Soffes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JBTestResult.h"

@interface JBResultsViewController : UITableViewController

@property (copy, nonatomic) NSArray *resultsFromReading;
@property (copy, nonatomic) NSArray *resultsFromWriting;

@end
