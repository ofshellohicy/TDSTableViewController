//
//  TestViewController.m
//  TDSTableViewController
//
//  Created by zhong sheng on 12-6-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TestViewController.h"
#import "TestTableViewDataSource.h"
@interface TestViewController ()

@end

@implementation TestViewController

- (void)createModel
{
    [super createModel];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsPullToRefresh = YES;
    self.dataSource = [[[TestTableViewDataSource alloc] init] autorelease];
//    [self showError:YES];
}

- (void)pullToRefreshAction
{
    [self performSelector:@selector(stopRefreshAction) withObject:nil afterDelay:2.0f];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
