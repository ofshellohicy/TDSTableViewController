//
//  TDSTableViewController.m
//  icePhone
//
//  Created by zhong sheng on 12-5-28.
//  Copyright (c) 2012年 icePhone. All rights reserved.
//

#import "TDSTableViewController.h"
#import "TDSTableViewDataSource.h"
#import "TDSTableView.h"
#import "TDSTableViewCell.h"
#import "TDSErrorView.h"
#import "TDSTableViewLoadMoreItem.h"
#import "TDSTableViewLoadMoreCell.h"
#import "TDSSearchDisplayController.h"
 
@interface TDSTableViewController (delegate);

@end

@interface TDSTableViewController (Private);

- (void)loadMoreAction;

@end

@implementation TDSTableViewController
@synthesize error = _error;
@synthesize tableView           = _tableView;
@synthesize tableOverlayView    = _tableOverlayView;
@synthesize loadingView         = _loadingView;
@synthesize errorView           = _errorView;
@synthesize emptyView           = _emptyView;
@synthesize tableViewStyle      = _tableViewStyle;
@synthesize showTableShadows    = _showTableShadows;
@synthesize dataSource          = _dataSource;
@synthesize loadingData         = _loadingData;
@synthesize searchViewController   = _searchViewController;

- (id)initWithStyle:(UITableViewStyle)style
{
    _tableViewStyle = style;
    _loadingData	= NO;
	if (self = [super init]) 
    {

	}

	return self;
}

- (void)dealloc
{
	_tableView.delegate		= nil;
	_tableView.dataSource	= nil;
    _tableView.pullToRefreshView = nil;
    RELEASE(_error);
	RELEASE(_dataSource);
	RELEASE(_tableView);
	RELEASE(_loadingView);
	RELEASE(_errorView);
	RELEASE(_emptyView);
	RELEASE(_tableOverlayView);
    RELEASE(_searchController);
    RELEASE(_searchViewController);
	[super dealloc];
}

#pragma mark -
#pragma mark Private

- (NSString *)defaultTitleForLoading
{
	return NSLocalizedString(@"Loading...", @"");
}

- (void)addToOverlayView:(UIView *)view
{
	if (!_tableOverlayView) 
    {
		CGRect frame = self.view.bounds;
		_tableOverlayView = [[UIView alloc] initWithFrame:frame];
		_tableOverlayView.autoresizesSubviews	= YES;
		_tableOverlayView.autoresizingMask		= UIViewAutoresizingFlexibleWidth
												  | UIViewAutoresizingFlexibleHeight;
		NSInteger tableIndex = [_tableView.superview.subviews indexOfObject:_tableView];

		if (tableIndex != NSNotFound) 
        {
			[_tableView.superview addSubview:_tableOverlayView];
		}
	}

	view.frame				= _tableOverlayView.bounds;
	view.autoresizingMask	= UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[_tableOverlayView addSubview:view];
}

- (void)resetOverlayView
{
	if (_tableOverlayView && !_tableOverlayView.subviews.count) 
    {
		[_tableOverlayView removeFromSuperview];
		RELEASE(_tableOverlayView);
	}
}

- (void)addSubviewOverTableView:(UIView *)view
{
	NSInteger tableIndex = [_tableView.superview.subviews
							indexOfObject:_tableView];

	if (NSNotFound != tableIndex) 
    {
		[_tableView.superview addSubview:view];
	}
}

- (void)layoutOverlayView
{
	if (_tableOverlayView) 
    {
		_tableOverlayView.frame = [self rectForOverlayView];
	}
}

- (void)fadeOutView:(UIView *)view
{
	[view retain];
	[UIView beginAnimations:nil context:view];
	[UIView setAnimationDuration:.3f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(fadingOutViewDidStop:finished:context:)];
	view.alpha = 0;
	[UIView commitAnimations];
}

- (void)fadingOutViewDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	UIView *view = (UIView *)context;
    
	[view removeFromSuperview];
	[view release];
}

