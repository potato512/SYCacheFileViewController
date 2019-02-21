//
//  SYCacheFileImage.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 2019/2/12.
//  Copyright © 2019年 zhangshaoyu. All rights reserved.
//  图片浏览，单图，或多图轮播

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYCacheScaleImage : UIView

/// 图片点击回调
@property (nonatomic, copy) void (^imageTap)(void);

/// 图片显示（根据路径）
- (void)showImageWithFilePath:(NSString *)filePath;

@end

#pragma mark -

@interface SYCacheFileImage : UIView

/// 图片数组
@property (nonatomic, strong) NSArray <NSString *> *images;
/// 图片索引（默认0第一张）
@property (nonatomic, assign) NSInteger index;
/// 图片刷新
- (void)reloadImages;

@end

NS_ASSUME_NONNULL_END
