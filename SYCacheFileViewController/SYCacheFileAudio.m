//
//  SYCacheFileAudio.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 2019/2/21.
//  Copyright © 2019年 zhangshaoyu. All rights reserved.
//

#import "SYCacheFileAudio.h"
#import <UIKit/UIKit.h>
// 音频
#import <AVFoundation/AVFoundation.h>

@interface SYCacheFileAudio () <AVAudioPlayerDelegate>

// 音频播放
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, assign) NSTimeInterval durationTotal;
@property (nonatomic, assign) NSTimeInterval duration;

@end

@implementation SYCacheFileAudio


+ (instancetype)shareAudio
{
    static SYCacheFileAudio *fileAudio;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fileAudio = [[self alloc] init];
    });
    return fileAudio;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

// 内存管理
- (void)dealloc
{
    [self fileAudioStop];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@ 被释放了!", [self class]);
}

- (void)playAudioWithFilePath:(NSString *)filePath
{
    if (filePath && [filePath isKindOfClass:[NSString class]] && filePath.length > 0) {
        NSURL *url = [NSURL fileURLWithPath:filePath];
        if ([filePath hasPrefix:@"https://"] || [filePath hasPrefix:@"http://"]) {
            url = [NSURL URLWithString:filePath];
        }
        
        if (self.audioPlayer) {
            [self releaseSYCacheFileRead];
            
            NSString *pathPrevious = self.audioPlayer.url.relativeString;
            pathPrevious = [pathPrevious stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            if (self.audioPlayer.isPlaying) {
                [self.audioPlayer stop];
            }
            
            self.audioPlayer = nil;
            
            // 同一个文件时，停止播放后不再开始开始
            NSRange range = [pathPrevious rangeOfString:filePath];
            if (range.location != NSNotFound) {
                [[NSNotificationCenter defaultCenter] postNotificationName:SYCacheFileAudioStopNotificationName object:nil];
                return;
            }
        }
        
        [self addNotificationDelete];
        if (self.audioPlayer == nil) {
            self.durationTotal = 0.0;
            self.duration = 0.0;
            
            NSError *error;
            self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
            
            self.audioPlayer.volume = 1.0;
            self.audioPlayer.numberOfLoops = 1;
            self.audioPlayer.currentTime = 0.0;
            
            self.audioPlayer.delegate = self;
            
            if (self.audioPlayer.prepareToPlay) {
                [self.audioPlayer play];
            }
            
            self.durationTotal = self.audioPlayer.duration;
            [self fileReadAuionDuration];
        }
    }
}

- (void)stopAudio
{
    [self fileAudioStop];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)fileAudioStop
{
    if (self.audioPlayer) {
        if (self.audioPlayer.isPlaying) {
            [self.audioPlayer stop];
        }
        self.audioPlayer = nil;
        //
        NSNumber *number = [NSNumber numberWithFloat:0.0];
        [[NSNotificationCenter defaultCenter] postNotificationName:SYCacheFileAudioDurationValueChangeNotificationName object:number];
        //
        [self releaseSYCacheFileRead];
        [[NSNotificationCenter defaultCenter] postNotificationName:SYCacheFileAudioStopNotificationName object:nil];
    }
}

- (void)releaseSYCacheFileRead
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

#pragma mark 通知处理

- (void)addNotificationDelete
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteAudioStop) name:SYCacheFileAudioDeleteNotificationName object:nil];
}

- (void)deleteAudioStop
{
    [self fileAudioStop];
}

#pragma mark 代理方法

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    // 播放结束时执行的动作
    self.audioPlayer = nil;
    
    [self releaseSYCacheFileRead];
    [[NSNotificationCenter defaultCenter] postNotificationName:SYCacheFileAudioStopNotificationName object:nil];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    // 解码错误执行的动作
    [self.audioPlayer stop];
}

- (void)audioPlayerBeginInteruption:(AVAudioPlayer *)player
{
    // 处理中断的代码
    [self.audioPlayer stop];
}

- (void)audioPlayerEndInteruption:(AVAudioPlayer *)player
{
    // 处理中断结束的代码
    [self.audioPlayer stop];
}

#pragma mark 回调方法

- (void)fileReadAuionDuration
{
    self.duration = self.audioPlayer.currentTime;
    NSTimeInterval progress = self.duration / self.durationTotal;
    NSNumber *number = [NSNumber numberWithFloat:progress];
    [[NSNotificationCenter defaultCenter] postNotificationName:SYCacheFileAudioDurationValueChangeNotificationName object:number];
    
#ifdef DEBUG
    NSLog(@"duration = %.2f, durationTotal = %.2f", self.duration, self.durationTotal);
#endif
    
    [self performSelector:@selector(fileReadAuionDuration) withObject:nil afterDelay:0.3];
}


@end
