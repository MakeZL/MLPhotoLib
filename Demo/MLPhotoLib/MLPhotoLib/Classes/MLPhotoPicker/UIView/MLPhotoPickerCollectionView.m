//
//  MLPhotoPickerCollectionView.m
//  MLPhotoLib
//
//  Created by leisuro on 16/8/1.
//  Copyright © 2016年 Free. All rights reserved.
//

#import "MLPhotoPickerCollectionView.h"
#import "MLImagePickerCollectionViewCell.h"
#import "MLPhotoPickerManager.h"
#import "MLPhotoKitData.h"
#import "MLImagePickerHUD.h"
#import "MLPhotoPickerData.h"

// ----- PhotoBrowser -----
#import "MLPhotoBrowserViewController.h"

@interface MLPhotoPickerCollectionView () <
                                        UICollectionViewDelegate,
                                        UICollectionViewDataSource,
                                        UIImagePickerControllerDelegate,
                                        UINavigationControllerDelegate,
                                        MLPhotoBrowserViewControllerDelegate
                                        >
@property (nonatomic, strong) NSMutableArray *photos;
@end

@implementation MLPhotoPickerCollectionView

- (void)setAlbumAssets:(NSArray<MLPhotoAsset *>*)albumAssets{
    _albumAssets = albumAssets;
    
    _photos = [NSMutableArray arrayWithCapacity:albumAssets.count];
    for (NSInteger i = 0; i < albumAssets.count; i++) {
        MLPhoto *photo = [[MLPhoto alloc] init];
        [_photos addObject:photo];
    }
    [self.collectionView reloadData];
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        CGFloat cellWH = (self.frame.size.width-MLImagePickerCellMargin*MLShowRowCellCount) / MLShowRowCellCount;
        
        UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        collectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        collectionViewFlowLayout.minimumLineSpacing = MLImagePickerCellMargin;
        collectionViewFlowLayout.minimumInteritemSpacing = 0;
        collectionViewFlowLayout.itemSize = CGSizeMake(cellWH, cellWH);
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:collectionViewFlowLayout];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [self addSubview:_collectionView = collectionView];
        
        [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MLImagePickerCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([MLImagePickerCollectionViewCell class])];
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"MLCamreaCell"];
        [collectionView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureScrollPhoto:)]];
    }
    return _collectionView;
}

#pragma mark - <UICollectionViewDataSource/UICollectionViewDelegate>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    BOOL supportTakeCamera = [MLPhotoPickerManager manager].isSupportTakeCamera;
    return supportTakeCamera?self.albumAssets.count + 1 : self.albumAssets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL supportTakeCamera = [MLPhotoPickerManager manager].isSupportTakeCamera;
    if (supportTakeCamera && indexPath.row == 0) {
        // Camera
        return [self configureCameraCellIndexPath:indexPath];
    }
    
    MLImagePickerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MLImagePickerCollectionViewCell class]) forIndexPath:indexPath];
    NSInteger cameraOffset = supportTakeCamera?1:0;
    if (self.albumAssets.count > indexPath.item-cameraOffset) {
        cell.asset = [self.albumAssets objectAtIndex:indexPath.item-cameraOffset];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([MLPhotoPickerManager manager].isSupportTakeCamera && indexPath.row == 0
        ) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            [self openCamera];
        }
        return;
    }
    
    [self openPhotoBrowserAtIndexPath:indexPath];
}

- (UICollectionViewCell *)configureCameraCellIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"MLCamreaCell" forIndexPath:indexPath];
    if ([cell.contentView viewWithTag:1000001] == nil) {
        [cell.contentView addSubview:[self configureCameraCellImageView:cell]];
    }
    return cell;
}

