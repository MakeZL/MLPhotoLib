//
//  MLImagePickerCollectionViewCell.m
//  MLPhotoLib
//
//  Created by leisuro on 16/8/1.
//  Copyright © 2016年 Free. All rights reserved.
//

#import "MLImagePickerCollectionViewCell.h"
#import "MLPhotoPickerManager.h"
#import "MLImagePickerHUD.h"
#import "MLPhotoAsset.h"
#import "UIButton+Animation.h"
#import "MLPhotoPickerAssetsManager.h"

@implementation MLImagePickerCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.hidden = YES;
    
    self.tagButton.exclusiveTouch = YES;
    [self.tagButton setImage:[UIImage imageNamed:@"MLImagePickerController.bundle/zl_icon_image_no"] forState:UIControlStateNormal];
    [self.tagButton setImage:[UIImage imageNamed:@"MLImagePickerController.bundle/zl_icon_image_yes"] forState:UIControlStateSelected];
}

- (void)setAsset:(MLPhotoAsset *)asset
{
    _asset = asset;
    
    self.hidden = NO;
    WeakSelf
    [asset getThumbImageWithCompletion:^(UIImage *image) {
        weakSelf.imageView.image = image;
    }];
    
    MLPhotoPickerManager *manager = [MLPhotoPickerManager manager];
    NSURL *assetURL = [self.asset assetURL];
    BOOL isSelected = [manager.selectsUrls containsObject:assetURL];
    self.tagButton.selected = isSelected;
    
    if (isSelected) {
        // Add Recoder
        [[MLPhotoPickerAssetsManager manager] addCameraSelectedAssetWith:self.asset];
    }
    
}

- (IBAction)tagBtnClick
{
    // Recoder Select/Cancle Select Asset
    [[MLPhotoPickerAssetsManager manager] recoderPickerAssetURLAndImageWith:self.asset];
    
    BOOL isSelected = [[MLPhotoPickerManager manager].selectsUrls containsObject:[self.asset assetURL]];
    self.tagButton.selected = isSelected;
    [self.tagButton startScaleAnimation];
    
    // refresh selectUrl count;
    [[NSNotificationCenter defaultCenter] postNotificationName:MLNotificationDidChangeSelectUrl object:nil];
}

- (void)activeDidSelecteAsset
{
    // Insert
    if ([MLPhotoPickerManager manager].selectsUrls.count >= [MLPhotoPickerManager manager].maxCount) {
        // Beyond Max Count.
        [MLImagePickerHUD showMessage:MLMaxCountMessage];
        return ;
    }
    // Add Recoder
    [[MLPhotoPickerAssetsManager manager] addSelectedAssetWith:self.asset];
    self.tagButton.selected = YES;
}

@end
