//
//  MLImagePickerViewController+MenuTableViewDataSource.m
//  MLPhotoLib
//
//  Created by leisuro on 16/8/2.
//  Copyright © 2016年 Free. All rights reserved.
//

#import "MLImagePickerViewController+MenuTableViewDataSource.h"
#import "MLImagePickerMenuTableViewCell.h"

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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self reloadCollectionViewWithGroup:[self.groups objectAtIndex:indexPath.row]];
    [self tappendTitleView];
}

@end
