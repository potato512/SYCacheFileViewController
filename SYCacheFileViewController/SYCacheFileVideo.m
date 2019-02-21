//
//  SYCacheFileVideo.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 2019/2/21.
//  Copyright © 2019年 zhangshaoyu. All rights reserved.
//

#import "SYCacheFileVideo.h"
#import <UIKit/UIKit.h>
// 视频
#import <AVKit/AVKit.h>

@implementation SYCacheFileVideo

/// 视频播放（根据路径）
- (void)playVideoWithFilePath:(NSString *)filePath target:(id)target
{
    if ((filePath && [filePath isKindOfClass:[NSString class]] && filePath.length > 0) && (target && [target isKindOfClass:[UIViewController class]])) {
        NSURL *videoUrl = [NSURL fileURLWithPath:filePath];
        if ([filePath hasPrefix:@"https://"] || [filePath hasPrefix:@"http://"]) {
            videoUrl = [NSURL URLWithString:filePath];
        }
        UIViewController *controller = target;
        //
        AVPlayerViewController *playerController = [[AVPlayerViewController alloc] init];
        playerController.player = [[AVPlayer alloc] initWithURL:videoUrl];
        [playerController.player play];
        [controller presentViewController:playerController animated:YES completion:nil];
    }
}

@end
