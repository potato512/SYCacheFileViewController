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

@property (nonatomic, strong) NSIndexPath *previousIndex;

@end

@implementation SYCacheFileTable

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self registerClass:[SYCacheFileCell class] forCellReuseIdentifier:reuseSYCacheDirectoryCell];
        
        self.delegate = self;
        self.dataSource = self;
        
        self.tableFooterView = [UIView new];
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
    // 长按
    SYCacheFileTable __weak *weakSelf = self;
    cell.longPress = ^{
        if (weakSelf.longPress) {
            weakSelf.longPress(weakSelf, indexPath);
        }
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SYCacheFileModel *model = self.cacheDatas[indexPath.row];
    
    // 音频播放
    SYCacheFileType type = [[SYCacheFileManager shareManager] fileTypeReadWithFilePath:model.filePath];
    if (SYCacheFileTypeAudio == type) {
        model.fileProgressShow = YES;
        NSString *currentPath = model.filePath;
        
        if (self.previousIndex) {
            SYCacheFileModel *previousModel = self.cacheDatas[self.previousIndex.row];
            NSString *previousPath = previousModel.filePath;
            if (![currentPath isEqualToString:previousPath]) {
                previousModel.fileProgress = 0.0;
                previousModel.fileProgressShow = NO;
                [tableView reloadRowsAtIndexPaths:@[self.previousIndex] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
        
        self.previousIndex = indexPath;
    }

    // 回调响应
    if (self.itemClick) {
        self.itemClick(indexPath);
    }
}

#pragma mark 编辑

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleItemAtIndex:indexPath];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

#pragma mark - 删除操作

- (void)deleItemAtIndex:(NSIndexPath *)indexPath
{
    if (indexPath.row > self.cacheDatas.count - 1) {
        return;
    }
    SYCacheFileModel *model = self.cacheDatas[indexPath.row];
    // 系统数据不可删除
    if ([[SYCacheFileManager shareManager] isFileSystemWithFilePath:model.filePath]) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"系统文件不能删除" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }
    // 当前删除的是音频时，先停止播放
    if (model.fileType == SYCacheFileTypeAudio) {
        [[NSNotificationCenter defaultCenter] postNotificationName:SYCacheFileAudioDeleteNotificationName object:nil];
    }
    if (self.previousIndex) {
        self.previousIndex = nil;
    }
    // 删除数据：删除数组、删除本地文件/文件夹、刷新页面、发通知刷新文件大小统计
    // 删除数组
    [self.cacheDatas removeObjectAtIndex:indexPath.row];
    // 删除本地文件/文件夹
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL isDelete = [SYCacheFileManager deleteFileWithDirectory:model.filePath];
        NSLog(@"删除：%@", (isDelete ? @"成功" : @"失败"));
    });
    // 刷新页面
//    [self deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self reloadData];
}

@end
