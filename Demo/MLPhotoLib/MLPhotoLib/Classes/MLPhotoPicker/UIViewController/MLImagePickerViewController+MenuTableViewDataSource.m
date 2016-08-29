//
//  MLImagePickerViewController+MenuTableViewDataSource.m
//  MLPhotoLib
//
//  Created by leisuro on 16/8/2.
//  Copyright © 2016年 Free. All rights reserved.
//

#import "MLImagePickerViewController+MenuTableViewDataSource.h"
#import "MLImagePickerMenuTableViewCell.h"
#import <Photos/Photos.h>

@implementation MLImagePickerViewController (MenuTableViewDataSource) 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.groups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MLImagePickerMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MLImagePickerMenuTableViewCell class])];
    cell.group = [self.groups objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self reloadCollectionViewWithGroup:[self.groups objectAtIndex:indexPath.row]];
    [self tappendTitleView];
     
    // 更新Cell状态
    MLImagePickerMenuTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 更新Cell状态
    MLImagePickerMenuTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO];
}

@end
