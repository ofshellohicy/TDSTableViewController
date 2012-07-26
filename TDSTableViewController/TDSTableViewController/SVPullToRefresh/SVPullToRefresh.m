//
// SVPullToRefresh.m
//
// Created by Sam Vermette on 23.04.12.
// Copyright (c) 2012 samvermette.com. All rights reserved.
//
// https://github.com/samvermette/SVPullToRefresh
//

#import <QuartzCore/QuartzCore.h>
#import "SVPullToRefresh.h"

#define REFRESH_HEIGHT 60.0f

@interface SVPullToRefresh ()

- (id)initWithScrollView:(UIScrollView*)scrollView;
- (void)rotateArrow:(float)degrees hide:(BOOL)hide;
- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset;
- (void)scrollViewDidScroll:(CGPoint)contentOffset;

- (void)startObservingScrollView;
- (void)stopObservingScrollView;

@property (nonatomic, copy) void (^pullToRefreshActionHandler)(void);
@property (nonatomic, readwrite) SVPullToRefreshState state;

@property (nonatomic, strong) UIImage *arrowImage;

@property (nonatomic, unsafe_unretained) UIScrollView *scrollView;
@property (nonatomic, readwrite) UIEdgeInsets originalScrollViewContentInset;
@property (nonatomic, assign) BOOL showsPullToRefresh;
@property (nonatomic, assign) BOOL isObservingScrollView;
@end


@implementation SVPullToRefresh

// public properties
@synthesize pullToRefreshActionHandler, arrowColor, textColor, activityIndicatorViewStyle, lastUpdatedDate, dateFormatter,isObservingScrollView;

@synthesize state;
@synthesize scrollView = _scrollView;
@synthesize arrow, arrowImage, activityIndicatorView, titleLabel, dateLabel, originalScrollViewContentInset;
@synthesize showsPullToRefresh;

- (void)dealloc {
    [self stopObservingScrollView];
    [super dealloc];
}

- (id)initWithScrollView:(UIScrollView *)scrollView {
    self = [super initWithFrame:CGRectZero];
    self.scrollView = scrollView;
    
    // default styling values
    self.arrowColor = [UIColor grayColor];
    self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    self.textColor = [UIColor darkGrayColor];
    
    [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [scrollView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    
    self.originalScrollViewContentInset = scrollView.contentInset;
	
    self.state = SVPullToRefreshStateHidden;    
    self.frame = CGRectMake(0, -REFRESH_HEIGHT, scrollView.bounds.size.width, REFRESH_HEIGHT);
    
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if(newSuperview == self.scrollView)
        [self startObservingScrollView];
    else if(newSuperview == nil)
        [self stopObservingScrollView];
}

#pragma mark - Getters

- (UIImageView *)arrow {
    if(!arrow && pullToRefreshActionHandler) {
        arrow = [[UIImageView alloc] initWithImage:self.arrowImage];
        arrow.frame = CGRectMake(0, 6, 22, 48);
        arrow.backgroundColor = [UIColor clearColor];
    }
    return arrow;
}

- (UIImage *)arrowImage {
    CGRect rect = CGRectMake(0, 0, 22, 48);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor clearColor] set];
    CGContextFillRect(context, rect);
    
    [self.arrowColor set];
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    //    CGContextClipToMask(context, rect, [[UIImage imageNamed:@"SVPullToRefresh.bundle/arrow"] CGImage]);
    CGContextClipToMask(context, rect, [[UIImage imageNamed:@"arrow.png"] CGImage]);
    CGContextFillRect(context, rect);
    
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return output;
}

- (UIActivityIndicatorView *)activityIndicatorView {
    if(!activityIndicatorView) {
        activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityIndicatorView.hidesWhenStopped = YES;
        [self addSubview:activityIndicatorView];
    }
    return activityIndicatorView;
}

- (UILabel *)dateLabel {
    if(!dateLabel && pullToRefreshActionHandler) {
        dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 28, 180, 20)];
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.font = [UIFont systemFontOfSize:12];
        dateLabel.textColor = textColor;
        [self addSubview:dateLabel];
        
        CGRect titleFrame = titleLabel.frame;
        titleFrame.origin.y = 12;
        titleLabel.frame = titleFrame;
    }
    return dateLabel;
}

- (NSDateFormatter *)dateFormatter {
    if(!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
		dateFormatter.locale = [NSLocale currentLocale];
    }
    return dateFormatter;
}

- (UIEdgeInsets)originalScrollViewContentInset {
    return UIEdgeInsetsMake(originalScrollViewContentInset.top, self.scrollView.contentInset.left, self.scrollView.contentInset.bottom, self.scrollView.contentInset.right);
}

#pragma mark - Setters

