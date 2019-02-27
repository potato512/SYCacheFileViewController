//
//  SYCacheFileViewController.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 17/6/27.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//  https://github.com/potato512/SYCacheFileViewController

#import <UIKit/UIKit.h>

@interface SYCacheFileViewController : UIViewController

/// 导航栏标题（默认缓存目录）
@property (nonatomic, strong) NSString *cacheTitle;
/// 数据源（默认home目录）
@property (nonatomic, strong) NSMutableArray *cacheArray;

/// 显示样式（默认0列表，1九宫格）
@property (nonatomic, assign) NSInteger showType;

@end
