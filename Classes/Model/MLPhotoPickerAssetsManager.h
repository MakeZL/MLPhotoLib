//
//  MLPhotoPickerAssetsManager.h
//  MLPhotoLib
//
//  Created by 张磊 on 16/8/3.
//  Copyright © 2016年 Free. All rights reserved.
//

#import <Photos/Photos.h>

@interface MLPhotoPickerAssetsManager : PHCachingImageManager
+ (instancetype)manager;
@property (nonatomic, strong) PHFetchResult *fetchResult;
@end
