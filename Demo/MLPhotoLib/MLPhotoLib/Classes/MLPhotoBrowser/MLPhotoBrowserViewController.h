//
//  MLPhotoBrowserViewController.h
//  MLPhotoLib
//
//  Created by leisuro on 16/8/10.
//  Copyright © 2016年 Free. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLPhoto : NSObject
@property (strong, nonatomic) NSURL *originalImageUrl;
@property (strong, nonatomic) UIImageView *photoImageView;
@end

@interface MLPhotoBrowserViewController : UIViewController
/// CurPage
@property (assign, nonatomic) BOOL curPage;
/// DataSource
@property (strong, nonatomic) NSArray<MLPhoto *>*photos;
/// Can Delete Photo
@property (assign, nonatomic) BOOL editMode;
/// Show && CallBlock.
- (void)displayForVC:(__weak UIViewController *)viewController;
@end