- (void)setSearchViewController:(TDSTableViewController *)searchViewController
{
	if (_searchViewController == searchViewController) 
    {
		return;
	}
    
    RELEASE(_searchViewController);
    _searchViewController = [searchViewController retain];
    
	if (searchViewController) 
    {
		if (nil == _searchController) 
        {
			UISearchBar *searchBar = [[[UISearchBar alloc] init] autorelease];
			[searchBar sizeToFit];
			_searchController = [[TDSSearchDisplayController alloc] initWithSearchBar	:searchBar
																	contentsController	:self];
		}

		_searchController.searchResultsViewController = searchViewController;
	} 
    else 
    {
		_searchController.searchResultsViewController = nil;
		RELEASE(_searchController);
	}
}

#pragma mark -
#pragma mark UIViewController

- (void)loadView 
{
    [super loadView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self.dataSource;   
}
- (void)viewDidLoad
{
	[super viewDidLoad];
    self.tableView.backgroundView = nil;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    RELEASE(_tableView);
    [_tableOverlayView removeFromSuperview];
    RELEASE(_tableOverlayView);
    [_loadingView removeFromSuperview];
    RELEASE(_loadingView);
    [_errorView removeFromSuperview];
    RELEASE(_errorView);
    [_emptyView removeFromSuperview];
    RELEASE(_emptyView);
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_lastInterfaceOrientation != self.interfaceOrientation) {
        _lastInterfaceOrientation = self.interfaceOrientation;
        [_tableView reloadData];
        
    } else if ([_tableView isKindOfClass:[TDSTableView class]]) {
        TDSTableView* tableView = (TDSTableView*)_tableView;
        tableView.showShadows = _showTableShadows;
    }
    
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:animated];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}



- (void)showLoading:(BOOL)show {
    if (show) {
    
		[self showEmpty:NO];
		[self showError:NO];
    
        UIView *loadingTextView = [[UIView alloc] initWithFrame:self.view.bounds];
        loadingTextView.backgroundColor = [UIColor clearColor];
        
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.font = [UIFont systemFontOfSize:15.0f];
//        [textLabel setTextColor:[[RSResManager getInstance] colorForKey:@"colorOfRefreshHeaderLabel"]];
        [textLabel setShadowOffset:CGSizeMake(0, 1)];
//        [textLabel setShadowColor:[[RSResManager getInstance] colorForKey:@"colorOfRefreshHeaderLabelShadow"]];                
        [textLabel setText:@"载入中..."];
//        CGSize m_textSize = [textLabel.text sizeWithFont:textLabel.font 
//                                       constrainedToSize:CGSizeMake(self.view.frame.size.width, 10000.0f)  
//                                           lineBreakMode:UILineBreakModeClip];
        
//        [textLabel setFrame:CGRectMake(loadingTextView.centerX-m_textSize.width/2,
//                                       loadingTextView.centerY-m_textSize.height/2,
//                                       m_textSize.width,
//                                       m_textSize.height)];
        
        // 这个是原色版本 loading 动画
//        UIActivityIndicatorView *loadingAnimation = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]; 
//        [loadingAnimation setFrame:CGRectMake(CGRectGetMinX(textLabel.frame)-loadingAnimation.size.width-3.0f, 
//                                              loadingTextView.centerY-loadingAnimation.size.height/2,
//                                              loadingAnimation.size.width,
//                                              loadingAnimation.size.height)];
//        [loadingAnimation startAnimating];
//        
//        [loadingTextView addSubview:loadingAnimation];                
//        [loadingTextView addSubview:textLabel];        
//        
//        [loadingAnimation release];
        [textLabel release];
        ///////////////////////////////////////////////////////////////////////////////////////////////////                        
        self.loadingView = loadingTextView;
        [loadingTextView release];
        [self.view addSubview:self.loadingView];
    } else {
        if ([[self.view subviews] containsObject:self.loadingView]) {
            [self.loadingView removeFromSuperview];
            self.loadingView = nil;            
        }
    }

}


