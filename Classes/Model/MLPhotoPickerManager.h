//
//  MLPhotoPickerManager.h
//  MLPhotoLib
//
//  Created by leisuro on 16/8/1.
//  Copyright © 2016年 Free. All rights reserved.
//

#import <UIKit/UIKit.h>

#define gtiOS8 ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
#define WeakSelf __weak typeof(self)weakSelf = self;

@interface MLPhotoPickerManager : NSObject
+ (instancetype)manager;
+ (void)clear;

@property (nonatomic, strong) NSMutableArray *selectsUrls;

/// Select ThumbImage as @[@{@selectsUrl:@UIImage}, ..]
@property (nonatomic, strong) NSMutableArray *selectsThumbImages;
/// Select OriginalImage as @[@{@selectsUrl:@UIImage}, ..]
@property (nonatomic, strong) NSMutableArray *selectsOriginalImage;

// Ignore _selectsOriginalImage @{@"URL":UIImage} -> @[UIImage, UIImage]
@property (nonatomic, strong) NSMutableArray *originalImage;
@property (nonatomic, strong) NSMutableArray *thumbImages;

@end
