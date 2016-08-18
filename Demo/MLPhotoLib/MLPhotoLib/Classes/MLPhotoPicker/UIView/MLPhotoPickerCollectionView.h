//
//  MLPhotoPickerCollectionView.h
//  MLPhotoLib
//
//  Created by leisuro on 16/8/1.
//  Copyright © 2016年 Free. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MLPhotoAsset, MLPhotoPickerGroup;
@interface MLPhotoPickerCollectionView : UIView
@property (strong,nonatomic) MLPhotoPickerGroup *group;
@property (strong,nonatomic) NSArray<MLPhotoAsset *> *albumAssets;

@property (nonatomic, weak) UICollectionView *collectionView;
@end
