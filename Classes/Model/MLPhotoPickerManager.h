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

#define MLImagePickerUIScreenScale ([[UIScreen mainScreen] scale])
#define UIScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define MLImagePickerCellWidth ((UIScreenWidth - MLImagePickerCellMargin * (MLShowRowCellCount + 1)) / MLShowRowCellCount)

static NSUInteger MLDefaultMaxCount = 9;
static NSInteger MLShowRowCellCount = 3;
static CGFloat MLImagePickerCellMargin = 2;


@interface MLPhotoPickerManager : NSObject
+ (instancetype)manager;
+ (void)clear;

@property (nonatomic, assign) NSInteger maxCount;
@property (nonatomic, strong) NSMutableArray *selectsUrls;

/// Select ThumbImage as @[@{@selectsUrl:@UIImage}, ..]
@property (nonatomic, strong) NSMutableArray *selectsThumbImages;
/// Select OriginalImage as @[@{@selectsUrl:@UIImage}, ..]
@property (nonatomic, strong) NSMutableArray *selectsOriginalImage;

// Ignore _selectsOriginalImage @{@"URL":UIImage} -> @[UIImage, UIImage]
@property (nonatomic, strong, readonly) NSMutableArray *originalImage;
@property (nonatomic, strong, readonly) NSMutableArray *thumbImages;

@end
