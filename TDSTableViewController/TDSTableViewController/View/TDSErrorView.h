//
//  TDSErrorView.h
//  icePhone
//
//  Created by zhong sheng on 12-6-4.
//  Copyright (c) 2012年 icePhone. All rights reserved.
//

#import <Foundation/Foundation.h>
 
@interface TDSErrorView : UIView {
  UIImageView*  _imageView;
  UILabel*      _titleView;
  UILabel*      _subtitleView;
}

@property (nonatomic, retain) UIImage*  image;
@property (nonatomic, copy)   NSString* title;
@property (nonatomic, copy)   NSString* subtitle;

- (id)initWithTitle:(NSString*)title subtitle:(NSString*)subtitle image:(UIImage*)image;

@end

