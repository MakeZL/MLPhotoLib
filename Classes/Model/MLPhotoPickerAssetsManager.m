//
//  MLPhotoPickerAssetsManager.m
//  MLPhotoLib
//
//  Created by 张磊 on 16/8/3.
//  Copyright © 2016年 Free. All rights reserved.
//

#import "MLPhotoPickerAssetsManager.h"

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

@end
