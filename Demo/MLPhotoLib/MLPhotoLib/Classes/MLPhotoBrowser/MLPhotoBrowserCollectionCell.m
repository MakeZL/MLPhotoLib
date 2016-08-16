//
//  MLPhotoBrowserCollectionCell.m
//  MLPhotoLib
//
//  Created by leisuro on 16/8/16.
//  Copyright © 2016年 Free. All rights reserved.
//

#import "MLPhotoBrowserCollectionCell.h"
#import "MLPhoto.h"

@interface MLPhotoBrowserCollectionCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@end

@implementation MLPhotoBrowserCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setPhoto:(MLPhoto *)photo
{
    _photo = photo;
}


@end
