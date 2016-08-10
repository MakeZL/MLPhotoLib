//
//  MLImagePickerMenuTableViewCell.h
//  MLPhotoLib
//
//  Created by leisuro on 16/8/2.
//  Copyright © 2016年 Free. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MLPhotoPickerGroup;
@interface MLImagePickerMenuTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *assetCountLbl;
@property (weak, nonatomic) IBOutlet UIImageView *tagImageView;

@property (nonatomic, strong) MLPhotoPickerGroup *group;

@end
