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

@implementation JBAppDelegate

#pragma mark NSObject

- (void)dealloc {
	[_navigationController release];
	[_window release];
	[super dealloc];
}

#pragma mark Benchmarking


- (void)benchmark {
	[BenchmarkTest runBenchmarks];
}


#pragma mark UIApplicationDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	// Setup UI
	_window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	JBResultsViewController *viewController = [[JBResultsViewController alloc] init];
	_navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
	[viewController release];
	[_window addSubview:_navigationController.view];
	[_window makeKeyAndVisible];
	
	// Perform after delay so UI doesn't block
	[self performSelector:@selector(benchmark) withObject:nil afterDelay:0.1];
}

@end