- (void)setPullToRefreshActionHandler:(void (^)(void))actionHandler {
    pullToRefreshActionHandler = [actionHandler copy];
    [_scrollView addSubview:self];
    self.showsPullToRefresh = YES;
    
    if (!titleLabel) {
        self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 20, 150, 20)] autorelease];
    }
    titleLabel.text = NSLocalizedString(@"下拉可以刷新...",);
    titleLabel.font = [UIFont boldSystemFontOfSize:14];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = textColor;
    [self addSubview:titleLabel];
    
    [self addSubview:self.arrow];
    
    self.state = SVPullToRefreshStateHidden;    
    self.frame = CGRectMake(0, -REFRESH_HEIGHT, self.scrollView.bounds.size.width, REFRESH_HEIGHT);
}

- (void)setArrowColor:(UIColor *)newArrowColor {
    arrowColor = newArrowColor;
    self.arrow.image = self.arrowImage;
}

- (void)setTextColor:(UIColor *)newTextColor {
    textColor = newTextColor;
    titleLabel.textColor = newTextColor;
	dateLabel.textColor = newTextColor;
}

- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)viewStyle {
    self.activityIndicatorView.activityIndicatorViewStyle = viewStyle;
}

- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.scrollView.contentInset = contentInset;
    } completion:^(BOOL finished) {
        if(self.state == SVPullToRefreshStateHidden && contentInset.top == self.originalScrollViewContentInset.top)
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                arrow.alpha = 0;
            } completion:NULL];
    }];
}

- (void)setLastUpdatedDate:(NSDate *)newLastUpdatedDate {
    self.dateLabel.text = [NSString stringWithFormat:NSLocalizedString(@"最后更新: %@",), newLastUpdatedDate?[self.dateFormatter stringFromDate:newLastUpdatedDate]:NSLocalizedString(@"Never",)];
}

- (void)setDateFormatter:(NSDateFormatter *)newDateFormatter {
	dateFormatter = newDateFormatter;
    self.dateLabel.text = [NSString stringWithFormat:NSLocalizedString(@"最后更新: %@",), self.lastUpdatedDate?[newDateFormatter stringFromDate:self.lastUpdatedDate]:NSLocalizedString(@"Never",)];
}


#pragma mark -

- (void)startObservingScrollView {
    if (self.isObservingScrollView)
        return;
    
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [self.scrollView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    self.isObservingScrollView = YES;
}

- (void)stopObservingScrollView {
    if(!self.isObservingScrollView)
        return;
    
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [self.scrollView removeObserver:self forKeyPath:@"frame"];
    self.isObservingScrollView = NO;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"contentOffset"])
        [self scrollViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
    else if([keyPath isEqualToString:@"frame"])
        [self layoutSubviews];
}

- (void)scrollViewDidScroll:(CGPoint)contentOffset {    
    if(pullToRefreshActionHandler && self.state != SVPullToRefreshStateLoading) {
        CGFloat scrollOffsetThreshold = self.frame.origin.y-self.originalScrollViewContentInset.top;
        //    NSLog(@"<%.1f,%.1f>",self.scrollView.contentInset.top,self.scrollView.contentInset.bottom);
        //    NSLog(@"%d %.1f",self.state,scrollOffsetThreshold);
        if(self.state == SVPullToRefreshStateLoading 
           && self.scrollView.contentInset.top >= 0.0f)
        {
            // {top, left, bottom, right};
            CGFloat offsetTop = -contentOffset.y;
            if (contentOffset.y >= 0.0f) {
                offsetTop = 0.0f;
            }else if(contentOffset.y <= -REFRESH_HEIGHT){
                offsetTop = REFRESH_HEIGHT;
            }else{
                offsetTop = -contentOffset.y;
            }
            [self.scrollView setContentInset:UIEdgeInsetsMake(offsetTop,0,0,0)];
            //        [self setScrollViewContentInset:UIEdgeInsetsMake(offsetTop,0,0,0)];            
            
        }
        else if(!self.scrollView.isDragging && self.state == SVPullToRefreshStateTriggered){
            self.state = SVPullToRefreshStateLoading;
        }
        else if(contentOffset.y > scrollOffsetThreshold && 
                contentOffset.y < -self.originalScrollViewContentInset.top && 
                self.scrollView.isDragging && 
                self.state != SVPullToRefreshStateLoading)
        {
            self.state = SVPullToRefreshStateVisible;
        }
        else if(contentOffset.y < scrollOffsetThreshold && 
                self.scrollView.isDragging && 
                self.state == SVPullToRefreshStateVisible)
        {
            self.state = SVPullToRefreshStateTriggered;
        }
        else if(contentOffset.y >= -self.originalScrollViewContentInset.top && 
                self.state != SVPullToRefreshStateHidden)
        {
            self.state = SVPullToRefreshStateHidden;
        }
    }
}

