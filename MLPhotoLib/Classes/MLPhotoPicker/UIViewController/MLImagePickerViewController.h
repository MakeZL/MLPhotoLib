//
//  MLImagePickerViewController.h
//  MLPhotoLib
//
//  Created by leisuro on 16/8/1.
//  Copyright © 2016年 Free. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLPhotoPickerManager.h"

@class MLPhotoPickerGroup;
@interface MLImagePickerViewController : UIViewController
/// Init
+ (instancetype)pickerViewController;
/// Limit Count. Default 9
@property (nonatomic, assign) NSUInteger maxCount;
/// MLImagePickerAssetsFilter.
@property (nonatomic, assign) MLImagePickerAssetsFilter assetsFilter;
/// Support Camera. Default YES
@property (nonatomic, assign) BOOL isSupportTakeCamera;
/// Show && CallBlock.
- (void)displayForVC:(__weak UIViewController *)viewController
    completionHandle:(void(^)(BOOL success, NSArray<NSURL *>*assetUrls,
                                            NSArray<UIImage *>*thumbImages,
                                            NSArray<UIImage *>*originalImages,
                                            NSError *error))completionHandle;
/// Recoder Last Select Picker PHAsset/ALAsset URL.
@property (nonatomic, strong) NSArray<NSURL *>*selectAssetsURL;


/// Categories Use.
@property (nonatomic, strong) NSArray<MLPhotoPickerGroup *>*groups;
- (void)reloadCollectionViewWithGroup:(MLPhotoPickerGroup *)group;
- (void)tappendTitleView;

@end
