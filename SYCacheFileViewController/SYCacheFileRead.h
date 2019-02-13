//
//  SYCacheFileRead.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 17/6/27.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//  文件浏览

#import <Foundation/Foundation.h>

@interface SYCacheFileRead : NSObject

/**
 *  文件阅读：图片浏览、文档查看、音视频播放
 *
 *  @param filePath 文件路径
 *  @param target   UIViewController
 */
- (void)fileReadWithFilePath:(NSString *)filePath target:(id)target;

/**
 *  内存释放
 */
- (void)releaseSYCacheFileRead;

@end
