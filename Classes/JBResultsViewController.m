//
//  JBResultsViewController.m
//  JSONBenchmarks
//
//  Created by Sam Soffes on 9/12/10.
//  Copyright 2010 Sam Soffes. All rights reserved.
//

#import "JBResultsViewController.h"

@implementation JBResultsViewController  {
	UISegmentedControl *_segmentedControl;
}


#pragma mark NSObject

- (id)init {
    return [super initWithStyle:UITableViewStyleGrouped];
}

#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Segmented control
	NSArray *items = [[NSArray alloc] initWithObjects:@"Reading", @"Writing", nil];
	_segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
	_segmentedControl.selectedSegmentIndex = 0;
	_segmentedControl.frame = CGRectMake(0.0, 0.0, 300.0, 32.0);
	[_segmentedControl addTarget:self.tableView action:@selector(reloadData) forControlEvents:UIControlEventValueChanged];
	
	self.navigationItem.titleView = _segmentedControl;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		return YES;
	}
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


#pragma mark Private Methods

- (NSArray *)_results {
    if (_segmentedControl.selectedSegmentIndex == 0)
        return self.resultsFromReading;

	return self.resultsFromWriting;
}


#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self _results] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
	JBTestResult *result = [[self _results] objectAtIndex:indexPath.row];
	cell.textLabel.text = result.suiteName;
	cell.detailTextLabel.text = result.durationString;
    
    return cell;
}

@end
