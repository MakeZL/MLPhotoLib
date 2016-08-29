//
//  MLPhotoBrowserCollectionCell.m
//  MLPhotoLib
//
//  Created by leisuro on 16/8/16.
//  Copyright © 2016年 Free. All rights reserved.
//

#import "MLPhotoBrowserCollectionCell.h"
#import "MLPhotoPickerBrowserPhotoScrollView.h"
#import "MLPhotoPickerManager.h"
#import "MLImagePickerHUD.h"
#import "MLPhotoRect.h"
#import "MLPhoto.h"

@interface MLPhotoBrowserCollectionCell () <MLPhotoPickerPhotoScrollViewDelegate>
@property (weak, nonatomic) IBOutlet MLPhotoPickerBrowserPhotoScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@end

@implementation MLPhotoBrowserCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.rightButton setImage:[UIImage imageNamed:@"MLImagePickerController.bundle/zl_icon_image_no"] forState:UIControlStateNormal];
    [self.rightButton setImage:[UIImage imageNamed:@"MLImagePickerController.bundle/zl_icon_image_yes"] forState:UIControlStateSelected];
    
    self.scrollView.photoScrollViewDelegate = self;
}

- (void)setPhoto:(MLPhoto *)photo
{
    _photo = photo;

    self.scrollView.photo = photo;
    
    [self updateRightButtonStatus];
}

- (void)setEditMode:(BOOL)editMode
{
    _editMode = editMode;
    
    [self.rightButton setHidden:!editMode];
}

- (void)updateRightButtonStatus
{
    [self.rightButton setSelected:[self whetherRecordAsset:self.photo.assetUrl]];
}

- (BOOL)whetherRecordAsset:(NSURL *)assetUrl
{
    return [[MLPhotoPickerManager manager].selectsUrls containsObject:assetUrl];
}

- (IBAction)rightBtnClick
{
    if (self.photo.assetUrl) {
        if ([[MLPhotoPickerManager manager].selectsUrls containsObject:self.photo.assetUrl]) {
            // Remove
            [[MLPhotoPickerManager manager].selectsUrls removeObject:self.photo.assetUrl];
            [[MLPhotoPickerManager manager] removeThumbAssetUrl:self.photo.assetUrl];
            [[MLPhotoPickerManager manager] removeOriginalAssetUrl:self.photo.assetUrl];
            
        } else {
            // Insert
            if ([MLPhotoPickerManager manager].isBeyondMaxCount)
            {
                [MLImagePickerHUD showMessage:MLMaxCountMessage];
                return;
            }
            [[MLPhotoPickerManager manager].selectsUrls addObject:self.photo.assetUrl];
            [[MLPhotoPickerManager manager].selectsThumbImages addObject:@{self.photo.assetUrl:self.photo.thumbImage}];
            [[MLPhotoPickerManager manager].selectsOriginalImage addObject:@{self.photo.assetUrl:self.photo.origianlImage}];
        }
        [self updateRightButtonStatus];
        [[NSNotificationCenter defaultCenter] postNotificationName:MLNotificationPhotoBrowserDidChangeSelectUrl object:nil];
    }
}

- (void) pickerPhotoScrollViewDidSingleClick:(MLPhotoPickerBrowserPhotoScrollView *)photoScrollView
{
    // Single Recognizer.
    if (self.didTapBlock) {
        self.didTapBlock();
    }
}

@end
