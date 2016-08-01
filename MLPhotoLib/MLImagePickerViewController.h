//
//  MLImagePickerViewController.h
//  MLPhotoLib
//
//  Created by leisuro on 16/8/1.
//  Copyright © 2016年 Free. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLImagePickerViewController : UIViewController
+ (instancetype)pickerViewController;
/// Limit Max Picker Count
@property (nonatomic, assign) NSUInteger maxCount;
/// Show In viewController
- (void)displayForVC:(__weak UIViewController *)viewController;
/// Show In Window.
- (void)display;
@end
