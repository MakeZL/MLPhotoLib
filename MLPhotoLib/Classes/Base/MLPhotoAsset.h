//
//  MLPhotoAsset.h
//  MLPhotoLib
//
//  Created by leisuro on 16/8/1.
//  Copyright © 2016年 Free. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "MLPhotoPickerAssetsManager.h"

@interface MLPhotoAsset : NSObject

+ (instancetype)assetWithImage:(UIImage *)image;

@property (assign, nonatomic) BOOL isPHAsset;
// PHAsset/ALAsset
@property (strong, nonatomic) id asset;

+ (void)getAssetWithThumbImage:(PHAsset *)asset completion:(void(^)(UIImage *))completion;
- (void)getThumbImageWithCompletion:(void(^)(UIImage *))completion;
- (void)getOriginImageWithCompletion:(void(^)(UIImage *))completion;

// 是否是视频类型
@property (assign,nonatomic) BOOL isVideoType;
@property (weak,nonatomic) UIImageView *toView;
// 图片的URL
- (NSURL *)assetURL;

@end
