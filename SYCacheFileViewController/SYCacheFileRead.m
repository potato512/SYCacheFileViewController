//
//  SYCacheFileRead.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 17/6/27.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import "SYCacheFileRead.h"
#import <AVFoundation/AVFoundation.h>
#import <QuickLook/QuickLook.h>

#import "SYCacheFileManager.h"

@interface SYCacheFileRead () <AVAudioPlayerDelegate, UIDocumentInteractionControllerDelegate>

@property (nonatomic, weak) UIViewController *controller;

// 音频播放
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

// 文档查看（文档、图片、视频）
@property (nonatomic, strong) UIDocumentInteractionController *documentController;

@end

@implementation SYCacheFileRead

// 初始化
- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

// 内存管理
- (void)dealloc
{
    NSLog(@"%@ 被释放了!", [self class]);
}

- (void)fileReadWithFilePath:(NSString *)filePath target:(id)target
{
    if (filePath && target)
    {
        SYCacheFileType type = [SYCacheFileManager fileTypeReadWithFilePath:filePath];
        if (SYCacheFileTypeAudio == type)
        {
            [self fileAudioReadWithFilePath:filePath target:target];
        }
        else
        {
            [self fileDocumentReadWithFilePath:filePath target:target];
        }
    }
}

#pragma mark - 音频播放

- (void)fileAudioReadWithFilePath:(NSString *)filePath target:(id)target
{
    if (filePath && target)
    {
        NSURL *url = [NSURL fileURLWithPath:filePath];
        self.controller = target;
        
        if (self.audioPlayer && self.audioPlayer.isPlaying)
        {
            [self.audioPlayer stop];
            self.audioPlayer = nil;
        }
        
        if (self.audioPlayer == nil)
        {
            NSError *error;
            self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
            
            self.audioPlayer.volume = 1.0;
            self.audioPlayer.numberOfLoops = 1;
            self.audioPlayer.currentTime = 0.0;
            
            self.audioPlayer.delegate = self;
            
            [self.audioPlayer prepareToPlay];
            [self.audioPlayer play];
        }
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    // 播放结束时执行的动作
    self.audioPlayer = nil;
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

#pragma mark - 文件阅读

- (void)fileDocumentReadWithFilePath:(NSString *)filePath target:(id)target
{
    if (filePath && target)
    {
        if (self.audioPlayer && self.audioPlayer.isPlaying)
        {
            [self.audioPlayer stop];
            self.audioPlayer = nil;
        }
        
        NSURL *url = [NSURL fileURLWithPath:filePath];
        self.controller = target;
        if (self.documentController == nil)
        {
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
