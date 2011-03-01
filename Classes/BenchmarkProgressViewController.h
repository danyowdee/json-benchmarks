//
//  BenchmarkProgressViewController.h
//  JSONBenchmarks
//
//  Created by Martin Brugger on 26.02.11.
//  Copyright 2011 Sam Soffes. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BenchmarkProgressViewController : UIViewController 
{
	IBOutlet UILabel *frameworkNameLabel;
	IBOutlet UILabel *frameworkCountLabel;
	IBOutlet UILabel *benchmarkDirectionLabel;
	IBOutlet UIProgressView *overallProgressView;
	IBOutlet UIProgressView *currentFrameworkProgressView;
	
	IBOutlet UISwitch *readSwitch;
	IBOutlet UISwitch *writeSwitch;
	BOOL cancelBenchmarkPressed;
}

@property (nonatomic, retain) UILabel *frameworkNameLabel;
@property (nonatomic, retain) UILabel *frameworkCountLabel;
@property (nonatomic, retain) UILabel *benchmarkDirectionLabel;
@property (nonatomic, retain) UIProgressView *overallProgressView;
@property (nonatomic, retain) UIProgressView *currentFrameworkProgressView;
@property (nonatomic, retain) UISwitch *readSwitch;
@property (nonatomic, retain) UISwitch *writeSwitch;

@property (assign) BOOL cancelBenchmarkPressed;


+ (BenchmarkProgressViewController *)instance;

- (IBAction)runDictionaryBenchmark;
- (IBAction)runArrayBenchmark;
- (IBAction)runJSONBenchmark;
- (IBAction)cancelBenchmark;

- (void)resetBenchmark;
@end
