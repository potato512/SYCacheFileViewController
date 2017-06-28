//
//  SYCacheFileManager.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 17/6/28.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import "SYCacheFileManager.h"

@implementation SYCacheFileManager

#pragma mark - 文件类型

/**
 *  默认显示文件
 *  视频：.avi、.dat、.mkv、.flv、.vob、.mp4、.m4v、.mpg、.mpeg、.mpe、.3pg、.mov、.swf、.wmv、.asf、.asx、.rm、.rmvb
 *  音频：.wav、.aif、.au、.mp3、.ram、.wma、.mmf、.amr、.aac、.flac、.midi、.mp3、.oog、.cd、.asf、.rm、.real、.ape、.vqf
 *  图片：.jpg、.png、.jpeg、.gif、.bmp
 *  文档：.txt、.sh、.doc、.docx、.xls、.xlsx、.pdf、.hlp、.wps、.rtf、.html、.iso、.rar、.zip、.exe、.mdf、.ppt、.pptx
 *  @return NSArray
 */
+ (NSArray *)fileTypeRead
{
    NSMutableArray *array = [NSMutableArray array];
    [array addObjectsFromArray:[[self class] fileTypeVideoRead]];
    [array addObjectsFromArray:[[self class] fileTypeAudioRead]];
    [array addObjectsFromArray:[[self class] fileTypeImageRead]];
    [array addObjectsFromArray:[[self class] fileTypeTxtRead]];
    
    return array;
}

+ (NSArray *)fileTypeVideoRead
{
    return @[@".avi", @".dat", @".mkv", @".flv", @".vob", @".mp4", @".m4v", @".mpg", @".mpeg", @".mpe", @".3pg", @".mov", @".swf", @".wmv", @".asf", @".asx", @".rm", @".rmvb"];
}

+ (NSArray *)fileTypeAudioRead
{
    return @[@".wav", @".aif", @".au", @".mp3", @".ram", @".wma", @".mmf", @".amr", @".aac", @".flac", @".midi", @".mp3", @".oog", @".cd", @".asf", @".rm", @".real", @".ape", @".vqf"];
}

+ (NSArray *)fileTypeImageRead
{
    return @[@".jpg", @".png", @".jpeg", @".gif", @".bmp"];
}

+ (NSArray *)fileTypeTxtRead
{
    return @[@".txt", @".sh", @".doc", @".docx", @".xls", @".xlsx", @".pdf", @".hlp", @".wps", @".rtf", @".html", @".iso", @".rar", @".zip", @".exe", @".mdf", @".ppt", @".pptx"];
}

+ (SYCacheFileType)fileTypeReadWithFilePath:(NSString *)filePath
{
    NSString *fileType = [[self class] fileTypeWithFilePath:filePath];
    SYCacheFileType type = SYCacheFileTypeUnknow;
    if ([[[self class] fileTypeVideoRead] containsObject:fileType])
    {
        type = SYCacheFileTypeVideo;
    }
    else if ([[[self class] fileTypeAudioRead] containsObject:fileType])
    {
        type = SYCacheFileTypeAudio;
    }
    else if ([[[self class] fileTypeImageRead] containsObject:fileType])
    {
        type = SYCacheFileTypeImage;
    }
    else if ([[[self class] fileTypeTxtRead] containsObject:fileType])
    {
        type = SYCacheFileTypeDocument;
    }
    
    return type;
}

#pragma mark - 文件类型对应图标

+ (UIImage *)fileTypeImageWithFilePath:(NSString *)filePath
{
    UIImage *image = [UIImage imageNamed:@"folder_cacheFile"];
    if (filePath && 0 < filePath.length)
    {
        SYCacheFileType type = [[self class] fileTypeReadWithFilePath:filePath];
        if (SYCacheFileTypeUnknow == type)
        {
            image = [UIImage imageNamed:@"folder_cacheFile"];
        }
        else
        {
            NSString *fileType = [[self class] fileTypeWithFilePath:filePath];
            if ([[[self class] fileTypeImageRead] containsObject:fileType])
            {
                image = [UIImage imageNamed:@"image_cacheFile"];
            }
            else if ([[[self class] fileTypeVideoRead] containsObject:fileType])
            {
                image = [UIImage imageNamed:@"video_cacheFile"];
            }
            else if ([[[self class] fileTypeAudioRead] containsObject:fileType])
            {
                image = [UIImage imageNamed:@"audio_cacheFile"];
            }
            else if ([@[@".doc", @".docx"] containsObject:fileType])
            {
                image = [UIImage imageNamed:@"doc_cacheFile"];
            }
            else if ([@[@".xls", @".xlsx"] containsObject:fileType])
            {
                image = [UIImage imageNamed:@"xls_cacheFile"];
            }
            else if ([@[@".pdf"] containsObject:fileType])
            {
                image = [UIImage imageNamed:@"pdf_cacheFile"];
            }
            else if ([@[@".ppt", @".pptx"] containsObject:fileType])
            {
                image = [UIImage imageNamed:@"ppt_cacheFile"];
            }
            else
            {
                image = [UIImage imageNamed:@"file_cacheFile"];
            }
        }
    }
    return image;
}

