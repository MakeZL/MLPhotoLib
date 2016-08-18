//
//  MLPhotoBrowserCollectionCell.m
//  MLPhotoLib
//
//  Created by leisuro on 16/8/16.
//  Copyright © 2016年 Free. All rights reserved.
//

#import "MLPhotoBrowserCollectionCell.h"
#import "MLPhotoRect.h"
#import "MLPhoto.h"

@interface MLPhotoBrowserCollectionCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewWidthLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeightLayoutConstraint;
@end

@implementation MLPhotoBrowserCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.containerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContainerView:)]];
}

- (void)setPhoto:(MLPhoto *)photo
{
    _photo = photo;
    
    UIImage *image = nil;
    if (photo.origianlImage) {
        image = photo.origianlImage;
    } else if (photo.thumbImage && !photo.origianlImage) {
        image = photo.thumbImage;
    }
    
    [self.imageView setImage:image];
    CGSize imageSize = [MLPhotoRect setMaxMinZoomScalesForCurrentBoundWithImage:image].size;
    self.imageViewWidthLayoutConstraint.constant = imageSize.width;
    self.imageViewHeightLayoutConstraint.constant = imageSize.height;
}

- (void)tapContainerView:(UITapGestureRecognizer *)gestureRecognizer
{
    if (self.didTapBlock) {
        self.didTapBlock();
    }
}


@end
