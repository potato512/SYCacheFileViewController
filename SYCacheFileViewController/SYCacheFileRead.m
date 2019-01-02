//
//  SYCacheFileRead.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 17/6/27.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import "SYCacheFileRead.h"
#import <AVFoundation/AVFoundation.h>
// 视频
#import <MediaPlayer/MediaPlayer.h>
// 文档
#import <QuickLook/QuickLook.h>

#import "SYCacheFileManager.h"

@interface SYCacheFileRead () <AVAudioPlayerDelegate, UIDocumentInteractionControllerDelegate>

@property (nonatomic, weak) UIViewController *controller;

// 音频播放
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, assign) NSTimeInterval durationTotal;
@property (nonatomic, assign) NSTimeInterval duration;

// 视频播放
@property (nonatomic, retain) MPMoviePlayerViewController *videoViewController;
@property (nonatomic, strong) MPMoviePlayerController *videoController;
@property (nonatomic, strong) NSURL *videoUrl;

// 文档查看（文档、图片、视频）
@property (nonatomic, strong) UIDocumentInteractionController *documentController;

@end

@implementation SYCacheFileRead

// 初始化
- (id)init
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
    //
    if (self.videoController) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self.videoController stop];
    }
    //
    if (self.documentController) {
        self.documentController = nil;
    }
    
    NSLog(@"%@ 被释放了!", [self class]);
}

- (void)releaseSYCacheFileRead
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

/**
 *  文件阅读：图片浏览、文档查看、音视频播放
 *
 *  @param filePath 文件路径
 *  @param target   UIViewController
 */
- (void)fileReadWithFilePath:(NSString *)filePath target:(id)target
{
    if (filePath == nil || ![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"filePath指向文件不存在" delegate:@"知道了" cancelButtonTitle:nil otherButtonTitles:nil, nil] show];
        return;
    }
    if (target == nil || ![target isKindOfClass:[UIViewController class]]) {
        [[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"target类型不是UIViewController" delegate:@"知道了" cancelButtonTitle:nil otherButtonTitles:nil, nil] show];
        return;
    }

    if ([SYCacheFileManager shareManager].showDoucumentUI) {
        [self fileDocumentReadWithFilePath:filePath target:target];
    } else {
        SYCacheFileType type = [[SYCacheFileManager shareManager] fileTypeReadWithFilePath:filePath];
        if (SYCacheFileTypeAudio == type) {
            [self fileAudioReadWithFilePath:filePath target:target];
        } else if (SYCacheFileTypeVideo == type) {
            [self fileVidioReadWithFilePath:filePath target:target];
        } else {
            [self fileDocumentReadWithFilePath:filePath target:target];
        }
    }
}

#pragma mark - 音频播放

- (void)fileAudioReadWithFilePath:(NSString *)filePath target:(id)target
{
    if (filePath && target) {
        NSURL *url = [NSURL fileURLWithPath:filePath];
        self.controller = target;
        
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
        
        if (self.audioPlayer == nil) {
            self.durationTotal = 0.0;
            self.duration = 0.0;
            
            NSError *error;
            self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
            
            self.audioPlayer.volume = 1.0;
            self.audioPlayer.numberOfLoops = 1;
            self.audioPlayer.currentTime = 0.0;
            
            self.audioPlayer.delegate = self;

            [self.audioPlayer prepareToPlay];
            [self.audioPlayer play];
            
            self.durationTotal = self.audioPlayer.duration;
            [self fileReadAuionDuration];
        }
    }
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
    }
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

    NSLog(@"duration = %.2f, durationTotal = %.2f", self.duration, self.durationTotal);
    [self performSelector:@selector(fileReadAuionDuration) withObject:nil afterDelay:1.0];
}

#pragma mark - 视频播放

- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:nil];
}

- (void)movieFinishedCallback:(NSNotification *)aNotification
{
    NSLog(@"movieFinishedCallback");
    [self.videoController stop];
    [self.controller dismissMoviePlayerViewControllerAnimated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark 视频播放

/// 播放视频（网络地址，或本地路径，或本地文件名称）
- (void)fileVidioReadWithFilePath:(NSString *)filePath target:(id)target
{
    [self fileAudioStop];
    
    self.videoUrl = [NSURL fileURLWithPath:filePath];
    self.controller = target;
    //
    self.videoViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:self.videoUrl];
    self.videoController = self.videoViewController.moviePlayer;
    self.videoController.movieSourceType = MPMovieSourceTypeFile;
    // 控制播放行为
    self.videoController.controlStyle = MPMovieControlStyleFullscreen;
    // 控制影片的尺寸
    self.videoController.scalingMode = MPMovieScalingModeAspectFit;
    // 自动播放
    self.videoController.shouldAutoplay = YES;
    //
    [self addNotification];
    [self.controller presentMoviePlayerViewControllerAnimated:self.videoViewController];
    [self.videoController prepareToPlay];
    [self.videoController play];
}

#pragma mark - 文件阅读

- (void)fileDocumentReadWithFilePath:(NSString *)filePath target:(id)target
{
    if (filePath && target) {
        [self fileAudioStop];
        
        NSURL *url = [NSURL fileURLWithPath:filePath];
        self.controller = target;
        if (self.documentController == nil) {
            self.documentController = [UIDocumentInteractionController interactionControllerWithURL:url];
            self.documentController.delegate = self;
            [self.documentController presentPreviewAnimated:YES];
        }
    }
}

#pragma mark UIDocumentInteractionController

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self.controller;
}

- (UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller
{
    return self.controller.view;
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController *)controller
{
    return self.controller.view.bounds;
}

// 点击预览窗口的“Done”(完成)按钮时调用
- (void)documentInteractionControllerDidEndPreview:(UIDocumentInteractionController *)_controller
{
    self.documentController = nil;
}

@end
