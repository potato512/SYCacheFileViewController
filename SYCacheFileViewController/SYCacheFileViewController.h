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
/// 数据源
@property (nonatomic, strong) NSMutableArray *cacheArray;

@end
