//
//  TDSTableViewLoadMoreCell.h
//  icePhone
//
//  Created by zhong sheng on 12-6-6.
//  Copyright (c) 2012年 icePhone. All rights reserved.
//

#import "TDSTableViewCell.h"

@interface TDSTableViewLoadMoreCell : TDSTableViewCell
{
	UIActivityIndicatorView *_loadingAnimationView;
	UILabel					*_titleLabel;
	BOOL					_animating;
}

@property (nonatomic, assign) BOOL animating;

@end
