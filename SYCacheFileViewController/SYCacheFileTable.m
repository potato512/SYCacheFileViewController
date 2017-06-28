//
//  SYCacheFileTable.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 17/6/27.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import "SYCacheFileTable.h"
#import "SYCacheFileCell.h"
#import "SYCacheFileModel.h"
#import "SYCacheFileManager.h"

@interface SYCacheFileTable () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation SYCacheFileTable

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.tableFooterView = [UIView new];
        
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.separatorInset = UIEdgeInsetsMake(0.0, -50.0, 0.0, 0.0);
        self.layoutMargins = UIEdgeInsetsMake(0.0, -50.0, 0.0, 0.0);

        [self registerClass:[SYCacheFileCell class] forCellReuseIdentifier:reuseSYCacheDirectoryCell];
        
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cacheDatas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return heightSYCacheDirectoryCell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SYCacheFileCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseSYCacheDirectoryCell];

    // 数据
    SYCacheFileModel *model = self.cacheDatas[indexPath.row];
    cell.model = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.itemClick)
    {
        self.itemClick(indexPath);
    }
}

@end
