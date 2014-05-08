//
//  BenchmarkProgressViewController.m
//  JSONBenchmarks
//
//  Created by Martin Brugger on 26.02.11.
//  Copyright 2011 Sam Soffes. All rights reserved.
//

#import "BenchmarkProgressViewController.h"
#import "BenchmarkTest.h"

@interface BenchmarkProgressViewController ()

@property (nonatomic) IBOutlet UILabel *frameworkNameLabel;
@property (nonatomic) IBOutlet UILabel *frameworkCountLabel;
@property (nonatomic) IBOutlet UILabel *benchmarkDirectionLabel;
@property (nonatomic) IBOutlet UIProgressView *overallProgressView;
@property (nonatomic) IBOutlet UIProgressView *currentFrameworkProgressView;
@property (nonatomic) IBOutlet UISwitch *readSwitch;
@property (nonatomic) IBOutlet UISwitch *writeSwitch;

@end

@implementation BenchmarkProgressViewController

 - (id) init
 {
	 self = [super init];
	 if (self != nil)
	 {
         NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
         [center addObserver:self selector:@selector(benchmarkDidChange:) name:JBBenchmarkSuiteDidChangeNotification object:nil];
         [center addObserver:self selector:@selector(benchmarkDidProgress:) name:JBRunningBenchmarkDidProgressNotificaton object:nil];
         [center addObserver:self selector:@selector(benchmarkDidFinish:) name:JBDidFinishBenchmarksNotification object:nil];
	 }

	 return self;
 }


- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self resetBenchmark];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -
#pragma mark UI Actions

- (IBAction)runDictionaryBenchmark
{
	[BenchmarkTest runBenchmarksWithDictionaryCollectionIncludingReads:[self.readSwitch isOn] includingWrites:[self.writeSwitch isOn]];
}

- (IBAction)runArrayBenchmark
{
	[BenchmarkTest runBenchmarksWithArrayCollectionIncludingReads:[self.readSwitch isOn] includingWrites:[self.writeSwitch isOn]];
}

- (IBAction)runJSONBenchmark
{
	[BenchmarkTest runBenchmarksWithTwitterJSONDataIncludingReads:[self.readSwitch isOn] includingWrites:[self.writeSwitch isOn]];
}

- (IBAction)cancelBenchmark
{
	[BenchmarkTest cancelRunningBenchmark];
}

- (void)resetBenchmark
{
	self.frameworkNameLabel.text = nil;
	self.frameworkCountLabel.text = nil;
	self.benchmarkDirectionLabel.text = nil;
	self.overallProgressView.progress = 0.0;
	self.currentFrameworkProgressView.progress = 0.0;
}

#pragma mark - Notification Handlers:

static inline void async_if_necessary(dispatch_block_t block) {
    if ([NSThread isMainThread])
        block();
    else
        dispatch_async(dispatch_get_main_queue(), block);
}

- (void)benchmarkDidChange:(NSNotification *)note
{
    async_if_necessary(^{
        NSDictionary *info = [note userInfo];
        self.frameworkNameLabel.text = info[JBBenchmarkSuiteNameKey];
        self.frameworkCountLabel.text = info[JBBenchmarkSuiteStatusStringKey];
        NSNumber *overallProgress = info[JBRunningBenchmarkProgressKey];
        if (overallProgress) {
            self.overallProgressView.progress = [overallProgress floatValue];
        }
    });
}

- (void)benchmarkDidProgress:(NSNotification *)note
{
    async_if_necessary(^{
        self.currentFrameworkProgressView.progress = [note.userInfo[JBRunningBenchmarkProgressKey] floatValue];
    });
}

- (void)benchmarkDidFinish:(NSNotification *)note
{
    async_if_necessary(^{
        [self resetBenchmark];

        NSDictionary *info = [note userInfo];
        NSArray *readerResults = [info objectForKey:JBReadingKey];
        NSArray *writerResults = [info objectForKey:JBWritingKey];
        if (!readerResults
            && !writerResults)
            return;

        JBResultsViewController *detail = [JBResultsViewController new];
        detail.resultsFromReading = readerResults;
        detail.resultsFromWriting = writerResults;

        [self.navigationController pushViewController:detail animated:YES];
    });
}

@end
