//
//  MLImagePickerCollectionViewCell.m
//  MLPhotoLib
//
//  Created by leisuro on 16/8/1.
//  Copyright © 2016年 Free. All rights reserved.
//

#import "MLImagePickerCollectionViewCell.h"
#import "MLPhotoPickerManager.h"
#import "MLPhotoAsset.h"

@implementation MLImagePickerCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.hidden = YES;
    [self.tagButton setImage:[UIImage imageNamed:@"MLImagePickerController.bundle/zl_icon_image_no"] forState:UIControlStateNormal];
    [self.tagButton setImage:[UIImage imageNamed:@"MLImagePickerController.bundle/zl_icon_image_yes"] forState:UIControlStateSelected];
}

- (void)setAsset:(MLPhotoAsset *)asset
{
    _asset = asset;
    
    self.hidden = NO;
    [asset getThumbImageWithCompletion:^(UIImage *image) {
        self.imageView.image = image;
    }];
    
    MLPhotoPickerManager *manager = [MLPhotoPickerManager manager];
    BOOL isSelected = [manager.selectsUrls containsObject:[asset assetURL]];
    self.tagButton.selected = isSelected;
}

- (IBAction)tagBtnClick
{
    MLPhotoPickerManager *manager = [MLPhotoPickerManager manager];
    NSURL *assetURL = [self.asset assetURL];
    if (assetURL == nil) {
        return;
    }
    if ([manager.selectsUrls containsObject:assetURL]) {
        // Delete
        [manager.selectsUrls removeObject:assetURL];
    } else {
        // Insert
        [manager.selectsUrls addObject:assetURL];
    }
    
    BOOL isSelected = [manager.selectsUrls containsObject:[self.asset assetURL]];
    self.tagButton.selected = isSelected;
}
@end
