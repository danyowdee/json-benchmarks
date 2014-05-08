//
//  BenchmarkProgressViewController.h
//  JSONBenchmarks
//
//  Created by Martin Brugger on 26.02.11.
//  Copyright 2011 Sam Soffes. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JBResultsViewController.h"

@interface BenchmarkProgressViewController : UIViewController

- (IBAction)runDictionaryBenchmark;
- (IBAction)runArrayBenchmark;
- (IBAction)runJSONBenchmark;
- (IBAction)cancelBenchmark;

- (void)resetBenchmark;

@end
