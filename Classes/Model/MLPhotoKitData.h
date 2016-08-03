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


@end
