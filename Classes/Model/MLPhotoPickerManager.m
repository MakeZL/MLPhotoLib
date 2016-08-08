//
//  MLPhotoPickerManager.m
//  MLPhotoLib
//
//  Created by leisuro on 16/8/1.
//  Copyright © 2016年 Free. All rights reserved.
//

#import "MLPhotoPickerManager.h"

@implementation MLPhotoPickerManager
+ (instancetype)manager
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (NSMutableArray *)selectsUrls
{
    if (!_selectsUrls) {
        _selectsUrls = @[].mutableCopy;
    }
    return _selectsUrls;
}
@end
