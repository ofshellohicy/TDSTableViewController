//
//  TDSTableViewLoadMoreCell.m
//  icePhone
//
//  Created by zhong sheng on 12-6-6.
//  Copyright (c) 2012年 icePhone. All rights reserved.
//

#import "TDSTableViewLoadMoreCell.h"
#import "TDSTableViewLoadMoreItem.h"

#define LOAD_MORE_CELL_HEIGHT 44.0f

static const CGFloat kMoreButtonMargin = 40;

@interface TDSTableViewLoadMoreCell()

- (void)buildLoadingAnimationView;
- (void)buildTitleLabel;

@end

@implementation TDSTableViewLoadMoreCell

@synthesize animating = _animating;

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
  return  LOAD_MORE_CELL_HEIGHT;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _animating = NO;

        [self buildTitleLabel];        
        [self buildLoadingAnimationView];
        
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        self.accessoryType = UITableViewCellAccessoryNone;
    }
	return self;
}

- (void)dealloc
{
    RELEASE(_titleLabel)
    RELEASE(_loadingAnimationView)
    [super dealloc];
}

- (void)setAnimating:(BOOL)animating {
	_animating = animating;
	if (animating) {
		[_loadingAnimationView startAnimating];
	} else {
		[_loadingAnimationView stopAnimating];
	}
}

#pragma mark- Override
- (void)layoutSubviews {
	[super layoutSubviews];

//	_loadingAnimationView.left	= kMoreButtonMargin - (_loadingAnimationView.width + 6);
//	_loadingAnimationView.top	= floor(self.contentView.height / 2 - _loadingAnimationView.height / 2);
//
//	_titleLabel.frame = CGRectMake(kMoreButtonMargin,
//			_titleLabel.top,
//			self.contentView.width - (kMoreButtonMargin + 6),
//			_titleLabel.height);
}

- (void)setObject:(id)object
{
	if (_object != object) {
		[super setObject:object];

		if (_object) {
			TDSTableViewLoadMoreItem *item = _object;
			_titleLabel.text	= item.title;
			self.animating		= item.isLoading;
		}
	}
}

#pragma mark- UI
- (void)buildLoadingAnimationView
{
	_loadingAnimationView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	[self.contentView addSubview:_loadingAnimationView];
}

- (void)buildTitleLabel
{
	_titleLabel = [[UILabel alloc] initWithFrame:self.contentView.bounds];
    _titleLabel.backgroundColor = [UIColor clearColor];
	_titleLabel.autoresizingMask			= UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_titleLabel.font						= [UIFont systemFontOfSize:16.0f];//TTSTYLEVAR(tableSmallFont);
	_titleLabel.textColor					= [UIColor blackColor];//TTSTYLEVAR(textColor);
	_titleLabel.highlightedTextColor		= [UIColor grayColor];//TTSTYLEVAR(highlightedTextColor);
	_titleLabel.textAlignment				= UITextAlignmentLeft;
	_titleLabel.lineBreakMode				= UILineBreakModeTailTruncation;
	_titleLabel.adjustsFontSizeToFitWidth	= YES;
    [_titleLabel setTextColor:[UIColor blackColor]];
    [_titleLabel setShadowColor:[UIColor grayColor]];       
    
    [self.contentView addSubview:_titleLabel];
}

@end
