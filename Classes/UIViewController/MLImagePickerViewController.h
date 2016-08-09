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
+ (instancetype)pickerViewController;

@property (nonatomic, strong) NSArray<MLPhotoPickerGroup *>*groups;
@property (nonatomic, strong) NSArray<NSURL *>*selectAssetsURL;

- (void)reloadCollectionViewWithGroup:(MLPhotoPickerGroup *)group;
- (void)tappendTitleView;
/// Limit Max Picker Count
@property (nonatomic, assign) NSUInteger maxCount;
/// Show In viewController
- (void)displayForVC:(__weak UIViewController *)viewController completionHandle:(void(^)(BOOL success, NSArray<NSURL *>*assetUrls, NSArray<UIImage *>*thumbImages, NSArray<UIImage *>*originalImages, NSError *error))completionHandle;
@end
