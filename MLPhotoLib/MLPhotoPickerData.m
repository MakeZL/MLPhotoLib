//
//  MLPhotoPickerData.m
//  MLPhotoLib
//
//  Created by leisuro on 16/8/1.
//  Copyright © 2016年 Free. All rights reserved.
//

#import "MLPhotoPickerData.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>

@interface MLPhotoPickerData ()
@property (nonatomic , strong)ALAssetsLibrary *library;
@end

@implementation MLPhotoPickerData

+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred,^
                  {
                      library = [[ALAssetsLibrary alloc] init];
                  });
    return library;
}

- (ALAssetsLibrary *)library
{
    if (nil == _library)
    {
        _library = [self.class defaultAssetsLibrary];
    }
    return _library;
}

#pragma mark - getter
+ (instancetype)pickerData{
    return [[self alloc] init];
}

#pragma mark -获取所有组
- (void)getAllGroupWithPhotos:(MLPhotoPickerDataPhotoCallBack)callBack{
    [self getAllGroupAllPhotos:YES withResource:callBack];
}

/**
 * 获取所有组对应的图片
 */
- (void)getAllGroup:(MLPhotoPickerDataPhotoCallBack)callBack{
    NSMutableArray *groups = [NSMutableArray array];
    ALAssetsLibraryGroupsEnumerationResultsBlock resultBlock = ^(ALAssetsGroup *group, BOOL *stop){
        if (group){
            // 包装一个模型来赋值
            MLPhotoPickerGroup *pickerGroup = [[MLPhotoPickerGroup alloc] init];
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            pickerGroup.group = group;
            pickerGroup.groupName = [group valueForProperty:@"ALAssetsGroupPropertyName"];
            pickerGroup.type = [group valueForProperty:@"ALAssetsGroupPropertyType"];
            pickerGroup.thumbImage = [UIImage imageWithCGImage:[group posterImage]];
            pickerGroup.assetsCount = [group numberOfAssets];
            [groups addObject:pickerGroup];
        }else{
            callBack(groups);
        }
    };
    
    NSInteger type = ALAssetsGroupAll;
    
    [self.library enumerateGroupsWithTypes:type usingBlock:resultBlock failureBlock:nil];
}


/**
 * 获取所有组对应的图片与视频
 */
- (void)getAllGroupWithPhotosAndVideos:(MLPhotoPickerDataPhotoCallBack)callBack{
    NSMutableArray *groups = [NSMutableArray array];
    ALAssetsLibraryGroupsEnumerationResultsBlock resultBlock = ^(ALAssetsGroup *group, BOOL *stop){
        if (group){
            // 包装一个模型来赋值
            MLPhotoPickerGroup *pickerGroup = [[MLPhotoPickerGroup alloc] init];
            pickerGroup.group = group;
            pickerGroup.groupName = [group valueForProperty:@"ALAssetsGroupPropertyName"];
            pickerGroup.thumbImage = [UIImage imageWithCGImage:[group posterImage]];
            pickerGroup.assetsCount = [group numberOfAssets];
            [groups addObject:pickerGroup];
        }else{
            callBack(groups);
        }
    };
    
    NSInteger type = ALAssetsGroupAll;
    
    [self.library enumerateGroupsWithTypes:type usingBlock:resultBlock failureBlock:nil];
}

- (void)getAllGroupAllPhotos:(BOOL)allPhotos withResource:(MLPhotoPickerDataPhotoCallBack)callBack{
    NSMutableArray *groups = [NSMutableArray array];
    ALAssetsLibraryGroupsEnumerationResultsBlock resultBlock = ^(ALAssetsGroup *group, BOOL *stop){
        if (group){
            // 包装一个模型来赋值
            MLPhotoPickerGroup *pickerGroup = [[MLPhotoPickerGroup alloc] init];
            if (allPhotos){
                [group setAssetsFilter:[ALAssetsFilter allAssets]];
            }else{
                pickerGroup.isVideo = YES;
                [group setAssetsFilter:[ALAssetsFilter allVideos]];
            }
            pickerGroup.group = group;
            pickerGroup.groupName = [group valueForProperty:@"ALAssetsGroupPropertyName"];
            pickerGroup.thumbImage = [UIImage imageWithCGImage:[group posterImage]];
            pickerGroup.assetsCount = [group numberOfAssets];
            [groups addObject:pickerGroup];
        }else{
            callBack(groups);
        }
    };
    
    NSInteger type = ALAssetsGroupAll;
    
    [self.library enumerateGroupsWithTypes:type usingBlock:resultBlock failureBlock:nil];
}

/**
 * 获取所有组对应的图片
 */
- (void)getAllGroupWithVideos:(MLPhotoPickerDataPhotoCallBack)callBack {
    [self getAllGroupAllPhotos:NO withResource:callBack];
}

#pragma mark -传入一个组获取组里面的Asset
- (void)getGroupPhotosWithGroup:(MLPhotoPickerGroup *)pickerGroup finished:(MLPhotoPickerDataPhotoCallBack)callBack{
    
    NSMutableArray *assets = [NSMutableArray array];
    ALAssetsGroupEnumerationResultsBlock result = ^(ALAsset *asset , NSUInteger index , BOOL *stop){
        if (asset){
            [assets addObject:asset];
        }else{
            callBack(assets);
        }
    };
    [pickerGroup.group enumerateAssetsUsingBlock:result];
    
}

#pragma mark -传入一个AssetsURL来获取UIImage
- (void)getAssetsPhotoWithURLs:(NSURL *)url callBack:(MLPhotoPickerDataPhotoCallBack)callBack{
    [self.library assetForURL:url resultBlock:^(ALAsset *asset){
        dispatch_async(dispatch_get_main_queue(), ^{
            callBack([UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]]);
        });
    } failureBlock:nil];
}

@end

@implementation MLPhotoPickerGroup @end