//
//  MLPhotoPickerManager.m
//  MLPhotoLib
//
//  Created by leisuro on 16/8/1.
//  Copyright © 2016年 Free. All rights reserved.
//

#import "MLPhotoPickerManager.h"

@implementation MLPhotoPickerManager
+ (instancetype)manager
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (NSMutableArray *)selectsUrls
{
    if (!_selectsUrls) {
        _selectsUrls = @[].mutableCopy;
    }
    return _selectsUrls;
}

- (NSMutableArray *)selectsThumbImages
{
    if (!_selectsThumbImages) {
        _selectsThumbImages = @[].mutableCopy;
    }
    return _selectsThumbImages;
}

- (NSMutableArray *)selectsOriginalImage
{
    if (!_selectsOriginalImage) {
        _selectsOriginalImage = @[].mutableCopy;
    }
    return _selectsOriginalImage;
}

- (NSMutableArray *)originalImage
{
    NSMutableArray *tmpImages = [NSMutableArray arrayWithCapacity:[_selectsOriginalImage count]];
    for (NSDictionary<NSURL *, UIImage *>*dict in _selectsOriginalImage) {
        [tmpImages addObject:[[dict allValues] firstObject]];
    }
    return tmpImages;
}

- (NSMutableArray *)thumbImages
{
    NSMutableArray *tmpImages = [NSMutableArray arrayWithCapacity:[_selectsThumbImages count]];
    for (NSDictionary<NSURL *, UIImage *>*dict in _selectsThumbImages) {
        [tmpImages addObject:[[dict allValues] firstObject]];
    }
    return tmpImages;
}

- (BOOL)isBeyondMaxCount
{
    return [MLPhotoPickerManager manager].selectsUrls.count >= [MLPhotoPickerManager manager].maxCount;
}

- (void)removeThumbAssetUrl:(NSURL *)assetUrl
{
    for (NSDictionary *dic in [MLPhotoPickerManager manager].selectsThumbImages) {
        if ([[[dic allKeys] firstObject] isEqual:assetUrl])
        {
            [[MLPhotoPickerManager manager].selectsThumbImages removeObject:dic];
            break;
        }
    }
}

- (void)removeOriginalAssetUrl:(NSURL *)assetUrl
{
    for (NSDictionary *dic in [MLPhotoPickerManager manager].selectsOriginalImage) {
        if ([[[dic allKeys] firstObject] isEqual:assetUrl])
        {
            [[MLPhotoPickerManager manager].selectsOriginalImage removeObject:dic];
            break;
        }
    }
}

+ (void)clear
{
    [[self manager] setNavigationController:nil];
    [[self manager] setIsSupportTakeCamera:YES];
    [[self manager] setMaxCount:MLDefaultMaxCount];
    [[[self manager] selectsUrls] removeAllObjects];
    [[[self manager] selectsOriginalImage] removeAllObjects];
    [[[self manager] selectsThumbImages] removeAllObjects];
}
@end