#pragma mark - 文件名称与类型

// 文件名称（如：hello.png）
+ (NSString *)fileNameWithFilePath:(NSString *)filePath
{
    if ([[self class] isFileExists:filePath])
    {
        NSRange range = [filePath rangeOfString:@"/" options:NSBackwardsSearch];
        if (range.location != NSNotFound)
        {
            NSString *text = [filePath substringFromIndex:(range.location + range.length)];
            return text;
        }
        
        return nil;
    }
    
    return nil;
}

// 文件类型（如：.png）
+ (NSString *)fileTypeWithFilePath:(NSString *)filePath
{
    if ([[self class] isFileExists:filePath])
    {
        NSRange range = [filePath rangeOfString:@"." options:NSBackwardsSearch];
        if (range.location != NSNotFound)
        {
            NSString *text = [filePath substringFromIndex:(range.location)];
            return text;
        }
        
        return nil;
    }
    
    return nil;
}

// 文件类型（如：png）
+ (NSString *)fileTypeExtensionWithFilePath:(NSString *)filePath
{
    if ([[self class] isFileExists:filePath])
    {
        NSString *text = filePath.pathExtension;
        return text;
    }
    
    return nil;
}


#pragma mark - 文件目录

/// 获取程序的Home目录路径
+ (NSString *)homeDirectoryPath
{
    return NSHomeDirectory();
}

/// 获取目录列表里所有的文件名及文件夹名
+ (NSArray *)subPathsWithFilePath:(NSString *)filePath
{
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSArray *files = [fileManage subpathsAtPath:filePath];
    return files;
}

/// 判断一个目录是否是文件夹
+ (BOOL)isFileDirectoryWithFilePath:(NSString *)filePath
{
    BOOL isDirectory = NO;
    [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
    return isDirectory;
}

/// 获取沙盒目录中指定目录的的所有文件夹，或文件
+ (NSArray *)filesWithFilePath:(NSString *)filePath isDirectory:(BOOL)isDirectory
{
    NSMutableArray *directions = [NSMutableArray array];
    NSArray *files = [[self class] subPathsWithFilePath:filePath];
    for (id object in files)
    {
        BOOL isDir = [[self class] isFileDirectoryWithFilePath:object];
        if (isDirectory)
        {
            if (isDir)
            {
                [directions addObject:object];
            }
        }
        else
        {
            if (!isDir)
            {
                [directions addObject:object];
            }
        }
    }
    return directions;
}

/// 获取沙盒目录中指定目录的的所有文件夹
+ (NSArray *)fileDirectionsWithFilePath:(NSString *)filePath
{
    NSArray *files = [[self class] filesWithFilePath:filePath isDirectory:YES];
    return files;
}

/// 获取沙盒目录中指定目录的的所有文件夹
+ (NSArray *)filesWithFilePath:(NSString *)filePath
{
    NSArray *files = [[self class] filesWithFilePath:filePath isDirectory:NO];
    return files;
}

#pragma mark - 文件与目录的操作

/// 是否存在该文件
+ (BOOL)isFileExists:(NSString *)filepath
{
    return [[NSFileManager defaultManager] fileExistsAtPath:filepath];
}

/// 单个文件的大小Number
+ (double)fileSizeNumberWithFilePath:(NSString *)filePath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath])
    {
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

/// 单个文件的大小String
+ (NSString *)fileSizeStringWithFilePath:(NSString *)filePath
{
    // 1MB = 1024KB 1KB = 1024B
    double size = [[self class] fileSizeNumberWithFilePath:filePath];
    NSString *message = nil;
    if (size > (1024 * 1024))
    {
        size = size / (1024 * 1024);
        message = [NSString stringWithFormat:@"%.2fM", size];
    }
    else if (size > 1024)
    {
        size = size / 1024;
        message = [NSString stringWithFormat:@"%.2fKB", size];
    }
    else if (size > 0.0)
    {
        message = [NSString stringWithFormat:@"%.2fB", size];
    }
    
    return message;
}

@end
