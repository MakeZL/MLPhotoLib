//
//  MLPhotoPickerAssetsManager.m
//  MLPhotoLib
//
//  Created by leisuro on 16/8/3.
//  Copyright © 2016年 Free. All rights reserved.
//

#import "MLPhotoPickerAssetsManager.h"
#import "MLPhotoPickerManager.h"
#import "MLPhotoAsset.h"
#import "MLImagePickerHUD.h"

@implementation MLPhotoPickerAssetsManager

+ (instancetype)manager
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (PHFetchResult *)fetchResult
{
    if (!_fetchResult)
    {
        [self stopCachingImagesForAllAssets];
        
        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        self.fetchResult = [PHAsset fetchAssetsWithOptions:options];
    }
    return _fetchResult;
}

- (void)addCameraSelectedAssetWith:(MLPhotoAsset *)asset
{
    MLPhotoPickerManager *manager = [MLPhotoPickerManager manager];
    NSURL *assetURL = [asset assetURL];
    if (assetURL == nil) {
        return;
    }
    NSURL *curURL = [self curURLOfAssetThumbUrl:assetURL];
    [asset getThumbImageWithCompletion:^(UIImage *image) {
        if (![assetURL isEqual:curURL]) {
            [manager.selectsThumbImages addObject:@{assetURL:image}];
        }
    }];
    
    [asset getOriginImageWithCompletion:^(UIImage *image) {
        if (![assetURL isEqual:curURL]) {
            [manager.selectsOriginalImage addObject:@{assetURL:image}];
        }
    }];
}

- (void)addSelectedAssetWith:(MLPhotoAsset *)asset
{
    MLPhotoPickerManager *manager = [MLPhotoPickerManager manager];
    NSURL *assetURL = [asset assetURL];
    if (assetURL == nil) {
        return;
    }
    if (![manager.selectsUrls containsObject:assetURL]) {
        // Insert
        if (manager.selectsUrls.count >= [MLPhotoPickerManager manager].maxCount) {
            // Beyond Max Count.
            [MLImagePickerHUD showMessage:MLMaxCountMessage];
            return ;
        }
        [manager.selectsUrls addObject:assetURL];
    }
    
    NSURL *curURL = [self curURLOfAssetThumbUrl:assetURL];
    [asset getThumbImageWithCompletion:^(UIImage *image) {
        if (curURL == nil) {
            [manager.selectsThumbImages addObject:@{assetURL:image}];
        }
    }];
    
    [asset getOriginImageWithCompletion:^(UIImage *image) {
        if (curURL == nil) {
            [manager.selectsOriginalImage addObject:@{assetURL:image}];
        }
    }];
}

- (NSURL *)curURLOfAssetThumbUrl:(NSURL *)assetURL
{
    NSInteger index = 0;
    NSURL *curURL = nil;
    for (NSDictionary<NSURL *, UIImage *>*dict in [MLPhotoPickerManager manager].selectsThumbImages) {
        NSURL *url = [[dict allKeys] firstObject];
        if ([url isEqual:assetURL]) {
            curURL = url;
            break;
        }
        index++;
    }
    return curURL;
}

- (void)recoderPickerAssetURLAndImageWith:(MLPhotoAsset *)asset
{
    MLPhotoPickerManager *manager = [MLPhotoPickerManager manager];
    NSURL *assetURL = [asset assetURL];
    if (assetURL == nil) {
        return;
    }
    if ([manager.selectsUrls containsObject:assetURL]) {
        // Delete
        [manager.selectsUrls removeObject:assetURL];
    } else {
        // Insert
        if (manager.selectsUrls.count >= [MLPhotoPickerManager manager].maxCount) {
            // Beyond Max Count.
            [MLImagePickerHUD showMessage:MLMaxCountMessage];
            return ;
        }
        [manager.selectsUrls addObject:assetURL];
    }
    
    NSInteger index = 0;
    NSURL *curURL = nil;
    for (NSDictionary<NSURL *, UIImage *>*dict in manager.selectsThumbImages) {
        NSURL *url = [[dict allKeys] firstObject];
        if ([url isEqual:assetURL]) {
            curURL = url;
            break;
        }
        index++;
    }
    
    [asset getThumbImageWithCompletion:^(UIImage *image) {
        if ([assetURL isEqual:curURL]) {
            [manager.selectsThumbImages removeObjectAtIndex:index];
        } else {
            [manager.selectsThumbImages addObject:@{assetURL:image}];
        }
    }];
    
    [asset getOriginImageWithCompletion:^(UIImage *image) {
        if ([assetURL isEqual:curURL]) {
            [manager.selectsOriginalImage removeObjectAtIndex:index];
        } else {
            [manager.selectsOriginalImage addObject:@{assetURL:image}];
        }
    }];
}
@end
