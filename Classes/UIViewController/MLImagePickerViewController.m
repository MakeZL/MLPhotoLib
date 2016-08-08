//
//  MLImagePickerViewController.m
//  MLPhotoLib
//
//  Created by leisuro on 16/8/1.
//  Copyright © 2016年 Free. All rights reserved.
//

#import "MLImagePickerViewController.h"
#import "MLImagePickerViewController+MenuTableViewDataSource.h"
#import "MLNavigationViewController.h"
#import "MLPhotoPickerCollectionView.h"
#import "MLPhotoPickerCollectionView.h"
#import "MLImagePickerMenuTableViewCell.h"
#import "MLPhotoPickerData.h"
#import "MLPhotoKitData.h"
#import "MLPhotoPickerAssetsManager.h"
#import "MLPhotoAsset.h"
#import <AssetsLibrary/AssetsLibrary.h>

//#define MLImagePickerUIScreenScale ([[UIScreen mainScreen] scale])
//#define UIScreenWidth ([UIScreen mainScreen].bounds.size.width)
//#define MLImagePickerCellWidth ((UIScreenWidth - MLImagePickerCellMargin * (MLImagePickerCellRowCount + 1)) / MLImagePickerCellRowCount)

static NSUInteger kDefaultMaxCount = 9;
static NSString *PHImageFileURLKey = @"PHImageFileURLKey";
static CGFloat MLImagePickerCellMargin = 2;
static CGFloat MLImagePickerCellRowCount = 4;
static NSInteger MLImagePickerMaxCount = 9;


@interface MLImagePickerViewController ()
@property (nonatomic, weak) UITableView *groupTableView;
@property (nonatomic, strong) MLPhotoPickerCollectionView *contentCollectionView;
@property (nonatomic, strong) MLPhotoPickerAssetsManager *imageManager;
@property (nonatomic, strong) PHFetchResult *fetchResult;
@end

@implementation MLImagePickerViewController

- (void)displayForVC:(__weak UIViewController *)viewController completionHandle:(void(^)(BOOL success, NSError *error))completionHandle
{
    if (gtiOS8)
    {
        if (![MLPhotoKitData judgeIsHavePhotoAblumAuthority])
        {
            NSError *error = [NSError errorWithDomain:@"com.github.makezl" code:-11 userInfo:@{@"errorMsg":@"用户没有开启选择相片的权限!"}];
            !completionHandle?:completionHandle(NO, error);
            return;
        }
    } else {
        if (![MLPhotoPickerData judgeIsHavePhotoAblumAuthority])
        {
            NSError *error = [NSError errorWithDomain:@"com.github.makezl" code:-11 userInfo:@{@"errorMsg":@"用户没有开启选择相片的权限!"}];
            !completionHandle?:completionHandle(NO, error);
            return;
        }
    }
    [viewController presentViewController:[[MLNavigationViewController alloc] initWithRootViewController:self] animated:YES completion:nil];
}

+ (instancetype)new
{
    return [[self alloc] init];
}

+ (instancetype)pickerViewController
{
    return [[self alloc] init];
}

- (instancetype)init
{
    if (self = [super init]) {
        self.maxCount = kDefaultMaxCount;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (void)setup
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setupSubviews];
    [self setupPickerData];
}

- (void)setupSubviews
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.titleView = [self setupTitleView];
    
    [self.view addSubview:_contentCollectionView = [[MLPhotoPickerCollectionView alloc] initWithFrame:(CGRect){CGPointMake(0, 30), CGSizeMake(self.view.frame.size.width, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height)}]];
}

