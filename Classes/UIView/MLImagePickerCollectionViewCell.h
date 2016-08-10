//
//  MLImagePickerCollectionViewCell.h
//  MLPhotoLib
//
//  Created by leisuro on 16/8/1.
//  Copyright © 2016年 Free. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLPhotoAsset.h"

@interface MLImagePickerCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *tagButton;

@property (strong, nonatomic) MLPhotoAsset *asset;

- (void)activeDidSelecteAsset;

@end
