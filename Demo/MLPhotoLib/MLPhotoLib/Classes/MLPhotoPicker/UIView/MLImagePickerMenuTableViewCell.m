//
//  MLImagePickerMenuTableViewCell.m
//  MLPhotoLib
//
//  Created by leisuro on 16/8/2.
//  Copyright © 2016年 Free. All rights reserved.
//

#import "MLImagePickerMenuTableViewCell.h"
#import "MLPhotoPickerData.h"
#import "MLPhotoPickerManager.h"
#import <Photos/Photos.h>

@implementation MLImagePickerMenuTableViewCell

- (void)awakeFromNib
{
    [self.tagImageView setImage:[UIImage imageNamed:@"MLImagePickerController.bundle/zl_star.png"]];
}

- (void)setGroup:(MLPhotoPickerGroup *)group
{
    _group = group;
    
    self.titleLbl.text = [group groupName];
    self.assetCountLbl.text = [NSString stringWithFormat:@"( %ld )",(long)[group assetsCount]];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:NO];
    
    self.tagImageView.hidden = !selected;
}
@end
