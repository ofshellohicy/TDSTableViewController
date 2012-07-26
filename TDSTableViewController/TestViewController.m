//
//  TestViewController.m
//  TDSTableViewController
//
//  Created by zhong sheng on 12-6-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TestViewController.h"
#import "TestTableViewDataSource.h"
#import "TDSTextTableViewItem.h"
#import "TDSTableViewSectionObject.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)createModel
{
    [super createModel];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsPullToRefresh = YES;
//    self.tableView.showsInfiniteScrolling = YES;
    self.tableView.showsVerticalScrollIndicator = YES;
    
    NSMutableArray *sections= [NSMutableArray array];
    for (int i = 0; i<4; i++) {
        TDSTableViewSectionObject *sectionObject = [[TDSTableViewSectionObject alloc] init];
        sectionObject.title = [NSString stringWithFormat:@"%d",i];
        sectionObject.letter = sectionObject.title;
        NSMutableArray *aItems= [NSMutableArray array];
        for (int j = 0; j <4; j ++) {
            TDSTextTableViewItem *item = [TDSTextTableViewItem itemWithText:[NSString stringWithFormat:@"[%d][%d]",i,j]];
            [aItems addObject:item];
        }
        sectionObject.items = aItems;
        [sections addObject:sectionObject];
    }
    TestTableViewDataSource *testDataSource = [[TestTableViewDataSource alloc] init];
    self.dataSource = testDataSource;
    testDataSource.sections = sections;
    [testDataSource release];
//    [self showError:YES];
}

- (void)pullToRefreshAction
{
    [self performSelector:@selector(stopRefreshAction) withObject:nil afterDelay:2.0f];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.tableView.pullToRefreshView triggerRefresh];
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
