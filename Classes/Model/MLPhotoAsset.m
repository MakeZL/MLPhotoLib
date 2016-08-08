//
//  MLPhotoAsset.m
//  MLPhotoLib
//
//  Created by leisuro on 16/8/1.
//  Copyright © 2016年 Free. All rights reserved.
//

#import "MLPhotoAsset.h"

#define MLImagePickerUIScreenScale ([[UIScreen mainScreen] scale])
#define UIScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define MLImagePickerCellWidth ((UIScreenWidth - MLImagePickerCellMargin * (MLImagePickerCellRowCount + 1)) / MLImagePickerCellRowCount)

static CGFloat MLImagePickerCellMargin = 2;
static CGFloat MLImagePickerCellRowCount = 4;

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
        CGSize targetSize = CGSizeMake(MLImagePickerCellWidth * MLImagePickerUIScreenScale, MLImagePickerCellWidth * MLImagePickerUIScreenScale);
        [[MLPhotoPickerAssetsManager manager] requestImageForAsset:_asset targetSize:targetSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            !completion?:completion(result);
        }];
    } else {
        !completion?:completion([self thumbImage]);
    }
}

- (void)getOriginImageWithCompletion:(void(^)(UIImage *))completion
{
    if (self.isPHAsset) {
        // PhotoKit
        CGSize targetSize = CGSizeMake(MLImagePickerCellWidth * MLImagePickerUIScreenScale, MLImagePickerCellWidth * MLImagePickerUIScreenScale);
        [[MLPhotoPickerAssetsManager manager] requestImageForAsset:_asset targetSize:targetSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            !completion?:completion(result);
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
    return self.isUIImage ? _thumbImage : [UIImage imageWithCGImage:[self.asset aspectRatioThumbnail]];
}

- (UIImage *)originImage
{
    return self.isUIImage ? _originImage : [UIImage imageWithCGImage:[[self.asset defaultRepresentation] fullScreenImage]];
}

- (BOOL)isVideoType{
    NSString *type = [self.asset valueForProperty:ALAssetPropertyType];
    //媒体类型是视频
    return [type isEqualToString:ALAssetTypeVideo];
}

- (NSURL *)assetURL{
    return [[self.asset defaultRepresentation] url];
}

@end
