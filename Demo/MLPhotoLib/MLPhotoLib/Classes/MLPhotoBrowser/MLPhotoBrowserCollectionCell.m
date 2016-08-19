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
    
    [self addGestureRecognizer];
}

- (void)addGestureRecognizer
{
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContainerView:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContainerView:)];
    doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    
    [self.containerView addGestureRecognizer:singleTapGestureRecognizer];
    [self.containerView addGestureRecognizer:doubleTapGestureRecognizer];
    [singleTapGestureRecognizer requireGestureRecognizerToFail:doubleTapGestureRecognizer];
    
    self.scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
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
    if (gestureRecognizer.numberOfTapsRequired == 2) {
        
        return;
    }
    // Single Recognizer.
    if (self.didTapBlock) {
        self.didTapBlock();
    }
}


@end
