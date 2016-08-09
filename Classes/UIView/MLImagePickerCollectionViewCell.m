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
    WeakSelf
    [asset getThumbImageWithCompletion:^(UIImage *image) {
        weakSelf.imageView.image = image;
    }];
    
    MLPhotoPickerManager *manager = [MLPhotoPickerManager manager];
    NSURL *assetURL = [self.asset assetURL];
    BOOL isSelected = [manager.selectsUrls containsObject:assetURL];
    self.tagButton.selected = isSelected;
    
    if (isSelected) {
        NSInteger index = 0;
        NSURL *curURL = nil;
        for (NSDictionary<NSURL *, UIImage *>*dict in manager.selectsThumbImages) {
            NSURL *url = [[dict allKeys] firstObject];
            if ([url isEqual:assetURL]) {
                curURL = url;
                break;
            }
            index++;
        }
    
        [self.asset getThumbImageWithCompletion:^(UIImage *image) {
            if (![assetURL isEqual:curURL]) {
                [manager.selectsThumbImages addObject:@{assetURL:image}];
            }
        }];
        
        [self.asset getOriginImageWithCompletion:^(UIImage *image) {
            if (![assetURL isEqual:curURL]) {
                [manager.selectsOriginalImage addObject:@{assetURL:image}];
            }
        }];
    }
    
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
        if (manager.selectsUrls.count >= [MLPhotoPickerManager manager].maxCount) {
            // Beyond Max Count.
            [MLImagePickerHUD showMessage:MLMaxCountMessage];
            return ;
        }
        [manager.selectsUrls addObject:assetURL];
    }
    
    NSInteger index = 0;
    NSURL *curURL = nil;
    for (NSDictionary<NSURL *, UIImage *>*dict in manager.selectsThumbImages) {
        NSURL *url = [[dict allKeys] firstObject];
        if ([url isEqual:assetURL]) {
            curURL = url;
            break;
        }
        index++;
    }
    
    [self.asset getThumbImageWithCompletion:^(UIImage *image) {
        if ([assetURL isEqual:curURL]) {
            [manager.selectsThumbImages removeObjectAtIndex:index];
        } else {
            [manager.selectsThumbImages addObject:@{assetURL:image}];
        }
    }];
    
    [self.asset getOriginImageWithCompletion:^(UIImage *image) {
        if ([assetURL isEqual:curURL]) {
            [manager.selectsOriginalImage removeObjectAtIndex:index];
        } else {
            [manager.selectsOriginalImage addObject:@{assetURL:image}];
        }
    }];
    
    BOOL isSelected = [manager.selectsUrls containsObject:[self.asset assetURL]];
    self.tagButton.selected = isSelected;
    
    // refresh selectUrl count;
    [[NSNotificationCenter defaultCenter] postNotificationName:MLNotificationDidChangeSelectUrl object:nil];
}
@end
