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

@property (nonatomic, copy) void (^imageTap)(void);

- (void)showImageWithFilePath:(NSString *)filePath;

@end

#pragma mark -

@interface SYCacheFileImage : UIView

@property (nonatomic, strong) NSArray <NSString *> *images;
@property (nonatomic, assign) NSInteger index;

- (void)reloadImages;

@end

NS_ASSUME_NONNULL_END