- (void)setupPickerData
{
    if (gtiOS8) {
        
        self.imageManager = [[MLPhotoPickerAssetsManager alloc] init];
        self.fetchResult = [self.imageManager fetchResult];

        // PhotoKit
//        CGSize size = CGSizeMake(MLImagePickerCellWidth * MLImagePickerUIScreenScale, MLImagePickerCellWidth * MLImagePickerUIScreenScale);
        
        PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
        requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        requestOptions.networkAccessAllowed = YES;
        
        NSMutableArray *assets = @[].mutableCopy;
        for (NSInteger i = 0; i < self.fetchResult.count; i++){
            MLPhotoAsset *asset = [[MLPhotoAsset alloc] init];
            asset.asset = self.fetchResult[i];
            [assets addObject:asset];
//            PHAsset *asset = self.fetchResult[i];
//            self.photoIdentifiers.append(asset.localIdentifier)
            
//            if self.selectIndentifiers.contains(asset.localIdentifier) == true {
//                self.imageManager.requestImageForAsset(asset, targetSize: AssetGridThumbnailSize, contentMode: .AspectFill, options: nil) { (let image, let info:[NSObject : AnyObject]?) -> Void in
//                    if info![PHImageFileURLKey] != nil {
//                        self.phImageFileUrls.append(info![PHImageFileURLKey] as! NSURL)
//                    }
//                    self.selectImages.append(image!)
//                }
//            }
        }
        
        self.contentCollectionView.albumAssets = assets;
//        self.collectionView?.reloadData()
//        self.collectionView?.layoutIfNeeded()
//        if self.cancleLongGestureScrollSelectedPicker == false {
//            self.collectionView?.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: "longPressGestureScrollPhoto:"))
//        }
        
    } else {
        WeakSelf
        MLPhotoPickerData *pickerData = [MLPhotoPickerData pickerData];
        [pickerData getAllGroup:^(NSArray *groups) {
            weakSelf.groups = groups;
            [weakSelf groupsWithAsset:groups];
        }];
    }
}

- (void)groupsWithAsset:(NSArray *)groups
{
    for (MLPhotoPickerGroup *group in groups) {
        if ([group.type integerValue] == 16) {
            // 相机胶卷
            [self reloadCollectionViewWithGroup:group];
            break;
        }
    }
}

- (void)reloadCollectionViewWithGroup:(MLPhotoPickerGroup *)group
{
    WeakSelf
    [[MLPhotoPickerData pickerData] getGroupPhotosWithGroup:group finished:^(NSArray *assets) {
        NSMutableArray *tmpArrayM = [NSMutableArray arrayWithCapacity:assets.count];
        for (ALAsset *asset in assets) {
            __block MLPhotoAsset *mlAsset = [[MLPhotoAsset alloc] init];
            mlAsset.asset = asset;
            [tmpArrayM addObject:mlAsset];
        }
        weakSelf.contentCollectionView.albumAssets = tmpArrayM;
    }];
}

- (UIButton *)setupTitleView
{
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    titleButton.titleLabel.font = [UIFont systemFontOfSize:14];
    titleButton.adjustsImageWhenHighlighted = NO;
    [titleButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [titleButton setTitle:@"相机胶卷" forState:UIControlStateNormal];
    [titleButton addTarget:self action:@selector(tappendTitleView) forControlEvents:UIControlEventTouchUpInside];
    return titleButton;
}

- (void)tappendTitleView
{
    [UIView animateWithDuration:0.25 animations:^{
        self.groupTableView.alpha = (self.groupTableView.alpha == 1.0) ? 0.0 : 1.0;
    }];
}

- (UITableView *)groupTableView
{
    if (!_groupTableView) {
        
        if (gtiOS8) {
            [self setupGroup];
        }
        
        UITableView *groupTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 250) style:UITableViewStylePlain];
        groupTableView.alpha = 0.0;
        groupTableView.backgroundColor = [UIColor whiteColor];
        groupTableView.dataSource = self;
        groupTableView.delegate = self;
        groupTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [groupTableView registerNib:[UINib nibWithNibName:NSStringFromClass([MLImagePickerMenuTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MLImagePickerMenuTableViewCell class])];
        [self.view addSubview:_groupTableView = groupTableView];
    }
    return _groupTableView;
}

- (void)setupGroup
{
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    [options setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]]];
    PHFetchResult *allPhotos = [PHAsset fetchAssetsWithOptions:options];
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    PHFetchResult *userCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    
    NSMutableArray *groups = @[].mutableCopy;
    NSArray *collections = @[allPhotos, smartAlbums, userCollections];
    for (PHFetchResult *result in collections) {
        for (PHAssetCollection *collection in result) {
            if ([collection isKindOfClass:[PHAssetCollection class]]) {
                MLPhotoPickerGroup *group = [[MLPhotoPickerGroup alloc] init];
                group.collection = collection;
                [groups addObject:group];
            }
        }
    }
    self.groups = groups;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
