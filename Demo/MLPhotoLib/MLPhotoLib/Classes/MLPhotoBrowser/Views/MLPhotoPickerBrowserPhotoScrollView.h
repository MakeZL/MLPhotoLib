//
//  MLPhotoPickerBrowserPhotoScrollView.h
//  MLPhotoLib
//
//  Created by leisuro on 14-11-14.
//  Copyright (c) 2014年 com.github.makezl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MLPhotoPickerBrowserPhotoImageView.h"
#import "MLPhotoPickerBrowserPhotoView.h"
#import "MLPhoto.h"

typedef void(^callBackPhotoBlock)(id img);
@class MLPhotoPickerBrowserPhotoScrollView;

@protocol MLPhotoPickerPhotoScrollViewDelegate <NSObject>
@optional
// 单击调用
- (void) pickerPhotoScrollViewDidSingleClick:(MLPhotoPickerBrowserPhotoScrollView *)photoScrollView;
@end

@interface MLPhotoPickerBrowserPhotoScrollView : UIScrollView <UIScrollViewDelegate, MLPhotoPickerBrowserPhotoImageViewDelegate,MLPhotoPickerBrowserPhotoViewDelegate>

@property (nonatomic,strong) MLPhoto *photo;
@property (strong,nonatomic) MLPhotoPickerBrowserPhotoImageView *photoImageView;
@property (nonatomic, weak) id <MLPhotoPickerPhotoScrollViewDelegate> photoScrollViewDelegate;
// 长按图片的操作，可以外面传入
@property (strong,nonatomic) UIActionSheet *sheet;

// 单击销毁的block
@property (copy,nonatomic) callBackPhotoBlock callback;
- (void)setMaxMinZoomScalesForCurrentBounds;
@end
