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
}

@property (nonatomic, retain) UILabel *frameworkNameLabel;
@property (nonatomic, retain) UILabel *frameworkCountLabel;
@property (nonatomic, retain) UILabel *benchmarkDirectionLabel;
@property (nonatomic, retain) UIProgressView *overallProgressView;
@property (nonatomic, retain) UIProgressView *currentFrameworkProgressView;

+ (BenchmarkProgressViewController *)instance;

@end
