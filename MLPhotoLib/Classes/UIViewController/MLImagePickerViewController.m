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
#import "MLPhotoPickerManager.h"
#import "MLPhotoAsset.h"
#import <AssetsLibrary/AssetsLibrary.h>

static NSUInteger kDefaultMaxCount = 9;

@interface MLImagePickerViewController ()
@property (nonatomic, weak) UITableView *groupTableView;
@property (nonatomic, strong) MLPhotoPickerCollectionView *contentCollectionView;
@end

@implementation MLImagePickerViewController

- (void)displayForVC:(__weak UIViewController *)viewController
{
    [viewController presentViewController:[[MLNavigationViewController alloc] initWithRootViewController:self] animated:YES completion:nil];
}

- (void)display
{
    [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:[[MLNavigationViewController alloc] initWithRootViewController:self] animated:YES completion:nil];
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
    //    if (gtiOS8) {
    //        // PhotoKit
    //
    //    } else {
    // AssetsLibrary
    WeakSelf
    MLPhotoPickerData *pickerData = [MLPhotoPickerData pickerData];
    [pickerData getAllGroup:^(NSArray *groups) {
        weakSelf.groups = groups;
        [weakSelf groupsWithAsset:groups];
    }];
    //    }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
