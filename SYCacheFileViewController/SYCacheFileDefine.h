//
//  SYCacheFileDefine.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 17/6/28.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#ifndef SYCacheFileDefine_h
#define SYCacheFileDefine_h


static NSString *const SYCacheFileTitle = @"缓存文件";

static NSString *const SYCacheFileAudioDurationValueChangeNotificationName = @"AudioDurationValueChangeNotificationName";
static NSString *const SYCacheFileAudioStopNotificationName = @"AudioStopNotificationName";

/**
 *  默认显示文件
 *  视频：.avi、.dat、.mkv、.flv、.vob、.mp4、.m4v、.mpg、.mpeg、.mpe、.3pg、.mov、.swf、.wmv、.asf、.asx、.rm、.rmvb
 *  音频：.wav、.aif、.au、.mp3、.ram、.wma、.mmf、.amr、.aac、.flac、.midi、.mp3、.oog、.cd、.asf、.rm、.real、.ape、.vqf
 *  图片：.jpg、.png、.jpeg、.gif、.bmp
 *  文档：.txt、.sh、.doc、.docx、.xls、.xlsx、.pdf、.hlp、.wps、.rtf、.html、@".htm", .iso、.rar、.zip、.exe、.mdf、.ppt、.pptx
 */

/// 文件类型
typedef NS_ENUM(NSInteger, SYCacheFileType)
{
    /// 文件类型 0未知
    SYCacheFileTypeUnknow = 0,
    
    /// 文件类型 1视频
    SYCacheFileTypeVideo = 1,
    
    /// 文件类型 2音频
    SYCacheFileTypeAudio = 2,
    
    /// 文件类型 3图片
    SYCacheFileTypeImage = 3,
    
    /// 文件类型 4文档
    SYCacheFileTypeDocument = 4,
};

#endif /* SYCacheFileDefine_h */
