//
//  SYCacheFileModel.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 17/6/28.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import "SYCacheFileModel.h"
#import "SYCacheFileManager.h"

@implementation SYCacheFileModel

- (NSString *)fileSize
{
    if (self.fileType == SYCacheFileTypeUnknow) {
        return [SYCacheFileManager fileSizeTotalStringWithDirectory:self.filePath];
    }
    return [SYCacheFileManager fileSizeStringWithFilePath:self.filePath];
}

- (SYCacheFileType)fileType
{
    return [[SYCacheFileManager shareManager] fileTypeReadWithFilePath:self.filePath];
}

@end
