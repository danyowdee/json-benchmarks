//
//  JBAppDelegate.m
//  JSONBenchmarks
//
//  Created by Sam Soffes on 11/4/09.
//  Copyright 2009 Sam Soffes. All rights reserved.
//

#import "JBAppDelegate.h"
#import "JBResultsViewController.h"
#import "BenchmarkTest.h"
#import "BenchmarkProgressViewController.h"

@implementation JBAppDelegate

#pragma mark NSObject

- (void)dealloc {
	[_navigationController release];
	[_window release];
	[super dealloc];
}


#pragma mark UIApplicationDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	// Setup UI
	_window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	BenchmarkProgressViewController *benchmarkProgressViewController = [[BenchmarkProgressViewController alloc] init];
	_navigationController = [[UINavigationController alloc] initWithRootViewController:benchmarkProgressViewController];
	[_window addSubview:_navigationController.view];
	[_window makeKeyAndVisible];
	[benchmarkProgressViewController release];
}

@end
