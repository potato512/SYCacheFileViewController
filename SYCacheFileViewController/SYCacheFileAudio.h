//
//  SYCacheFileAudio.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 2019/2/21.
//  Copyright © 2019年 zhangshaoyu. All rights reserved.
//  音频播放

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *const SYCacheFileAudioDurationValueChangeNotificationName = @"AudioDurationValueChangeNotificationName";
static NSString *const SYCacheFileAudioStopNotificationName = @"AudioStopNotificationName";
static NSString *const SYCacheFileAudioDeleteNotificationName = @"AudioDeleteNotificationName";

@interface SYCacheFileAudio : NSObject

+ (instancetype)shareAudio;

- (void)playAudioWithFilePath:(NSString *)filePath;

- (void)stopAudio;

@end

NS_ASSUME_NONNULL_END
