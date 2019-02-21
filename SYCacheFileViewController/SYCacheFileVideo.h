//
//  SYCacheFileVideo.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 2019/2/21.
//  Copyright © 2019年 zhangshaoyu. All rights reserved.
//  视频播放

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYCacheFileVideo : NSObject

/// 视频播放（根据路径）
- (void)playVideoWithFilePath:(NSString *)filePath target:(id)target;

@end

NS_ASSUME_NONNULL_END
