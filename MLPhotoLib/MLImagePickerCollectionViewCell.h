//
//  MLImagePickerCollectionViewCell.h
//  MLPhotoLib
//
//  Created by leisuro on 16/8/1.
//  Copyright © 2016年 Free. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MLPhotoAsset;
@interface MLImagePickerCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *tagButton;

@property (strong, nonatomic) MLPhotoAsset *asset;
@end
