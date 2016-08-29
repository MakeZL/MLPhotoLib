//
//  MLPhotoBrowserCollectionCell.h
//  MLPhotoLib
//
//  Created by leisuro on 16/8/16.
//  Copyright © 2016年 Free. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MLPhoto;
typedef void(^didTapCellBlock)();
@interface MLPhotoBrowserCollectionCell : UICollectionViewCell
/// Can Delete Photo
@property (assign, nonatomic) BOOL editMode;
@property (nonatomic, strong) MLPhoto *photo;
@property (nonatomic, copy) didTapCellBlock didTapBlock;
@end
