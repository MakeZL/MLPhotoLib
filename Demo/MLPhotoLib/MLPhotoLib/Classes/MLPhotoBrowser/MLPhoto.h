//
//  MLPhoto.h
//  MLPhotoLib
//
//  Created by leisuro on 16/8/16.
//  Copyright © 2016年 Free. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLPhoto : NSObject
@property (strong, nonatomic) NSURL *originalImageUrl;
@property (strong, nonatomic) UIImage *origianlImage;

@property (strong, nonatomic) NSURL *thumbImageUrl;
@property (strong, nonatomic) UIImage *thumbImage;

/// Asset URL
@property (strong, nonatomic) NSURL *assetUrl;
@end

