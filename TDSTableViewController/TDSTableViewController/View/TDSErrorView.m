//
//  TDSErrorView.m
//  icePhone
//
//  Created by zhong sheng on 12-6-4.
//  Copyright (c) 2012年 icePhone. All rights reserved.
//

#import "TDSErrorView.h"

static const CGFloat kVPadding1 = 30;
static const CGFloat kVPadding2 = 20;
static const CGFloat kHPadding  = 10;


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TDSErrorView


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithTitle:(NSString*)title subtitle:(NSString*)subtitle image:(UIImage*)image {
    if (self = [self init]) {
        self.title = title;
        self.subtitle = subtitle;
        self.image = image;
    }
    
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:_imageView];
        
        _titleView = [[UILabel alloc] init];
        _titleView.backgroundColor = [UIColor clearColor];
        _titleView.textColor = [UIColor darkGrayColor];
        _titleView.font = [UIFont boldSystemFontOfSize:18.0f];
        _titleView.textAlignment = UITextAlignmentCenter;
        [self addSubview:_titleView];
        
        _subtitleView = [[UILabel alloc] init];
        _subtitleView.backgroundColor = [UIColor clearColor];
        _subtitleView.textColor = [UIColor darkGrayColor];
        _subtitleView.font = [UIFont boldSystemFontOfSize:12.0f];
        _subtitleView.textAlignment = UITextAlignmentCenter;
        _subtitleView.numberOfLines = 0;
        [self addSubview:_subtitleView];
    }
    
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    RELEASE(_imageView);
    RELEASE(_titleView);
    RELEASE(_subtitleView);
    
    [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIView


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews {
    CGRect subtitleFrame = _subtitleView.frame;
    subtitleFrame.size = [_subtitleView sizeThatFits:CGSizeMake(self.bounds.size.width - kHPadding*2, 0)];
    _subtitleView.frame = subtitleFrame;
    [_titleView sizeToFit];
    [_imageView sizeToFit];
    
    CGFloat maxHeight = _imageView.bounds.size.height + _titleView.bounds.size.height + _subtitleView.bounds.size.height
    + kVPadding1 + kVPadding2;
    BOOL canShowImage = _imageView.image && self.bounds.size.height > maxHeight;
    
    CGFloat totalHeight = 0;
    
    if (canShowImage) {
        totalHeight += _imageView.bounds.size.height;
    }
    if (_titleView.text.length) {
        totalHeight += (totalHeight ? kVPadding1 : 0) + _titleView.bounds.size.height;
    }
    if (_subtitleView.text.length) {
        totalHeight += (totalHeight ? kVPadding2 : 0) + _subtitleView.bounds.size.height;
    }
    
    CGFloat top = floor(self.bounds.size.height/2 - totalHeight/2);
    
    if (canShowImage) {
        CGRect imageViewBounds = _imageView.bounds;
        imageViewBounds.origin = CGPointMake(floor(self.bounds.size.width/2 - _imageView.bounds.size.width/2), top);
        _imageView.bounds = imageViewBounds;
        _imageView.hidden = NO;
        top += _imageView.frame.size.height + kVPadding1;
        
    } else {
        _imageView.hidden = YES;
    }
    if (_titleView.text.length) {
        CGRect titleFrame = _titleView.frame;
        titleFrame.origin = CGPointMake(floor(self.frame.size.width/2 - _titleView.frame.size.width/2), top);
        _titleView.frame = titleFrame;
        top += _titleView.frame.size.height + kVPadding2;
    }
    if (_subtitleView.text.length) {
        CGRect subtitleFrame = _subtitleView.frame;
        subtitleFrame.origin = CGPointMake(floor(self.frame.size.width/2 - _subtitleView.frame.size.width/2), top);
        _subtitleView.frame = subtitleFrame;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Properties


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)title {
    return _titleView.text;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTitle:(NSString*)title {
    _titleView.text = title;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)subtitle {
    return _subtitleView.text;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setSubtitle:(NSString*)subtitle {
    _subtitleView.text = subtitle;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIImage*)image {
    return _imageView.image;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setImage:(UIImage*)image {
    _imageView.image = image;
}

@end