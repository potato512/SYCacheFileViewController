//
//  SYCacheFileDefine.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 17/6/28.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#ifndef SYCacheFileDefine_h
#define SYCacheFileDefine_h

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