- (void)triggerRefresh {
    self.state = SVPullToRefreshStateLoading;
}

- (void)stopAnimating {
    self.state = SVPullToRefreshStateHidden;
}

- (void)setState:(SVPullToRefreshState)newState {
    if(pullToRefreshActionHandler && !self.showsPullToRefresh && !self.activityIndicatorView.isAnimating) {
        titleLabel.text = NSLocalizedString(@"",);
        dateLabel.text = NSLocalizedString(@"",);
        [self.activityIndicatorView stopAnimating];
        [self setScrollViewContentInset:self.originalScrollViewContentInset];
        self.arrow.layer.transform = CATransform3DMakeRotation(0, 0, 0, 1);
        self.arrow.layer.opacity = 0.0f;
        return;   
    }
    if(state == newState)
        return;
    
    SVPullToRefreshState oldState = state;
    state = newState;
    if(pullToRefreshActionHandler) {
        switch (newState) {
            case SVPullToRefreshStateHidden:
            {
                titleLabel.text = NSLocalizedString(@"下拉可以刷新...",);
                [self.activityIndicatorView stopAnimating];
                [self setScrollViewContentInset:self.originalScrollViewContentInset];
                [self rotateArrow:0 hide:NO];
                if (oldState == SVPullToRefreshStateLoading) 
                {
                    //[[AudioManager sharedInstance] playSystemSoundWithTag:SoundEffectType_RefreshFinish];
                }
                break;
            }   
            case SVPullToRefreshStateVisible:
            {
                titleLabel.text = NSLocalizedString(@"下拉可以刷新...",);
                arrow.alpha = 1;
                [self.activityIndicatorView stopAnimating];
                //[self setScrollViewContentInset:self.originalScrollViewContentInset];
                [self rotateArrow:0 hide:NO];
                
                if(oldState == SVPullToRefreshStateTriggered)
                {
                    //[[AudioManager sharedInstance] playSystemSoundWithTag:SoundEffectType_RefreshRelease];
                }
                break;
            }   
            case SVPullToRefreshStateTriggered:
            {
                //[[AudioManager sharedInstance] playSystemSoundWithTag:SoundEffectType_RefreshPress];
                titleLabel.text = NSLocalizedString(@"松开即可刷新...",);
                [self rotateArrow:M_PI hide:NO];
                break;
            }   
            case SVPullToRefreshStateLoading:
            {
                titleLabel.text = NSLocalizedString(@"更新中...",);
                [self bringSubviewToFront:self.activityIndicatorView];
                [self.activityIndicatorView startAnimating];
                [self setScrollViewContentInset:UIEdgeInsetsMake(self.frame.origin.y*-1+self.originalScrollViewContentInset.top, 0, 0, 0)];
                [self rotateArrow:0 hide:YES];
                if(pullToRefreshActionHandler)
                    pullToRefreshActionHandler();
                break;
            }
        }
    }
}

- (void)rotateArrow:(float)degrees hide:(BOOL)hide {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.arrow.layer.transform = CATransform3DMakeRotation(degrees, 0, 0, 1);
        self.arrow.layer.opacity = !hide;
    } completion:NULL];
}

@end


#pragma mark - UIScrollView (SVPullToRefresh)
#import <objc/runtime.h>

static char UIScrollViewPullToRefreshView;

@implementation UIScrollView (SVPullToRefresh)

@dynamic pullToRefreshView,showsPullToRefresh;

- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler {
    self.pullToRefreshView.pullToRefreshActionHandler = actionHandler;
}

- (void)setPullToRefreshView:(SVPullToRefresh *)pullToRefreshView {
    [self willChangeValueForKey:@"pullToRefreshView"];
    objc_setAssociatedObject(self, &UIScrollViewPullToRefreshView,
                             pullToRefreshView,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"pullToRefreshView"];
}

- (SVPullToRefresh *)pullToRefreshView {
    SVPullToRefresh *pullToRefreshView = objc_getAssociatedObject(self, &UIScrollViewPullToRefreshView);
    if(!pullToRefreshView) {
        pullToRefreshView = [[SVPullToRefresh alloc] initWithScrollView:self];
        self.pullToRefreshView = pullToRefreshView;
    }
    return pullToRefreshView;
}

- (void)setShowsPullToRefresh:(BOOL)showsPullToRefresh {
    self.pullToRefreshView.showsPullToRefresh = showsPullToRefresh;   
}

- (BOOL)showsPullToRefresh {
    return self.pullToRefreshView.showsPullToRefresh;
}

@end
