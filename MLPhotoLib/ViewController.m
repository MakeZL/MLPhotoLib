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
    [pickerVC displayForVC:self];
}

- (IBAction)actionQuickPrev
{
    
}


@end
