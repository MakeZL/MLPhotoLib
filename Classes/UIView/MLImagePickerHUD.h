//
//  MLImagePickerHUD.h
//  MLPhotoLib
//
//  Created by leisuro on 16/8/9.
//  Copyright © 2016年 Free. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLImagePickerHUD : UIView
+ (void)showMessage:(NSString *)message;
+ (void)showMessage:(NSString *)message duration:(CGFloat)duration;
@end
