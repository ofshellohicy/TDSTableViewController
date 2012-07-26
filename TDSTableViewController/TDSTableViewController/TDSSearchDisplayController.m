//
//  TDSSearchDisplayController.m
//  icePhone
//
//  Created by zhong sheng on 12-6-11.
//  Copyright (c) 2012年 icePhone. All rights reserved.
//

#import "TDSSearchDisplayController.h"
#import "TDSTableViewController.h"

@implementation TDSSearchDisplayController

@synthesize searchResultsViewController = _searchResultsViewController;

- (id)initWithSearchBar:(UISearchBar*)searchBar contentsController:(UIViewController*)controller {
  if (self = [super initWithSearchBar:searchBar contentsController:controller]) {
    self.delegate = self;
  }

  return self;
}

- (void)dealloc {

  RELEASE(_searchResultsViewController);
  [super dealloc];
}

#pragma mark -
#pragma mark Private


- (void)resetResults
{
	[_searchResultsViewController cancelSearch];
	[_searchResultsViewController search:nil];
	[_searchResultsViewController viewWillDisappear:NO];
	[_searchResultsViewController viewDidDisappear:NO];
	_searchResultsViewController.tableView = nil;
}


#pragma mark -
#pragma mark UISearchDisplayDelegate


- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController*)controller {
  self.searchContentsController.navigationItem.rightBarButtonItem.enabled = NO;
  
  id contenstController = controller.searchContentsController;
    if ([contenstController respondsToSelector:@selector(willBeginSearch)]) {
        [contenstController performSelector:@selector(willBeginSearch)];
    } 
}


- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller {}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
	self.searchContentsController.navigationItem.rightBarButtonItem.enabled = YES;

	id contenstController = controller.searchContentsController;

	if ([contenstController respondsToSelector:@selector(willEndSearch)]) {
		[contenstController performSelector:@selector(willEndSearch)];
	}
}
- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController*)controller {
  [self resetResults];
}


- (void)searchDisplayController:(UISearchDisplayController *)controller
        didLoadSearchResultsTableView:(UITableView *)tableView {
}


- (void)searchDisplayController:(UISearchDisplayController *)controller
        willUnloadSearchResultsTableView:(UITableView *)tableView {
}


- (void)searchDisplayController:(UISearchDisplayController *)controller
        didShowSearchResultsTableView:(UITableView *)tableView {
  _searchResultsViewController.tableView = tableView;
  [_searchResultsViewController viewWillAppear:NO];
  [_searchResultsViewController viewDidAppear:NO];
}


- (void)searchDisplayController:(UISearchDisplayController*)controller
 willHideSearchResultsTableView:(UITableView*)tableView {
    [self resetResults];
    
    id contenstController = controller.searchContentsController;
    if ([contenstController respondsToSelector:@selector(willHideSearchResult)]) {
        [contenstController performSelector:@selector(willHideSearchResult)];
    } 
}


- (BOOL)searchDisplayController:(UISearchDisplayController*)controller
        shouldReloadTableForSearchString:(NSString*)searchString {
    [_searchResultsViewController search:searchString];
  return NO;
}


- (BOOL)searchDisplayController:(UISearchDisplayController*)controller
        shouldReloadTableForSearchScope:(NSInteger)searchOption {
  [_searchResultsViewController search:self.searchBar.text];
  return NO;
}


#pragma mark -
#pragma mark Public

 
 

@end
