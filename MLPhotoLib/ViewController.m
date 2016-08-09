//
//  ViewController.m
//  MLPhotoLib
//
//  Created by leisuro on 16/8/1.
//  Copyright © 2016年 Free. All rights reserved.
//

#import "ViewController.h"
#import "MLImagePickerViewController.h"

@interface ViewController ()
@property (nonatomic, strong) NSArray *selectUrls;
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
    // Recoder
    pickerVC.selectAssetsURL = self.selectUrls;
    
    WeakSelf
    [pickerVC displayForVC:self completionHandle:^(BOOL success, NSArray<NSURL *> *assetUrls, NSArray<UIImage *> *thumbImages, NSArray<UIImage *> *originalImages, NSError *error) {
        
        weakSelf.selectUrls = assetUrls;
        
        NSLog(@" assetUrls -- :%@", assetUrls);
        NSLog(@" thumbImages -- :%@", thumbImages);
        NSLog(@" originalImages -- :%@", originalImages);
    }];
}

- (IBAction)actionQuickPrev
{
    
}


@end
