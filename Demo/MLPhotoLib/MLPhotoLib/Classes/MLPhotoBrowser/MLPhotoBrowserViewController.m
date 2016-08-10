//
//  MLPhotoBrowserViewController.m
//  MLPhotoLib
//
//  Created by leisuro on 16/8/10.
//  Copyright © 2016年 Free. All rights reserved.
//

#import "MLPhotoBrowserViewController.h"
#import "ZLPhotoRect.h"

@implementation MLPhoto

@end

@interface MLPhotoBrowserViewController ()

@end

@implementation MLPhotoBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)displayForVC:(__weak UIViewController *)viewController
{
    if (self.photos.count == 0 || self.curPage > self.photos.count) {
        NSLog(@"photos is empty");
        return;
    }
    
    MLPhoto *curPhoto = [self.photos objectAtIndex:self.curPage];
    
    CGRect tempF = [curPhoto.photoImageView.superview convertRect:curPhoto.photoImageView.frame toView:[self getParsentViewController:curPhoto.photoImageView]];
    
    UIWindow *window = [self getCurWindowWithView:viewController.view];
    UIView *imageContainerView = [[UIView alloc] init];
    imageContainerView.backgroundColor = [UIColor clearColor];
    imageContainerView.frame = tempF;
    [window addSubview:imageContainerView];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = curPhoto.photoImageView.image;
    imageView.frame = imageContainerView.bounds;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [imageContainerView addSubview:imageView];
    
    CGRect imageFrame = [ZLPhotoRect setMaxMinZoomScalesForCurrentBoundWithImageView:curPhoto.photoImageView];
    [UIView animateWithDuration:1.0 animations:^{
        imageContainerView.frame = imageFrame;
    } completion:^(BOOL finished) {
//        [viewController presentViewController:self animated:NO completion:nil];
    }];
    
}

- (UIWindow *)getCurWindowWithView:(UIResponder *)view
{
    if (view == nil || [view isKindOfClass:[UIWindow class]]) {
        return (UIWindow *)view;
    }
    return [self getCurWindowWithView:[view nextResponder]];
}

- (UIView *)getParsentViewController:(UIView *)view
{
    if ([[view nextResponder] isKindOfClass:[UIViewController class]] || view == nil) {
        return (UIView *)[view nextResponder];
    }
    return [self getParsentViewController:view.superview];
}

@end
