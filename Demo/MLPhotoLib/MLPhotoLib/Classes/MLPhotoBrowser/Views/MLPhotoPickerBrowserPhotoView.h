//
//  MLPhotoPickerBrowserPhotoView.h
//  MLPhotoLib
//
//  Created by leisuro on 14-11-14.
//  Copyright (c) 2014年 com.github.makezl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol MLPhotoPickerBrowserPhotoViewDelegate;

@interface MLPhotoPickerBrowserPhotoView : UIView {}

@property (nonatomic, weak) id <MLPhotoPickerBrowserPhotoViewDelegate> tapDelegate;

@end

@protocol MLPhotoPickerBrowserPhotoViewDelegate <NSObject>

@optional

- (void)view:(UIView *)view singleTapDetected:(UITouch *)touch;
- (void)view:(UIView *)view doubleTapDetected:(UITouch *)touch;

@end