//
//  BrowserViewController.m
//  MLPhotoLib
//
//  Created by leisuro on 16/8/29.
//  Copyright © 2016年 Free. All rights reserved.
//

#import "BrowserViewController.h"
#import "MLPhotoBrowserViewController.h"
#import "MLPhoto.h"

#import "UIImageView+WebCache.h"

@interface BrowserViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

// ----- PhotoBrowser -----
@property (nonatomic, strong) NSMutableArray<MLPhoto *>*photos;

@end

@implementation BrowserViewController

- (NSMutableArray<MLPhoto *> *)photos
{
    if (!_photos) {
        _photos = @[].mutableCopy;
    }
    return _photos;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"#MLPhotoBrowser#";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // setup
    NSArray *imageUrls = @[
                           @"http://image.wufazhuce.com/FnST4-BMyWkb_ljnOe5783ZF0R02",
                           @"http://image.wufazhuce.com/Fhyd_Ag795olp_HLmW4hBtObhfqT",
                           @"http://image.wufazhuce.com/FgWL_yCKSyJff5G-oQ6Pybd-PeCO",
                           @"http://image.wufazhuce.com/FgNOSsUivWAwgETuOW0AdKnjCdLz",
                           @"http://image.wufazhuce.com/FoyEIZ1xDWab3JSTVGkXCw8Qp3i9",
                           @"http://image.wufazhuce.com/FobPKbeYWmQ-L0Od2Bo2bcbTdJf8"
                           ];
    
    for (NSString *imageUrl in imageUrls)
    {
        MLPhoto *photo = [[MLPhoto alloc] init];
        photo.thumbImageUrl = [NSURL URLWithString:imageUrl];
        photo.originalImageUrl = [NSURL URLWithString:imageUrl];
        [self.photos addObject:photo];
    }
    // reload
    [self.collectionView reloadData];
}

#pragma mark - Demo
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    MLPhoto *photo = self.photos[indexPath.item];
    
    UIImageView *imageV = [[UIImageView alloc] init];
    imageV.contentMode = UIViewContentModeScaleAspectFill;
    imageV.frame = cell.bounds;
    [imageV sd_setImageWithURL:photo.thumbImageUrl];
    [cell.contentView addSubview:imageV];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
#pragma mark - MLPhotoBrowserViewController
    MLPhotoBrowserViewController *browserVC = [[MLPhotoBrowserViewController alloc] init];
    browserVC.curPage = indexPath.item;
    browserVC.photos = self.photos;
    [browserVC displayForVC:self];
}

@end
