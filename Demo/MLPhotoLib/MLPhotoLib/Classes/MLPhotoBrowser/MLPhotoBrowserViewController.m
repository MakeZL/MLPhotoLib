//
//  MLPhotoBrowserViewController.m
//  MLPhotoLib
//
//  Created by leisuro on 16/8/10.
//  Copyright © 2016年 Free. All rights reserved.
//

#import "MLPhotoBrowserViewController.h"
#import "MLPhotoBrowserCollectionCell.h"
#import "MLNavigationViewController.h"
#import "MLPhotoPickerManager.h"
#import "MLImagePickerHUD.h"
#import "MLPhotoRect.h"

@interface MLPhotoBrowserViewController () <UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *titleButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, assign) BOOL statusBarHiddenFlag;
@end

@implementation MLPhotoBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self addNavigationBarTitleView];
    [self addNavigationBarRightView];
    [self updateTitleView];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    collectionView.pagingEnabled = YES;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MLPhotoBrowserCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([MLPhotoBrowserCollectionCell class])];
    [self.view addSubview:_collectionView = collectionView];
    
    [collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.curPage inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

- (void)addNavigationBarTitleView
{
    ({
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [titleButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [titleButton setFrame:CGRectMake((self.view.frame.size.width - 150)*0.5, 0, 150, 44)];
        [titleButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        titleButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.navigationController.navigationBar addSubview:titleButton];
        self.titleButton = titleButton;
    });
}

- (void)addNavigationBarRightView
{
    if (!self.editMode) {
        return;
    }
    ({
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setImage:[UIImage imageNamed:@"MLImagePickerController.bundle/zl_icon_image_no"] forState:UIControlStateNormal];
        [rightButton setImage:[UIImage imageNamed:@"MLImagePickerController.bundle/zl_icon_image_yes"] forState:UIControlStateSelected];
        [rightButton setFrame:CGRectMake(self.view.frame.size.width - 37, 7, 30, 30)];
        [rightButton addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationController.navigationBar addSubview:rightButton];
        self.rightButton = rightButton;
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.rightButton removeFromSuperview];
    [self.titleButton removeFromSuperview];
}

- (void)setStatusBarHidden:(BOOL)hidden animated:(BOOL)animated
{
    self.statusBarHiddenFlag = hidden;
    if (gtiOS8) {
        [self prefersStatusBarHidden];
        [UIView animateWithDuration:animated?0.3:0.0 animations:^{
            [self setNeedsStatusBarAppearanceUpdate];
        }];
    } else {
        [[UIApplication sharedApplication] setStatusBarHidden:self.statusBarHiddenFlag withAnimation:UIStatusBarAnimationFade];
    }
}

- (void)setStatusBarHidden:(BOOL)hidden
{
    [self setStatusBarHidden:hidden animated:YES];
}

- (BOOL)prefersStatusBarHidden
{
    return self.statusBarHiddenFlag;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)rightBtnClick
{
    MLPhoto *photo = [self.photos objectAtIndex:self.curPage];
    if (photo.assetUrl) {
        if ([[MLPhotoPickerManager manager].selectsUrls containsObject:photo.assetUrl]) {
            // Remove
            [[MLPhotoPickerManager manager].selectsUrls removeObject:photo.assetUrl];
        } else {
            // Insert
            if ([MLPhotoPickerManager manager].isBeyondMaxCount)
            {
                [MLImagePickerHUD showMessage:MLMaxCountMessage];
                return;
            }
            [[MLPhotoPickerManager manager].selectsUrls addObject:photo.assetUrl];
        }
        [self updateRightButtonStatus];
        [[NSNotificationCenter defaultCenter] postNotificationName:MLNotificationPhotoBrowserDidChangeSelectUrl object:nil];
    }
}

- (void)displayForVC:(__weak UIViewController *)viewController
{
    if (self.photos.count == 0 || self.curPage > self.photos.count) {
        NSLog(@"photos is empty");
        return;
    }
    
    if (viewController.navigationController == nil) {
        MLNavigationViewController *navigationVC = [[MLNavigationViewController alloc] initWithRootViewController:self];
        [viewController presentViewController:navigationVC animated:YES completion:nil];
    } else {
        [viewController.navigationController pushViewController:self animated:YES];
    }
    
//    CGRect tempF = [curPhoto.photoImageView.superview convertRect:curPhoto.photoImageView.frame toView:[self getParsentViewController:curPhoto.photoImageView]];
//    
//    UIWindow *window = [self getCurWindowWithView:viewController.view];
//    UIView *imageContainerView = [[UIView alloc] init];
//    imageContainerView.backgroundColor = [UIColor clearColor];
//    imageContainerView.frame = tempF;
//    [window addSubview:_imageContainerView = imageContainerView];
//    
//    UIImageView *imageView = [[UIImageView alloc] init];
//    imageView.contentMode = UIViewContentModeScaleAspectFill;
//    imageView.image = curPhoto.photoImageView.image;
//    imageView.frame = imageContainerView.bounds;
//    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    [imageContainerView addSubview:imageView];
//    
//    CGRect imageFrame = [ZLPhotoRect setMaxMinZoomScalesForCurrentBoundWithImageView:curPhoto.photoImageView];
//    [UIView animateWithDuration:1.0 animations:^{
//        imageContainerView.frame = imageFrame;
//    } completion:^(BOOL finished) {
//        imageContainerView.hidden = YES;
//        [viewController presentViewController:self animated:NO completion:nil];
//    }];
}

- (void)dismiss
{
//    self.imageContainerView.hidden = NO;
//    [self.collectionView removeFromSuperview];
//    [self.view removeFromSuperview];
    
//    CGRect imageFrame = [ZLPhotoRect setMaxMinZoomScalesForCurrentBoundWithImageView:curPhoto.photoImageView];
    
//    if (self.curPage < self.photos.count) {
//        MLPhoto *photo = [self.photos objectAtIndex:self.curPage];
//        [UIView animateWithDuration:1.0 animations:^{
//            self.imageContainerView.frame = photo.photoImageView.frame;
//        } completion:^(BOOL finished) {
//            [self.imageContainerView removeFromSuperview];
//            [self dismissViewControllerAnimated:NO completion:nil];
//        }];
//    }
}

//- (UIWindow *)getCurWindowWithView:(UIResponder *)view
//{
//    if (view == nil || [view isKindOfClass:[UIWindow class]]) {
//        return (UIWindow *)view;
//    }
//    return [self getCurWindowWithView:[view nextResponder]];
//}
//
//- (UIView *)getParsentViewController:(UIView *)view
//{
//    if ([[view nextResponder] isKindOfClass:[UIViewController class]] || view == nil) {
//        return (UIView *)[view nextResponder];
//    }
//    return [self getParsentViewController:view.superview];
//}

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
    cell.photo = [self.photos objectAtIndex:indexPath.item];
    __weak typeof(self)weakSelf = self;
    cell.didTapBlock = ^{
        [weakSelf setStatusBarHidden:!weakSelf.navigationController.navigationBar.isHidden];
        [weakSelf.navigationController setNavigationBarHidden:!weakSelf.navigationController.navigationBar.isHidden animated:YES];
    };
    return cell;
}

- (BOOL)whetherRecordAsset:(NSURL *)assetUrl
{
    return [[MLPhotoPickerManager manager].selectsUrls containsObject:assetUrl];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [UIScreen mainScreen].bounds.size;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.curPage = scrollView.contentOffset.x / scrollView.frame.size.width + 0.5;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updateTitleView];
    
    if ([self.delegate respondsToSelector:@selector(photoBrowser:didScrollToPage:)]) {
        [self.delegate photoBrowser:self didScrollToPage:self.curPage];
    }
}

- (void)updateTitleView
{
    NSString *title = [NSString stringWithFormat:@"%@/%@",@(self.curPage+1),@(self.photos.count)];
    [self.titleButton setTitle:title forState:UIControlStateNormal];
    [self updateRightButtonStatus];
}

- (void)updateRightButtonStatus
{
    MLPhoto *photo = [self.photos objectAtIndex:self.curPage];
    [self.rightButton setSelected:[self whetherRecordAsset:photo.assetUrl]];
}

- (void)reloadData
{
    [self.collectionView reloadData];
}

- (void)reloadDataForIndex:(NSInteger)index
{
    [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]];
}
@end
