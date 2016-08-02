//
//  MLPhotoAsset.h
//  MLPhotoLib
//
//  Created by leisuro on 16/8/1.
//  Copyright © 2016年 Free. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface MLPhotoAsset : NSObject

+ (instancetype)assetWithImage:(UIImage *)image;

@property (strong,nonatomic) ALAsset *asset;
// 比例图
@property (nonatomic, strong) UIImage *aspectRatioImage;
// 缩略图
@property (nonatomic, strong) UIImage *thumbImage;
// 原图
@property (nonatomic, strong) UIImage *originImage;
// 是否是视频类型
@property (assign,nonatomic) BOOL isVideoType;
@property (weak,nonatomic) UIImageView *toView;
// 图片的URL
- (NSURL *)assetURL;

@end
