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
- (void)setGroup:(MLPhotoPickerGroup *)group
{
    _group = group;
    
    self.titleLbl.text = [group groupName];
    self.assetCountLbl.text = [NSString stringWithFormat:@"( %ld )",[group assetsCount]];
}
@end
