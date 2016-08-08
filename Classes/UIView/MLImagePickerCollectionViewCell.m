//
//  MLImagePickerCollectionViewCell.m
//  MLPhotoLib
//
//  Created by leisuro on 16/8/1.
//  Copyright © 2016年 Free. All rights reserved.
//

#import "MLImagePickerCollectionViewCell.h"
#import "MLPhotoAsset.h"

@implementation MLImagePickerCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.hidden = YES;
}

- (void)setAsset:(MLPhotoAsset *)asset
{
    _asset = asset;
    
    self.hidden = NO;
    [asset getThumbImageWithCompletion:^(UIImage *image) {
        self.imageView.image = image;
    }];
}

@end
