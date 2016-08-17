//
//  MLPhotoBrowserViewController.h
//  MLPhotoLib
//
//  Created by leisuro on 16/8/10.
//  Copyright © 2016年 Free. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLPhoto.h"

@class MLPhotoBrowserViewController;
@protocol MLPhotoBrowserViewControllerDelegate <NSObject>
@optional
- (void)photoBrowser:(MLPhotoBrowserViewController *)photoBrowser didScrollToPage:(NSInteger)page;
@end

@interface MLPhotoBrowserViewController : UIViewController
@property (weak, nonatomic) id<MLPhotoBrowserViewControllerDelegate>delegate;
/// CurPage
@property (assign, nonatomic) NSInteger curPage;
/// DataSource
@property (strong, nonatomic) NSArray<MLPhoto *>*photos;
/// Can Delete Photo
@property (assign, nonatomic) BOOL editMode;
/// Show && CallBlock.
- (void)displayForVC:(__weak UIViewController *)viewController;

- (void)reloadData;
- (void)reloadDataForIndex:(NSInteger)index;
@end