- (UIImageView *)configureCameraCellImageView:(UICollectionViewCell *)cell
{
    return ({
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        imageView.center = cell.center;
        imageView.tag = 1000001;
        imageView.image = [UIImage imageNamed:@"MLImagePickerController.bundle/zl_camera"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView;
    });
}

#pragma mark - <UIImagePickerControllerDelegate>
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *editedImage = info[@"UIImagePickerControllerEditedImage"];
    if (gtiOS8) {
        [MLPhotoKitData addAssetAlbumForName:[self.group groupName] image:editedImage completionHandler:^(BOOL success, NSError * _Nullable error) {
            
        }];
    } else {
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library writeImageToSavedPhotosAlbum:[editedImage CGImage] orientation:(ALAssetOrientation)editedImage.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error) {
        }];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - LongGesturePhoto
- (void)longPressGestureScrollPhoto:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:self.collectionView];
    NSArray *cells = [self.collectionView visibleCells];
    
    for (NSInteger i = 0; i < cells.count; i++) {
        MLImagePickerCollectionViewCell *cell = cells[i];
        
        if (((CGRectGetMaxY(cell.frame) > point.y && CGRectGetMaxY(cell.frame) - point.y <= cell.frame.size.height) == YES &&
            (CGRectGetMaxX(cell.frame) > point.x && CGRectGetMaxX(cell.frame) - point.x <= cell.frame.size.width)
            ) == YES) {
            if ([cell respondsToSelector:@selector(activeDidSelecteAsset)]) {
                [cell activeDidSelecteAsset];
            }
        }
    }
}

#pragma makr - <MLPhotoBrowserViewControllerDelegate>
- (void)photoBrowser:(MLPhotoBrowserViewController *)photoBrowser didScrollToPage:(NSInteger)page
{
    NSInteger index = page;
    MLPhotoAsset *asset = self.albumAssets[index];
    MLPhoto *photo = self.photos[index];
    photo.assetUrl = asset.assetURL;
    if (photo.thumbImage == nil) {
        [asset getThumbImageWithCompletion:^(UIImage *image) {
            photo.thumbImage = image;
            [photoBrowser reloadDataForIndex:page];
        }];
    }
    if (photo.origianlImage == nil) {
        [asset getOriginImageWithCompletion:^(UIImage *image) {
            photo.origianlImage = image;
            [photoBrowser reloadDataForIndex:page];
        }];
    }
}

#pragma mark - OPEN
- (void)openCamera
{
    if ([MLPhotoPickerManager manager].isBeyondMaxCount) {
        [MLImagePickerHUD showMessage:MLMaxCountMessage];
        return;
    }
    UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
    UIImagePickerControllerSourceType sourcheType = UIImagePickerControllerSourceTypeCamera;
    imagePickerVC.sourceType = sourcheType;
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    [[MLPhotoPickerManager manager].navigationController presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)openPhotoBrowserAtIndexPath:(NSIndexPath *)indexPath
{
    MLPhotoBrowserViewController *photoBrowserVC = [[MLPhotoBrowserViewController alloc] init];
    NSInteger index = ([MLPhotoPickerManager manager].isSupportTakeCamera) ? indexPath.item - 1: indexPath.item;
    MLPhotoAsset *asset = self.albumAssets[index];
    MLPhoto *photo = self.photos[index];
    photo.assetUrl = asset.assetURL;
    if (photo.thumbImage == nil) {
        [asset getThumbImageWithCompletion:^(UIImage *image) {
            photo.thumbImage = image;
            [photoBrowserVC reloadDataForIndex:index];
        }];
    }
    if (photo.origianlImage == nil) {
        [asset getOriginImageWithCompletion:^(UIImage *image) {
            photo.origianlImage = image;
            [photoBrowserVC reloadDataForIndex:index];
        }];
    }
    photoBrowserVC.delegate = self;
    photoBrowserVC.curPage = index;
    photoBrowserVC.editMode = YES;
    photoBrowserVC.photos = _photos;
    [photoBrowserVC displayForVC:[[[MLPhotoPickerManager manager].navigationController childViewControllers] firstObject]];
}
@end
