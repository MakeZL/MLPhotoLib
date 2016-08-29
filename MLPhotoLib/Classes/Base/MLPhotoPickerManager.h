//
//  MLPhotoPickerManager.h
//  MLPhotoLib
//
//  Created by leisuro on 16/8/1.
//  Copyright © 2016年 Free. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLPhotoPickerHeader.h"

@interface MLPhotoPickerManager : NSObject
+ (instancetype)manager;
+ (void)clear;

@property (nonatomic, assign) NSInteger maxCount;
/// MLImagePickerAssetsFilter.
@property (nonatomic, assign) MLImagePickerAssetsFilter assetsFilter;
/// Support Camera.
@property (nonatomic, assign) BOOL isSupportTakeCamera;
@property (nonatomic, strong) NSMutableArray *selectsUrls;
@property (nonatomic, weak) UIViewController *presentViewController;
@property (nonatomic, strong) UINavigationController *navigationController;

/// Select ThumbImage as @[@{@selectsUrl:@UIImage}, ..]
@property (nonatomic, strong) NSMutableArray *selectsThumbImages;
/// Select OriginalImage as @[@{@selectsUrl:@UIImage}, ..]
@property (nonatomic, strong) NSMutableArray *selectsOriginalImage;

// Ignore _selectsOriginalImage @{@"URL":UIImage} -> @[UIImage, UIImage]
@property (nonatomic, strong, readonly) NSMutableArray *originalImage;
@property (nonatomic, strong, readonly) NSMutableArray *thumbImages;

- (void)removeThumbAssetUrl:(NSURL *)assetUrl;
- (void)removeOriginalAssetUrl:(NSURL *)assetUrl;

- (BOOL)isBeyondMaxCount;
@end
