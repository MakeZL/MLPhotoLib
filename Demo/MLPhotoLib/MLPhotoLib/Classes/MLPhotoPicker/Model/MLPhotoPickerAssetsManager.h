//
//  MLPhotoPickerAssetsManager.h
//  MLPhotoLib
//
//  Created by leisuro on 16/8/3.
//  Copyright © 2016年 Free. All rights reserved.
//

#import <Photos/Photos.h>

@class MLPhotoAsset;
@interface MLPhotoPickerAssetsManager : PHCachingImageManager
+ (instancetype)manager;
- (void)recoderPickerAssetURLAndImageWith:(MLPhotoAsset *)asset;
- (void)addCameraSelectedAssetWith:(MLPhotoAsset *)asset;
- (void)addSelectedAssetWith:(MLPhotoAsset *)asset;

@property (nonatomic, strong) PHFetchResult *fetchResult;

@end
