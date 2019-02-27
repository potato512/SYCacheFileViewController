//
//  SYCacheFileCollectionCell.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 2019/2/27.
//  Copyright © 2019年 zhangshaoyu. All rights reserved.
//  文件列表单元格

#import <UIKit/UIKit.h>
#import "SYCacheFileModel.h"

NS_ASSUME_NONNULL_BEGIN

static NSInteger const columnNumber = 2;

#define widthScreen ([[UIScreen mainScreen] bounds].size.width)

#define widthCollectionViewCell ((widthScreen - 10.0 * (columnNumber + 1)) / columnNumber)
static CGFloat const heightCollectionViewCell = 120.0;
static NSString *const identifierCollectionViewCell = @"CollectionViewCell";

@interface SYCacheFileCollectionCell : UICollectionViewCell

/// 数据源
@property (nonatomic, strong) SYCacheFileModel *model;
/// 长按回调
@property (nonatomic, copy) void (^longPress)(void);

@end

NS_ASSUME_NONNULL_END
