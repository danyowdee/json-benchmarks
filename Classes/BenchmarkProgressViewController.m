//
//  BenchmarkProgressViewController.m
//  JSONBenchmarks
//
//  Created by Martin Brugger on 26.02.11.
//  Copyright 2011 Sam Soffes. All rights reserved.
//

#import "BenchmarkProgressViewController.h"
#import "BenchmarkTest.h"

static BenchmarkProgressViewController *instance;

@implementation BenchmarkProgressViewController

@synthesize frameworkNameLabel, frameworkCountLabel, benchmarkDirectionLabel, overallProgressView, currentFrameworkProgressView, cancelBenchmarkPressed;

 - (id) init
 {
	 self = [super init];
	 if (self != nil)
	 {
		 NSAssert(instance == nil, @"ERROR: BenchmarkProgressViewController object already exists!");
		 instance = self;
	 }
	 return self;
 }


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self resetBenchmark];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc 
{	
	[frameworkNameLabel release]; frameworkNameLabel = nil;
	[frameworkCountLabel release]; frameworkCountLabel = nil;
	[benchmarkDirectionLabel release]; benchmarkDirectionLabel = nil;
	[overallProgressView release]; overallProgressView = nil;
	[currentFrameworkProgressView release]; currentFrameworkProgressView = nil;
	
    [super dealloc];
}

+ (BenchmarkProgressViewController *)instance
{
	if (instance == nil)
	{
		NSAssert(NO, @"ERROR: BenchmarkProgressViewController object not found!");
//		instance = [[BenchmarkProgressViewController alloc] init];
	}
	return instance;
}

#pragma mark -
#pragma mark UI Actions

- (IBAction)runDictionaryBenchmark
{
	cancelBenchmarkPressed = NO;
	[BenchmarkTest runBenchmarksWithDictionaryCollection];
}

- (IBAction)runArrayBenchmark
{
	cancelBenchmarkPressed = NO;
	[BenchmarkTest runBenchmarksWithArrayCollection];	
}

- (IBAction)runJSONBenchmark
{
	cancelBenchmarkPressed = NO;	
	[BenchmarkTest runBenchmarksWithTwitterJSONData];		
}

- (IBAction)cancelBenchmark
{
	cancelBenchmarkPressed = YES;
}

- (void)resetBenchmark
{
	frameworkNameLabel.text = nil;
	frameworkCountLabel.text = nil;
	benchmarkDirectionLabel.text = nil;
	overallProgressView.progress = 0.0;
	currentFrameworkProgressView.progress = 0.0;
}

@end
