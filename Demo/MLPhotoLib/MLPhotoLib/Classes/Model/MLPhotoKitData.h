//
//  MLPhotoKitData.h
//  MLPhotoLib
//
//  Created by leisuro on 16/8/1.
//  Copyright © 2016年 Free. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

// >= iOS8
@interface MLPhotoKitData : NSObject
#pragma mark - 判断获取相机、拍照权限
+ (BOOL)judgeIsHavePhotoAblumAuthority;
+ (BOOL)judgeIsHaveCameraAuthority;

/// 创建一个相册，存在的话不会创建
+ (void)createAssetAlbumForName:(nullable NSString *)albumName completionHandler:(nullable void(^)(BOOL success, NSError *__nullable error))completionHandler;
/// 创建一个相册，存在的话不会创建，并创建图片
+ (void)addAssetAlbumForName:(nullable NSString *)albumName image:(nullable UIImage *)image completionHandler:(nullable void(^)(BOOL success, NSError *__nullable error))completionHandler;

@end
