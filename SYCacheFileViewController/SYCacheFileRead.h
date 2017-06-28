//
//  SYCacheFileRead.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 17/6/27.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYCacheFileRead : NSObject

/// 文件阅读：图片浏览、文档查看、音视频播放
- (void)fileReadWithFilePath:(NSString *)filePath target:(id)target;

@end
