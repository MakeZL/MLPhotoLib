//
//  MLPhotoPickerHeader.h
//  MLPhotoLib
//
//  Created by leisuro on 16/8/18.
//  Copyright © 2016年 Free. All rights reserved.
//

#ifndef MLPhotoPickerHeader_h
#define MLPhotoPickerHeader_h

#define gtiOS8 ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
#define WeakSelf __weak typeof(self)weakSelf = self;

#define MLImagePickerUIScreenScale ([[UIScreen mainScreen] scale])
#define UIScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define MLImagePickerCellWidth ((UIScreenWidth - MLImagePickerCellMargin * (MLShowRowCellCount + 1)) / MLShowRowCellCount)

static NSString *MLNotificationDidChangeSelectUrl = @"MLNotificationDidChangeSelectUrl";
static NSString *MLNotificationPhotoBrowserDidChangeSelectUrl = @"MLNotificationPhotoBrowserDidChangeSelectUrl";
static NSUInteger MLDefaultMaxCount = 9;
static NSInteger MLShowRowCellCount = 3;
static CGFloat MLImagePickerCellMargin = 2;
static NSString *MLMaxCountMessage = @"已经超出图片的最大数咯~";

#endif /* MLPhotoPickerHeader_h */
