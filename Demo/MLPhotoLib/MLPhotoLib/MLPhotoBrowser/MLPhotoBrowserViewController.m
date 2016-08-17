//
//  MLPhotoBrowserViewController.m
//  MLPhotoLib
//
//  Created by leisuro on 16/8/10.
//  Copyright © 2016年 Free. All rights reserved.
//

#import "MLPhotoBrowserViewController.h"
#import "MLPhotoBrowserCollectionCell.h"
#import "ZLPhotoRect.h"

@interface MLPhotoBrowserViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation MLPhotoBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.itemSize = self.view.frame.size;
    flowLayout.minimumInteritemSpacing = 0;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MLPhotoBrowserCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([MLPhotoBrowserCollectionCell class])];
    [self.view addSubview:_collectionView = collectionView];
}

- (void)displayForVC:(__weak UIViewController *)viewController
{
    if (self.photos.count == 0 || self.curPage > self.photos.count) {
        NSLog(@"photos is empty");
        return;
    }
    
    MLPhoto *curPhoto = [self.photos objectAtIndex:self.curPage];
    
    CGRect tempF = [curPhoto.photoImageView.superview convertRect:curPhoto.photoImageView.frame toView:[self getParsentViewController:curPhoto.photoImageView]];
    
    UIWindow *window = [self getCurWindowWithView:viewController.view];
    UIView *imageContainerView = [[UIView alloc] init];
    imageContainerView.backgroundColor = [UIColor clearColor];
    imageContainerView.frame = tempF;
    [window addSubview:imageContainerView];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.image = curPhoto.photoImageView.image;
    imageView.frame = imageContainerView.bounds;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [imageContainerView addSubview:imageView];
    
    CGRect imageFrame = [ZLPhotoRect setMaxMinZoomScalesForCurrentBoundWithImageView:curPhoto.photoImageView];
    [UIView animateWithDuration:1.0 animations:^{
        imageContainerView.frame = imageFrame;
    } completion:^(BOOL finished) {
        imageContainerView.hidden = YES;
        [viewController presentViewController:self animated:NO completion:nil];
    }];
}

- (void)dismiss
{
    
}

- (UIWindow *)getCurWindowWithView:(UIResponder *)view
{
    if (view == nil || [view isKindOfClass:[UIWindow class]]) {
        return (UIWindow *)view;
    }
    return [self getCurWindowWithView:[view nextResponder]];
}

- (UIView *)getParsentViewController:(UIView *)view
{
    if ([[view nextResponder] isKindOfClass:[UIViewController class]] || view == nil) {
        return (UIView *)[view nextResponder];
    }
    return [self getParsentViewController:view.superview];
}

#pragma mark - <UICollectionViewDataSource/UICollectionViewDelegate>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photos.count;
}

- (MLPhotoBrowserCollectionCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MLPhotoBrowserCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MLPhotoBrowserCollectionCell class]) forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor blueColor];
//    cell.photo = [self.photos objectAtIndex:indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismiss];
}

@end
