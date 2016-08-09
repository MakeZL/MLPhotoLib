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
#import "MLPhotoPickerManager.h"
#import <AssetsLibrary/AssetsLibrary.h>

//#define MLImagePickerUIScreenScale ([[UIScreen mainScreen] scale])
//#define UIScreenWidth ([UIScreen mainScreen].bounds.size.width)
//#define MLImagePickerCellWidth ((UIScreenWidth - MLImagePickerCellMargin * (MLImagePickerCellRowCount + 1)) / MLImagePickerCellRowCount)

static NSUInteger kDefaultMaxCount = 9;
static NSString *PHImageFileURLKey = @"PHImageFileURLKey";
//static CGFloat MLImagePickerCellMargin = 2;
//static CGFloat MLImagePickerCellRowCount = 4;
//static NSInteger MLImagePickerMaxCount = 9;

typedef void(^completionHandle)(BOOL success, NSArray *assets, NSError *error);

@interface MLImagePickerViewController ()
@property (nonatomic, weak) UITableView *groupTableView;
@property (nonatomic, strong) MLPhotoPickerCollectionView *contentCollectionView;
@property (nonatomic, strong) MLPhotoPickerAssetsManager *imageManager;
@property (nonatomic, strong) MLPhotoPickerManager *pickerManager;
@property (nonatomic, strong) PHFetchResult *fetchResult;

@property (nonatomic, copy) completionHandle completion;
@end

@implementation MLImagePickerViewController

- (void)displayForVC:(__weak UIViewController *)viewController completionHandle:(void (^)(BOOL, NSArray *, NSError *))completionHandle
{
    if (gtiOS8)
    {
        if (![MLPhotoKitData judgeIsHavePhotoAblumAuthority])
        {
            NSError *error = [NSError errorWithDomain:@"com.github.makezl" code:-11 userInfo:@{@"errorMsg":@"用户没有开启选择相片的权限!"}];
            !completionHandle?:completionHandle(NO, nil, error);
            return;
        }
    } else {
        if (![MLPhotoPickerData judgeIsHavePhotoAblumAuthority])
        {
            NSError *error = [NSError errorWithDomain:@"com.github.makezl" code:-11 userInfo:@{@"errorMsg":@"用户没有开启选择相片的权限!"}];
            !completionHandle?:completionHandle(NO, nil, error);
            return;
        }
    }
    self.completion = completionHandle;
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
    [self setupRightView];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self setupRightView]];
    
    [self.view addSubview:_contentCollectionView = [[MLPhotoPickerCollectionView alloc] initWithFrame:(CGRect){CGPointMake(0, 34), CGSizeMake(self.view.frame.size.width, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height)}]];
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
    if (gtiOS8) {
        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        [options setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]]];
        self.fetchResult = [PHAsset fetchAssetsInAssetCollection:group.collection options:options];
        
        NSMutableArray *assets = [NSMutableArray arrayWithCapacity:self.fetchResult.count];
        for (NSInteger i = 0; i < self.fetchResult.count; i++){
            MLPhotoAsset *asset = [[MLPhotoAsset alloc] init];
            asset.asset = self.fetchResult[i];
            [assets addObject:asset];
        }
        self.contentCollectionView.albumAssets = assets;
    } else {
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
}

- (UIView *)setupTitleView
{
    UIView *titleView = [[UIView alloc] init];
    titleView.frame = CGRectMake(0, 0, 200, 44);
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    titleButton.frame = titleView.frame;
    titleButton.titleLabel.font = [UIFont systemFontOfSize:14];
    titleButton.adjustsImageWhenHighlighted = NO;
    [titleButton setImage:[UIImage imageNamed:@"MLImagePickerController.bundle/zl_xialajiantou"] forState:UIControlStateNormal];
    [titleButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [titleButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [titleButton setTitle:@"相机胶卷" forState:UIControlStateNormal];
    [titleButton addTarget:self action:@selector(tappendTitleView) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:titleButton];
    return titleView;
}

- (void)setupRightView
{
    return ({
        UIView *rightView = [[UIView alloc] init];
        rightView.frame = CGRectMake(self.view.frame.size.width - 60, 0, 40, 44);
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [rightBtn setFrame:rightView.bounds];
        [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(tappendDoneBtn) forControlEvents:UIControlEventTouchUpInside];
        [rightView addSubview:rightBtn];
        [self.navigationController.navigationBar addSubview:rightView];
    });
}

- (void)setupGroup
{
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    [options setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]]];
    PHFetchResult *allPhotos = [PHAsset fetchAssetsWithOptions:options];
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    PHFetchResult *userCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    
    NSMutableArray *groups = @[].mutableCopy;
    NSArray *collections = @[allPhotos,smartAlbums,userCollections];
    for (PHFetchResult *result in collections)
    {
        for (PHAssetCollection *collection in result)
        {
            if ([collection isKindOfClass:[PHAssetCollection class]])
            {
                // Filter empty Assets.
                PHFetchResult *collectionResult = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
                if (collectionResult.count > 0)
                {
                    MLPhotoPickerGroup *group = [[MLPhotoPickerGroup alloc] init];
                    group.collection = collection;
                    [groups addObject:group];
                }
            }
        }
    }
    self.groups = groups;
}

- (void)tappendTitleView
{
    UIView *titleView = self.navigationItem.titleView;
    UIButton *titleBtn = [[titleView subviews] lastObject];
    
    [UIView animateWithDuration:0.25 animations:^{
        titleBtn.imageView.transform = (self.groupTableView.alpha == 1.0) ? CGAffineTransformMakeRotation(0) : CGAffineTransformMakeRotation(M_PI);
        self.groupTableView.alpha = (self.groupTableView.alpha == 1.0) ? 0.0 : 1.0;
    }];
}

- (void)tappendDoneBtn
{
    !self.completion?:self.completion(YES, [self.pickerManager.selectsUrls mutableCopy], nil);
    // Clear Select Data.
    [MLPhotoPickerManager clear];
    [self dismissViewControllerAnimated:YES completion:nil];
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

- (MLPhotoPickerManager *)pickerManager
{
    if (!_pickerManager) {
        _pickerManager = [MLPhotoPickerManager manager];
    }
    return _pickerManager;
}

- (void)setSelectAssetsURL:(NSArray<NSURL *> *)selectAssetsURL
{
    _selectAssetsURL = selectAssetsURL;
    [MLPhotoPickerManager manager].selectsUrls = selectAssetsURL.mutableCopy;
}
@end