- (void)showError:(BOOL)show
{
	if (show) {
		NSString	*title		= [_dataSource titleForError:self.error];
		NSString	*subtitle	= [_dataSource subtitleForError:self.error];
		UIImage		*image		= [_dataSource imageForError:self.error];

		if (title.length || subtitle.length || image) {
			TDSErrorView *errorView = [[[TDSErrorView alloc]	initWithTitle	:title
															subtitle		:subtitle
															image			:image] autorelease];
			errorView.backgroundColor	= self.view.backgroundColor;
			self.errorView				= errorView;
		} else {
			self.errorView = nil;
		}
	} else {
		self.errorView = nil;
	}
}

- (void)showEmpty:(BOOL)show
{
	if (show) {
		NSString	*title		= [_dataSource titleForEmpty];
		NSString	*subtitle	= [_dataSource subtitleForEmpty];
		UIImage		*image		= [_dataSource imageForEmpty];

		if (title.length || subtitle.length || image) {
			TDSErrorView *errorView = [[[TDSErrorView alloc]	initWithTitle	:title
															subtitle		:subtitle
															image			:image] autorelease];
			errorView.backgroundColor	= self.view.backgroundColor;
			self.emptyView				= errorView;
		} else {
			self.emptyView = nil;
		}

	} else {
		self.emptyView = nil;
	}
}

- (void)search:(NSString*)kw
{
    
}

- (void)cancelSearch
{

}

