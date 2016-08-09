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

@interface MLPhotoPickerCollectionView ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, weak) UICollectionView *collectionView;
@end

@implementation MLPhotoPickerCollectionView

- (void)setAlbumAssets:(NSArray *)albumAssets{
    _albumAssets = albumAssets;
    
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
    }
    return _collectionView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.albumAssets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MLImagePickerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MLImagePickerCollectionViewCell class]) forIndexPath:indexPath];
    if (self.albumAssets.count > indexPath.item) {
        cell.asset = [self.albumAssets objectAtIndex:indexPath.item];   
    }
    return cell;
}
@end
