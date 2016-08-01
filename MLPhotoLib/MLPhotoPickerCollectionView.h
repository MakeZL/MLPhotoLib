//
//  MLPhotoPickerCollectionView.h
//  MLPhotoLib
//
//  Created by leisuro on 16/8/1.
//  Copyright © 2016年 Free. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MLPhotoAsset;
@interface MLPhotoPickerCollectionView : UIView
@property (strong,nonatomic) NSArray<MLPhotoAsset *> *albumAssets;
@end
