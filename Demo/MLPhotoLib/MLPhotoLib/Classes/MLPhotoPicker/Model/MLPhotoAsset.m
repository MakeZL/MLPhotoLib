//
//  MLPhotoAsset.m
//  MLPhotoLib
//
//  Created by leisuro on 16/8/1.
//  Copyright © 2016年 Free. All rights reserved.
//

#import "MLPhotoAsset.h"
#import "MLPhotoPickerManager.h"

@interface MLPhotoAsset ()
@property (nonatomic, assign) BOOL isUIImage;
// 缩略图
@property (nonatomic, strong) UIImage *thumbImage;
// 原图
@property (nonatomic, strong) UIImage *originImage;
@end

@implementation MLPhotoAsset

+ (instancetype)assetWithImage:(UIImage *)image
{
    MLPhotoAsset *asset = [[MLPhotoAsset alloc] init];
    asset.isUIImage = YES;
    asset.thumbImage = image;
    asset.originImage = image;
    return asset;
}

- (void)setAsset:(id)asset
{
    _asset = asset;
    
    if ([asset isKindOfClass:[PHAsset class]]) {
        _isPHAsset = YES;
    }
}

- (void)getThumbImageWithCompletion:(void(^)(UIImage *))completion
{
    if (self.isPHAsset) {
        // PhotoKit
        CGSize targetSize = CGSizeMake(MLImagePickerCellWidth*1.5, MLImagePickerCellWidth*1.5);
        PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
        requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        requestOptions.networkAccessAllowed = YES;
        
        [[MLPhotoPickerAssetsManager manager] requestImageForAsset:_asset targetSize:targetSize contentMode:PHImageContentModeAspectFill options:requestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            if ([[info valueForKey:@"PHImageResultIsDegradedKey"] integerValue] == 0) {
                !completion?:completion(result);
            }
        }];
    } else {
        !completion?:completion([self thumbImage]);
    }
}

- (void)getOriginImageWithCompletion:(void(^)(UIImage *))completion
{
    if (self.isPHAsset) {
        // PhotoKit
        CGSize targetSize = [UIScreen mainScreen].bounds.size;
        
        PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
        requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        requestOptions.networkAccessAllowed = YES;
        
        [[MLPhotoPickerAssetsManager manager] requestImageForAsset:_asset targetSize:targetSize contentMode:PHImageContentModeAspectFill options:requestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            if ([[info valueForKey:@"PHImageResultIsDegradedKey"] integerValue] == 0) {
                !completion?:completion(result);
            }
        }];
    } else {
        return !completion?:completion([self originImage]);
    }
}

+ (void)getAssetWithThumbImage:(PHAsset *)asset completion:(void(^)(UIImage *))completion
{
    CGSize targetSize = CGSizeMake(MLImagePickerCellWidth * MLImagePickerUIScreenScale, MLImagePickerCellWidth * MLImagePickerUIScreenScale);
    [[MLPhotoPickerAssetsManager manager] requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        !completion?:completion(result);
    }];
}

- (UIImage *)thumbImage
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated"
    return self.isUIImage ? _thumbImage : [UIImage imageWithCGImage:[self.asset aspectRatioThumbnail]];
#pragma clang diagnostic pop
}

- (UIImage *)originImage
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated"
    return self.isUIImage ? _originImage : [UIImage imageWithCGImage:[[self.asset defaultRepresentation] fullScreenImage]];
#pragma clang diagnostic pop
}

- (BOOL)isVideoType{
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated"
    if (self.isPHAsset) {
        return ([(PHAsset *)self.asset mediaType] == PHAssetMediaTypeVideo);
    }
    NSString *type = [self.asset valueForProperty:ALAssetPropertyType];
    //媒体类型是视频
    return [type isEqualToString:ALAssetTypeVideo];
#pragma clang diagnostic pop
}

- (NSURL *)assetURL
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated"
    if (self.isPHAsset) {
        PHAssetResource *resource = [PHAssetResource assetResourcesForAsset:self.asset].firstObject;
        return [resource valueForKey:@"_privateFileURL"];
    }
    return [[self.asset defaultRepresentation] url];
#pragma clang diagnostic pop
}

@end