#pragma mark -
#pragma mark Public
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)createModel
{
    __block TDSTableViewController *tableViewController = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [tableViewController performSelectorOnMainThread:@selector(pullToRefreshAction) withObject:nil waitUntilDone:YES];
    }];
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [tableViewController performSelectorOnMainThread:@selector(infiniteScrollingAction) withObject:nil waitUntilDone:YES];
    }];
    self.tableView.showsPullToRefresh = NO;     // default is NO
    self.tableView.showsInfiniteScrolling = NO; // default is NO
    
    // you can configure how that date is displayed
    self.tableView.pullToRefreshView.dateFormatter.dateStyle = kCFDateFormatterShortStyle;
    self.tableView.pullToRefreshView.dateFormatter.timeStyle = kCFDateFormatterShortStyle;
    
    // you can also display the "last updated" date
    self.tableView.pullToRefreshView.lastUpdatedDate = [NSDate date];
    
    self.tableView.pullToRefreshView.dateLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
    self.tableView.pullToRefreshView.dateLabel.font				= [UIFont systemFontOfSize:12.0f];
    self.tableView.pullToRefreshView.dateLabel.textColor		= [UIColor darkGrayColor];
    self.tableView.pullToRefreshView.dateLabel.shadowColor		= [UIColor grayColor];
    self.tableView.pullToRefreshView.dateLabel.shadowOffset		= CGSizeMake(0,1);
        
    self.tableView.pullToRefreshView.titleLabel.autoresizingMask	= UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
    self.tableView.pullToRefreshView.titleLabel.font				= [UIFont systemFontOfSize:14.0f];;
    self.tableView.pullToRefreshView.titleLabel.textColor			= [UIColor darkGrayColor];;
    self.tableView.pullToRefreshView.titleLabel.shadowColor			= [UIColor grayColor];;
    self.tableView.pullToRefreshView.titleLabel.shadowOffset		= CGSizeMake(0,1);;
    
    UIImage *arrowImage = [UIImage imageNamed:@"arrow.png"];
    self.tableView.pullToRefreshView.arrow.image = arrowImage;
    self.tableView.pullToRefreshView.arrowColor = [UIColor grayColor];
    CGRect pullViewFrame = self.tableView.pullToRefreshView.frame;
    
    UIImage		*refreshImage	= [UIImage imageNamed:@"logo.png"];
    UIImageView *refreshBGView	= [[[UIImageView alloc] initWithImage:refreshImage] autorelease];
    refreshBGView.frame = CGRectMake((pullViewFrame.size.width - refreshBGView.image.size.width) / 2,
                                     pullViewFrame.size.height - 58.0f - refreshBGView.image.size.height,
                                     refreshImage.size.width,
                                     refreshImage.size.height);
    [self.tableView.pullToRefreshView addSubview:refreshBGView];
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (UITableView*)tableView {
    if (nil == _tableView) {
        _tableView = [[TDSTableView alloc] initWithFrame:CGRectZero style:_tableViewStyle];
        _tableView.frame = self.view.bounds;
        _tableView.autoresizingMask =  UIViewAutoresizingFlexibleWidth
        | UIViewAutoresizingFlexibleHeight;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}


- (void)setTableView:(UITableView*)tableView {
    if (tableView != _tableView) {
        
		if (_tableView) {
			[_tableView removeFromSuperview];
			[_tableView release];
		}
        
        if (tableView == nil) {
            _tableView = nil;
            self.tableOverlayView = nil;
        }else {
            _tableView = [tableView retain];
            _tableView.delegate = nil;
            _tableView.delegate = self;
            _tableView.dataSource = self.dataSource;
            
			if (!_tableView.superview) {
				[self.view addSubview:_tableView];
			}
        }
    }
}

- (void)setTableOverlayView:(UIView*)tableOverlayView animated:(BOOL)animated {
    if (tableOverlayView != _tableOverlayView) {
        if (_tableOverlayView) {
            if (animated) {
                [self fadeOutView:_tableOverlayView];
                
            } else {
                [_tableOverlayView removeFromSuperview];
            }
        }
        
        [_tableOverlayView release];
        _tableOverlayView = [tableOverlayView retain];
        
        if (_tableOverlayView) {
            _tableOverlayView.frame = [self rectForOverlayView];
            [self addToOverlayView:_tableOverlayView];
        }
        
        // XXXjoe There seem to be cases where this gets left disable - must investigate
        //_tableView.scrollEnabled = !_tableOverlayView;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setDataSource:(id<TDSTableViewDataSource>)dataSource {
    if (dataSource != _dataSource) {
        [_dataSource release];
        _dataSource = [dataSource retain];
        _tableView.dataSource = _dataSource;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setLoadingView:(UIView*)view {
    if (view != _loadingView) {
        if (_loadingView) {
            [_loadingView removeFromSuperview];
            RELEASE(_loadingView);
        }
        _loadingView = [view retain];
        if (_loadingView) {
            [self addToOverlayView:_loadingView];
            
        } else {
            [self resetOverlayView];
        }
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setErrorView:(UIView*)view {
    if (view != _errorView) {
        if (_errorView) {
            [_errorView removeFromSuperview];
            RELEASE(_errorView);
        }
        _errorView = [view retain];
        
        if (_errorView) {
            [self addToOverlayView:_errorView];
            
        } else {
            [self resetOverlayView];
        }
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setEmptyView:(UIView*)view {
    if (view != _emptyView) {
        if (_emptyView) {
            [_emptyView removeFromSuperview];
            RELEASE(_emptyView);
        }
        _emptyView = [view retain];
        if (_emptyView) {
            [self addToOverlayView:_emptyView];
            
        } else {
            [self resetOverlayView];
        }
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath *)indexPath
{
	if ([object isKindOfClass:[TDSTableViewLoadMoreItem class]] && !self.loadingData) 
    {
		TDSTableViewLoadMoreItem *moreItem = (TDSTableViewLoadMoreItem *)object;
		moreItem.isLoading = YES;
		TDSTableViewLoadMoreCell *cell = 
        (TDSTableViewLoadMoreCell *)[self.tableView cellForRowAtIndexPath:indexPath];
		cell.animating = YES;
		[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self loadMoreAction];
	}
}



///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didBeginDragging 
{}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didEndDragging 
{}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGRect)rectForOverlayView 
{
    CGRect frame = self.view.frame;
    
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if ([window findFirstResponder]) 
    {
        frame.size.height -= 216.0f;
    }
    
    return frame;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)pullToRefreshAction
{}

- (void)loadMoreAction
{}

- (void)infiniteScrollingAction
{}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)stopRefreshAction
{
    self.tableView.pullToRefreshView.lastUpdatedDate = [NSDate date];
    [self.tableView.pullToRefreshView stopAnimating];
}

- (void)refreshTable
{
	[self.tableView reloadData];
    
    [self showLoading:NO];
    [self showError:NO];
    [self showEmpty:[self.dataSource empty]];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

@end

@implementation TDSTableViewController (delegate)

#pragma mark - UIScrollViewDelegate
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView 
{
    [self didBeginDragging];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate 
{
    [self didEndDragging];
}

#pragma mark - UITableViewDelegate
///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath 
{
    id<TDSTableViewDataSource> dataSource = (id<TDSTableViewDataSource>)tableView.dataSource;
    
    id object = [dataSource tableView:tableView objectForRowAtIndexPath:indexPath];
    Class cls = [dataSource tableView:tableView cellClassForObject:object];
    
    return [cls tableView:tableView rowHeightForObject:object];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section 
{
    if ([tableView.dataSource respondsToSelector:@selector(tableView:titleForHeaderInSection:)]) 
    {
        NSString *title = [tableView.dataSource tableView:tableView 
                                  titleForHeaderInSection:section];
        if (!title.length) 
        {
            return 0.0f;
        }
        return 22.0;
    }
    return 0.0f;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// 自定义sectionView在继承的controller中自己实现
//- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {    
//    return nil;
//}


///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * When the user taps a cell item, we check whether the tapped item has an attached URL and, if
 * it has one, we navigate to it. This also handles the logic for "Load more" buttons.
 */
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath 
{
    id<TDSTableViewDataSource> dataSource = (id<TDSTableViewDataSource>)tableView.dataSource;
    id object = [dataSource tableView:tableView objectForRowAtIndexPath:indexPath];
    [self didSelectObject:object atIndexPath:indexPath];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * Similar logic to the above. If the user taps an accessory item and there is an associated URL,
 * we navigate to that URL.
 */
- (void)tableView:(UITableView*)tableView
accessoryButtonTappedForRowWithIndexPath:(NSIndexPath*)indexPath 
{
    id<TDSTableViewDataSource> dataSource = (id<TDSTableViewDataSource>)tableView.dataSource;
    id object = [dataSource tableView:tableView objectForRowAtIndexPath:indexPath];
    NSLog(@" object:%@",object);
    //    if ([object isKindOfClass:[TTTableLinkedItem class]]) {
    //        TTTableLinkedItem* item = object;
    //        if (item.accessoryURL && [_controller shouldOpenURL:item.accessoryURL]) {
    //            TTOpenURLFromView(item.accessoryURL, tableView);
    //        }
    //    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	if (self.loadingData) 
    {
		return;
	}

	CGFloat contentFoot = scrollView.contentSize.height - scrollView.contentOffset.y;
	CGFloat viewHeight	= scrollView.frame.size.height;

	if (contentFoot <= viewHeight) 
    {
		int lastSectionIndex = 0;

		if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) 
        {
			int sectionNumber = [self.dataSource numberOfSectionsInTableView:self.tableView];

			if (sectionNumber > 0) 
            {
				lastSectionIndex = sectionNumber - 1;
			}
		}

		int lastRowIndex = 0;

		if ([self.dataSource tableView:self.tableView numberOfRowsInSection:lastSectionIndex] > 0) 
        {
			lastRowIndex = [self.dataSource tableView:self.tableView numberOfRowsInSection:lastSectionIndex] - 1;
		}

		NSIndexPath *lastRowIndexPath	= [NSIndexPath indexPathForRow:lastRowIndex inSection:lastSectionIndex];
		id			object				= [self.dataSource tableView:self.tableView objectForRowAtIndexPath:lastRowIndexPath];

		if ([object isKindOfClass:[TDSTableViewLoadMoreItem class]]) 
        {
			[self didSelectObject:object atIndexPath:lastRowIndexPath];
		}
	}
}


@end