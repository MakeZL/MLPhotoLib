//
//  MLImagePickerViewController.h
//  MLPhotoLib
//
//  Created by leisuro on 16/8/1.
//  Copyright © 2016年 Free. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MLPhotoPickerGroup;
@interface MLImagePickerViewController : UIViewController
+ (instancetype)pickerViewController;

@property (nonatomic, strong) NSArray<MLPhotoPickerGroup *>*groups;

- (void)reloadCollectionViewWithGroup:(MLPhotoPickerGroup *)group;
- (void)tappendTitleView;
/// Limit Max Picker Count
@property (nonatomic, assign) NSUInteger maxCount;
/// Show In viewController
- (void)displayForVC:(__weak UIViewController *)viewController;
/// Show In Window.
- (void)display;
@end
