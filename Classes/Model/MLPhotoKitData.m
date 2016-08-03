//
//  MLPhotoKitData.m
//  MLPhotoLib
//
//  Created by leisuro on 16/8/1.
//  Copyright © 2016年 Free. All rights reserved.
//

#import "MLPhotoKitData.h"

@implementation MLPhotoKitData
+ (BOOL)judgeIsHavePhotoAblumAuthority
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
}

+ (BOOL)judgeIsHaveCameraAuthority
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusRestricted ||
        status == AVAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
}
@end
