//
//  SYCacheFileModel.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 17/6/28.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYCacheFileDefine.h"

@interface SYCacheFileModel : NSObject

/// 文件路径
@property (nonatomic, strong) NSString *filePath;
/// 文件名称
@property (nonatomic, strong) NSString *fileName;
/// 文件大小
@property (nonatomic, strong) NSString *fileSize;

/// 文件类型（1视频、2音频、3图片、4文档）
@property (nonatomic, assign) SYCacheFileType fileType;
/// 音频文件进度
@property (nonatomic, assign) float fileProgress;
/// 音频文件进度显示
@property (nonatomic, assign) BOOL fileProgressShow;

@end
