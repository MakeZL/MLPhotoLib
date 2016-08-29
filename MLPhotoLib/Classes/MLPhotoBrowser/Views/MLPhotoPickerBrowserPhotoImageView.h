//
//  ZLPhotoPickerBrowserPhotoImageView.h
//  MLPhotoLib
//
//  Created by leisuro on 14-11-14.
//  Copyright (c) 2014年 com.github.makezl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol MLPhotoPickerBrowserPhotoImageViewDelegate;

@interface MLPhotoPickerBrowserPhotoImageView : UIImageView {}

@property (nonatomic, weak) id <MLPhotoPickerBrowserPhotoImageViewDelegate> tapDelegate;
@property (assign,nonatomic) CGFloat progress;

- (void)addScaleBigTap;
- (void)removeScaleBigTap;
@end

@protocol MLPhotoPickerBrowserPhotoImageViewDelegate <NSObject>

@optional
- (void)imageView:(UIImageView *)imageView singleTapDetected:(UITouch *)touch;
- (void)imageView:(UIImageView *)imageView doubleTapDetected:(UITouch *)touch;

@end