//
//  SYCacheFileTable.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 17/6/27.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYCacheFileTable : UITableView

/// 数据源
@property (nonatomic, strong) NSMutableArray *cacheDatas;

/// 响应回调
@property (nonatomic, copy) void (^itemClick)(NSIndexPath *indexPath);

@end
