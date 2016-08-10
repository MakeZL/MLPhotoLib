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

+ (void)createAssetAlbumForName:(NSString *)albumName completionHandler:(nullable void(^)(BOOL success, NSError *__nullable error))completionHandler
{
    PHAssetCollection *collection = [self fetchAssetCollectionForAlbumName:albumName];
    if (collection != nil) {
        NSError *error = [NSError errorWithDomain:@"com.qiushibaike.www" code:-11 userInfo:@{@"errorMsg":@"相册已经存在"}];
        !completionHandler?:completionHandler(NO,error);
        return;
    }
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^ {
        [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:albumName];
    } completionHandler:^(BOOL success, NSError *error) {
        !completionHandler?:completionHandler(success, error);
    }];
}

+ (void)addAssetAlbumForName:(NSString *)albumName image:(UIImage *)image completionHandler:(nullable void(^)(BOOL success, NSError *__nullable error))completionHandler
{
    __weak typeof(self)weakSelf = self;
    [self createAssetAlbumForName:albumName completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (success || error.code == -11) {
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                PHAssetCollection *collection = [weakSelf fetchAssetCollectionForAlbumName:albumName];
                // Request creating an asset from the image.
                PHAssetChangeRequest *createAssetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
                // Request editing the album.
                PHAssetCollectionChangeRequest *albumChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection];
                // Get a placeholder for the new asset and add it to the album editing request.
                PHObjectPlaceholder *assetPlaceholder = [createAssetRequest placeholderForCreatedAsset];
                [albumChangeRequest addAssets:@[ assetPlaceholder ]];
                
            } completionHandler:^(BOOL success, NSError *error) {
                !completionHandler?:completionHandler(success, error);
            }];
        }
    }];
}

+ (PHAssetCollection *)fetchAssetCollectionForAlbumName:(NSString *)albumName
{
    // 列出所有用户创建的相册
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    PHAssetCollection *collection = nil;
    for (PHAssetCollection *assetCollection in topLevelUserCollections) {
        if ([[assetCollection valueForKey:@"title"] isEqualToString:albumName]) {
            collection = assetCollection;
            break;
        }
    }
    return collection;
}

@end
