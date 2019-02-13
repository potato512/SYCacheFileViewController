//
//  SYCacheFileCell.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 17/6/27.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//  文件显示单元格

#import <UIKit/UIKit.h>
#import "SYCacheFileModel.h"

static NSString *const reuseSYCacheDirectoryCell = @"SYCacheDirectoryCell";
static CGFloat const heightSYCacheDirectoryCell = 60.0;

@interface SYCacheFileCell : UITableViewCell

/// 数据源
@property (nonatomic, strong) SYCacheFileModel *model;
/// 长按回调
@property (nonatomic, copy) void (^longPress)(void);

@end
