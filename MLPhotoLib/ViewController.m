//
//  ViewController.m
//  MLPhotoLib
//
//  Created by leisuro on 16/8/1.
//  Copyright © 2016年 Free. All rights reserved.
//

#import "ViewController.h"
#import "MLImagePickerViewController.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *selectUrls;
@property (nonatomic, strong) NSArray *selectThumbImages;
@property (nonatomic, strong) NSArray *selectOriginalImages;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

/// IBAction
- (IBAction)actionOpenAlbum
{
    MLImagePickerViewController *pickerVC = [MLImagePickerViewController pickerViewController];
    // Limit Count
    pickerVC.maxCount = 3;
    // Recoder
    pickerVC.selectAssetsURL = self.selectUrls;
    WeakSelf
    [pickerVC displayForVC:self
          completionHandle:^(BOOL success,
                             NSArray<NSURL *> *assetUrls,
                             NSArray<UIImage *> *thumbImages,
                             NSArray<UIImage *> *originalImages,
                             NSError *error) {
          if (success) {
              NSLog(@" Success! ----- ");
              
              weakSelf.selectUrls = assetUrls;
              weakSelf.selectThumbImages = thumbImages;
              weakSelf.selectOriginalImages = originalImages;
              [weakSelf.collectionView reloadData];
              
              NSLog(@" assetUrls -- :%@", assetUrls);
              NSLog(@" thumbImages -- :%@", thumbImages);
              NSLog(@" originalImages -- :%@", originalImages);
          }
    }];
}

- (IBAction)actionQuickPrev
{
    
}

#pragma mark - Demo
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.selectThumbImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UIImageView *imageV = [[UIImageView alloc] init];
    imageV.contentMode = UIViewContentModeScaleAspectFill;
    imageV.frame = cell.bounds;
    imageV.image = self.selectThumbImages[indexPath.row];
    [cell.contentView addSubview:imageV];
    
    return cell;
}

@end
