//
//  TDSSearchDisplayController.h
//  icePhone
//
//  Created by zhong sheng on 12-6-11.
//  Copyright (c) 2012年 icePhone. All rights reserved.
//
#import <Foundation/Foundation.h>

@class TDSTableViewController;

@protocol TDSSearchDisplayControllerDelegate <NSObject>
- (void)willBeginSearch;
- (void)willEndSearch;
- (void)willHideSearchResult;
@end

@interface TDSSearchDisplayController : UISearchDisplayController <UISearchDisplayDelegate>

@property (nonatomic, retain) TDSTableViewController* searchResultsViewController;

@end
