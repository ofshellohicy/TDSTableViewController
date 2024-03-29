//
//  TDSTableViewController.h
//  icePhone
//
//  Created by zhong sheng on 12-5-28.
//  Copyright (c) 2012年 icePhone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDSViewController.h"

@class TDSTableViewDataSource;
@class TDSSearchDisplayController;

@interface TDSTableViewController : TDSViewController<UITableViewDelegate>{
    UITableView*  _tableView;
    UIView*       _tableOverlayView;
    UIView*       _loadingView;
    UIView*       _errorView;
    UIView*       _emptyView;
    
    NSTimer*      _bannerTimer;
    
    UITableViewStyle        _tableViewStyle;
    
    UIInterfaceOrientation  _lastInterfaceOrientation;
    
    BOOL _showTableShadows;
    
    TDSTableViewDataSource *_dataSource;
    
    TDSSearchDisplayController  *_searchController;
    
}

@property (nonatomic, retain) NSError *error;
@property (nonatomic, assign) BOOL loadingData;   // 默认是NO, 载入数据时为YES,主要防止load more多次使用
@property (nonatomic, retain) UITableView* tableView;
@property (nonatomic, retain)TDSTableViewController *searchViewController;

/**
 * A view that is displayed over the table view.
 */
@property (nonatomic, retain) UIView* tableOverlayView;

@property (nonatomic, retain) UIView* loadingView;
@property (nonatomic, retain) UIView* errorView;
@property (nonatomic, retain) UIView* emptyView;

/**
 * The data source used to populate the table view.
 *
 * Setting dataSource has the side effect of also setting model to the value of the
 * dataSource's model property.
 */
@property (nonatomic, retain) TDSTableViewDataSource *dataSource;

/**
 * The style of the table view.
 */
@property (nonatomic) UITableViewStyle tableViewStyle;

/**
 * When enabled, draws gutter shadows above the first table item and below the last table item.
 *
 * Known issues: When there aren't enough cell items to fill the screen, the table view draws
 * empty cells for the remaining space. This causes the bottom shadow to appear out of place.
 */
@property (nonatomic) BOOL showTableShadows;

/**
 * Initializes and returns a controller having the given style.
 */
- (id)initWithStyle:(UITableViewStyle)style;

/**
 * Tells the controller that the user selected an object in the table.
 *
 * By default, the object's URLValue will be opened in TTNavigator, if it has one. If you don't
 * want this to be happen, be sure to override this method and be sure not to call super.
 */
- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath*)indexPath;


/**
 * Tells the controller that the user began dragging the table view.
 */
- (void)didBeginDragging;

/**
 * Tells the controller that the user stopped dragging the table view.
 */
- (void)didEndDragging;

/**
 * The rectangle where the overlay view should appear.
 */
- (CGRect)rectForOverlayView;

/**
 * 下拉刷新需要执行的方法
 */
- (void)pullToRefreshAction;
/**
 * 重置下拉刷新状态
 */
- (void)stopRefreshAction;

- (void)refreshTable;

/**
 * 状态显示
 */

- (void)showEmpty:(BOOL)show;
- (void)showLoading:(BOOL)show;
- (void)showError:(BOOL)show;
/**
 * 搜索
 */

- (void)search:(NSString*)kw;
- (void)cancelSearch;

@end

