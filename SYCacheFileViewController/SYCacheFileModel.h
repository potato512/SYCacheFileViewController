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

@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *fileSize;

/// 文件类型（1视频、2音频、3图片、4文档）
@property (nonatomic, assign) SYCacheFileType fileType;

@end
