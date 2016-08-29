//
//  UIButton+Animation.m
//  MLPhotoLib
//
//  Created by leisuro on 16/8/9.
//  Copyright © 2016年 Free. All rights reserved.
//

#import "UIButton+Animation.h"

@implementation UIButton (Animation)
- (void)startScaleAnimation
{
    [self startScaleAnimationDuration:0.20];
}

- (void)startScaleAnimationDuration:(CGFloat)duration
{
    [UIView animateWithDuration:0.20 animations:^{
        self.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [self endScaleAnimation];
    }];
}

- (void)endScaleAnimation
{
    [UIView animateWithDuration:0.20 animations:^{
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
}
@end
