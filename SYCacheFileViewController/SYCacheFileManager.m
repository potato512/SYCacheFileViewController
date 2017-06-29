//
//  SYCacheFileManager.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 17/6/28.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import "SYCacheFileManager.h"
#import "SYCacheFileModel.h"

#include <sys/stat.h>
#include <dirent.h>

@implementation SYCacheFileManager

/**
 *  文件model
 *
 *  @param filePath 文件路径
 *
 *  @return NSArray
 */
+ (NSArray *)fileModelsWithFilePath:(NSString *)filePath
{
    NSArray *array = [SYCacheFileManager subFilesPathsWithFilePath:filePath];
    NSMutableArray *fileArray = [NSMutableArray arrayWithCapacity:array.count];
    for (id object in array)
    {
        SYCacheFileModel *model = [SYCacheFileModel new];
        model.fileName = object;
        model.filePath = [filePath stringByAppendingPathComponent:object];
        
        SYCacheFileType type = [SYCacheFileManager fileTypeReadWithFilePath:model.filePath];
        if (SYCacheFileTypeUnknow == type)
        {
            // 过滤系统文件夹
            NSRange range = [model.filePath rangeOfString:@"." options:NSBackwardsSearch];
            if (range.location != NSNotFound)
            {
                continue;
            }
        }
        else
        {
            // 过滤系统文件
            NSString *typeName = [SYCacheFileManager fileTypeWithFilePath:model.filePath];
            if (![SYCacheFileManager isFilterFileTypeWithFileType:typeName])
            {
                continue;
            }
        }
        
        [fileArray addObject:model];
    }

    return fileArray;
}


#pragma mark - 文件类型

+ (NSArray *)fileTypeArray
{
    NSMutableArray *array = [NSMutableArray array];
    [array addObjectsFromArray:SYCacheFileTypeVideoArray];
    [array addObjectsFromArray:SYCacheFileTypeAudioArray];
    [array addObjectsFromArray:SYCacheFileTypeImageArray];
    [array addObjectsFromArray:SYCacheFileTypeDocumentArray];
    
    return array;
}

/**
 *  筛选所需类型文件
 *
 *  @param type 文件类型
 *
 *  @return BOOL
 */
+ (BOOL)isFilterFileTypeWithFileType:(NSString *)type
{
    if ([[self fileTypeArray] containsObject:type])
    {
        return YES;
    }
    return NO;
}

/**
 *  判断文件类型
 *
 *  @param filePath 文件路径
 *
 *  @return SYCacheFileType
 */
+ (SYCacheFileType)fileTypeReadWithFilePath:(NSString *)filePath
{
    NSString *fileType = [self fileTypeWithFilePath:filePath];
    SYCacheFileType type = SYCacheFileTypeUnknow;
    if ([SYCacheFileTypeVideoArray containsObject:fileType])
    {
        type = SYCacheFileTypeVideo;
    }
    else if ([SYCacheFileTypeAudioArray containsObject:fileType])
    {
        type = SYCacheFileTypeAudio;
    }
    else if ([SYCacheFileTypeImageArray containsObject:fileType])
    {
        type = SYCacheFileTypeImage;
    }
    else if ([SYCacheFileTypeDocumentArray containsObject:fileType])
    {
        type = SYCacheFileTypeDocument;
    }
    
    return type;
}

#pragma mark - 文件类型对应图标

/**
 *  文件类型对应图标
 *
 *  @param filePath 文件路径
 *
 *  @return UIImage
 */
+ (UIImage *)fileTypeImageWithFilePath:(NSString *)filePath
{
    UIImage *image = [UIImage imageNamed:@"folder_cacheFile"];
    if (filePath && 0 < filePath.length)
    {
        SYCacheFileType type = [self fileTypeReadWithFilePath:filePath];
        if (SYCacheFileTypeUnknow == type)
        {
            image = [UIImage imageNamed:@"folder_cacheFile"];
        }
        else
        {
            NSString *fileType = [self fileTypeWithFilePath:filePath];
            if ([SYCacheFileTypeImageArray containsObject:fileType])
            {
                image = [UIImage imageNamed:@"image_cacheFile"];
            }
            else if ([SYCacheFileTypeVideoArray containsObject:fileType])
            {
                image = [UIImage imageNamed:@"video_cacheFile"];
            }
            else if ([SYCacheFileTypeAudioArray containsObject:fileType])
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

/**
 *  文件名称（如：hello.png）
 *
 *  @param filePath 文件路径
 *
 *  @return NSString
 */
+ (NSString *)fileNameWithFilePath:(NSString *)filePath
{
    if ([self isFileExists:filePath])
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

/**
 *  文件类型（如：.png）
 *
 *  @param filePath 文件路径
 *
 *  @return NSString
 */
+ (NSString *)fileTypeWithFilePath:(NSString *)filePath
{
    if ([self isFileExists:filePath])
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

/**
 *  文件类型（如：png）
 *
 *  @param filePath 文件路径
 *
 *  @return NSString
 */
+ (NSString *)fileTypeExtensionWithFilePath:(NSString *)filePath
{
    if ([self isFileExists:filePath])
    {
        NSString *text = filePath.pathExtension;
        return text;
    }
    
    return nil;
}

#pragma mark - 文件目录

#pragma mark 系统目录

/**
 *  Home目录路径
 *
 *  @return NSString
 */
+ (NSString *)homeDirectoryPath
{
    return NSHomeDirectory();
}

/**
 *  Document目录路径
 *
 *  @return NSString
 */
+ (NSString *)documentDirectoryPath
{
    NSArray *Paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [Paths objectAtIndex:0];
    return path;
}

/**
 *  Cache目录路径
 *
 *  @return NSString
 */
+ (NSString *)cacheDirectoryPath
{
    NSArray *Paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [Paths objectAtIndex:0];
    return path;
}

/**
 *  Library目录路径
 *
 *  @return NSString
 */
+ (NSString *)libraryDirectoryPath
{
    NSArray *Paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [Paths objectAtIndex:0];
    return path;
}

/**
 *  Tmp目录路径
 *
 *  @return NSString
 */
+ (NSString *)tmpDirectoryPath
{
    return NSTemporaryDirectory();
}

#pragma mark 目录文件

/**
 *  获取目录列表里所有层级子目录下的所有文件，及目录
 *
 *  @param filePath 文件路径
 *
 *  @return NSArray
 */
+ (NSArray *)subPathsWithFilePath:(NSString *)filePath
{
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:filePath];
    return files;
}

/**
 *  获取目录列表里当前层级的文件名及文件夹名
 *
 *  @param filePath 文件路径
 *
 *  @return NSArray
 */
+ (NSArray *)subFilesPathsWithFilePath:(NSString *)filePath
{
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:filePath error:nil];
    return files;
}

/**
 *  判断一个文件路径是否是文件夹
 *
 *  @param filePath 文件路径
 *
 *  @return BOOL
 */
+ (BOOL)isFileDirectoryWithFilePath:(NSString *)filePath
{
    BOOL isDirectory = NO;
    [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
    return isDirectory;
}

/// 获取沙盒目录中指定目录的所有文件夹，或文件
+ (NSArray *)filesWithFilePath:(NSString *)filePath isDirectory:(BOOL)isDirectory
{
    NSMutableArray *directions = [NSMutableArray array];
    NSArray *files = [[self class] subFilesPathsWithFilePath:filePath];
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

/**
 *  获取指定文件路径的所有文件夹
 *
 *  @param filePath 文件路径
 *
 *  @return NSArray
 */
+ (NSArray *)subfileDirectionsWithFilePath:(NSString *)filePath
{
    NSArray *directorys = [[self class] filesWithFilePath:filePath isDirectory:YES];
    return directorys;
}

/**
 *  获取指定文件路径的所有文件
 *
 *  @param filePath 文件路径
 *
 *  @return NSArray
 */
+ (NSArray *)subfilesWithFilePath:(NSString *)filePath
{
    NSArray *files = [[self class] filesWithFilePath:filePath isDirectory:NO];
    return files;
}

#pragma mark - 文件与目录的操作

/**
 *  文件，或文件夹是否存在
 *
 *  @param filepath 文件路径
 *
 *  @return BOOL
 */
+ (BOOL)isFileExists:(NSString *)filepath
{
    return [[NSFileManager defaultManager] fileExistsAtPath:filepath];
}

#pragma mark 文件写入

// 比如NSArray、NSDictionary、NSData、NSString都可以直接调用writeToFile方法写入文件
+ (BOOL)writeFileWithFilePath:(NSString *)filePath data:(id)data
{
    if (![self isFileExists:filePath])
    {
        filePath = [self newFilePathWithPath:filePath name:nil];
    }
    return [data writeToFile:filePath atomically:YES];
}

#pragma mark 文件数据

/**
 *  指定文件路径的二进制数据
 *
 *  @param filePath 文件路径
 *
 *  @return NSData
 */
+ (NSData *)readFileWithFilePath:(NSString *)filePath
{
    if ([self isFileExists:filePath])
    {
        return [[NSFileManager defaultManager] contentsAtPath:filePath];
    }
    return nil;
}

#pragma mark 文件创建

/**
 *  新建目录，或文件
 *
 *  @param filePath 新建目录所在的目录
 *  @param fileName 新建目录的目录名称，如xxx，或xxx/xxx，或xxx.png，或xxx/xx.png
 *
 *  @return NSString
 */
+ (NSString *)newFilePathWithPath:(NSString *)filePath name:(NSString *)fileName
{
    NSString *fileDirectory = [filePath stringByAppendingPathComponent:fileName];
    if ([self isFileExists:fileDirectory])
    {
        NSLog(@"<--exist-->%@", fileDirectory);
    }
    else
    {
        NSError *error;
        if (![[NSFileManager defaultManager] createDirectoryAtPath:fileDirectory withIntermediateDirectories:YES attributes:nil error:&error])
        {
            NSLog(@"create dir error: %@", error.debugDescription);
            return nil;
        }
    }
    return fileDirectory;
}

/**
 *  新建Document目录的目录
 *
 *  @param fileName 新建的目录名称
 *
 *  @return NSString
 */
+ (NSString *)newFilePathDocumentWithName:(NSString *)fileName
{
    return [self newFilePathWithPath:[self documentDirectoryPath] name:fileName];
}

/**
 *  新建Cache目录下的目录
 *
 *  @param fileName 新建的目录名称
 *
 *  @return NSString
 */
+ (NSString *)newFilePathCacheWithName:(NSString *)fileName
{
    return [self newFilePathWithPath:[self cacheDirectoryPath] name:fileName];
}

#pragma mark 文件删除

/**
 *  删除指定文件路径的文件
 *
 *  @param filepath 文件路径
 *
 *  @return BOOL
 */
+ (BOOL)deleteFileWithFilePath:(NSString *)filePath
{
    if ([self isFileExists:filePath])
    {
        return [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
    return NO;
}

/**
 *  删除指定目录的所有文件
 *
 *  @param directory 指定目录
 */
+ (void)deleteFileWithDirectory:(NSString *)directory
{
//    NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directory error:nil];
//    for (NSString *file in array)
//    {
//        if ([self isFileDirectoryWithFilePath:file])
//        {
//            // 目录时循环调用
//            [self deleteFileWithDirectory:file];
//        }
//        else
//        {
//            // 文件时进行删除
//            [self deleteFileWithFilePath:file];
//        }
//    }
    
    [self deleteFileWithFilePath:directory];
}

#pragma mark 文件复制

/**
 *  文件复制
 *
 *  @param fromPath 目标文件路径
 *  @param toPath   复制后文件路径
 *
 *  @return BOOL
 */
+ (BOOL)copyFileWithFilePath:(NSString *)fromPath toPath:(NSString *)toPath
{
    if ([self isFileExists:fromPath])
    {
        return [[NSFileManager defaultManager] copyItemAtPath:fromPath toPath:toPath error:nil];
    }
    return NO;
}

#pragma mark 文件移动

/**
 *  文件移动
 *
 *  @param fromPath 移动前位置
 *  @param toPath   移动后位置
 *
 *  @return BOOL
 */

+ (BOOL)moveFileWithFilePath:(NSString *)fromPath toPath:(NSString *)toPath
{
    if ([self isFileExists:fromPath])
    {
        return [[NSFileManager defaultManager] moveItemAtPath:fromPath toPath:toPath error:nil];
    }
    return NO;
}

#pragma mark 文件重命名

/**
 *  文件重新名
 *
 *  @param filePath 文件路径
 *  @param newName 文件新名称
 *
 *  @return BOOL
 */
+ (BOOL)renameFileWithFilePath:(NSString *)filePath newName:(NSString *)newName
{
    // 相当于移动文件，只是在相同目录下移动，所以实现了重命名
    NSString *newPath = [[filePath stringByDeletingLastPathComponent] stringByAppendingPathComponent:newName];
    return [self moveFileWithFilePath:filePath toPath:newPath];
}

#pragma mark - 文件信息

/**
 *  文件信息字典
 *
 *  @param filePath 文件路径
 *
 *  @return NSDictionary
 */
+ (NSDictionary *)fileAttributesWithFilePath:(NSString *)filePath
{
    if ([self isFileExists:filePath])
    {
        return [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
    }
    return nil;
}

/**
 *  单个文件的大小 double
 *
 *  @param filePath 文件路径
 *
 *  @return double
 */
+ (double)fileSizeNumberWithFilePath:(NSString *)filePath
{
    if ([self isFileExists:filePath])
    {
        return [[self fileAttributesWithFilePath:filePath] fileSize];
    }
    return 0.0;
}

/**
 *  文件类型转换：数值型转字符型
 *
 *  1MB = 1024KB 1KB = 1024B
 *
 *  @param fileSize 文件大小
 *
 *  @return NSString
 */
+ (NSString *)fileSizeStringConversionWithNumber:(double)fileSize
{
    NSString *message = nil;
    
    // 1MB = 1024KB 1KB = 1024B
    double size = fileSize;
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

/**
 *  单个文件的大小 String
 *
 *  @param filePath 文件路径
 *
 *  @return String
 */
+ (NSString *)fileSizeStringWithFilePath:(NSString *)filePath
{
    // 1MB = 1024KB 1KB = 1024B
    double size = [self fileSizeNumberWithFilePath:filePath];
    return [self fileSizeStringConversionWithNumber:size];
}

/**
 *  遍历文件夹大小 double
 *
 *  @param directory 指定目录
 *
 *  @return double
 */
+ (double)fileSizeTotalNumberWithDirectory:(NSString *)directory
{
    __block double size = 0.0;
    if ([self isFileExists:directory])
    {
        // 方法1
        NSArray *array = [self subPathsWithFilePath:directory];
    
        // 方法2
//        NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:directory];
//        NSMutableArray *array = [[NSMutableArray alloc] init];
//        NSString *path = nil;
//        while (path = [dirEnum nextObject])
//        {
//            [array addObject:path];
//        }
        
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *filePath = [directory stringByAppendingPathComponent:obj];
            if ([self isFileDirectoryWithFilePath:filePath])
            {
                [self fileSizeTotalNumberWithDirectory:filePath];
            }
            size += [self fileSizeNumberWithFilePath:filePath];
        }];
    }
    
    // 方法3
//    const char *folderPath = [directory cStringUsingEncoding:NSUTF8StringEncoding];
//    size = [self folderSizeAtPath:folderPath];
    
    return size;
}

/**
 *  遍历文件夹大小 NSString
 *
 *  @param directory 指定目录
 *
 *  @return NSString
 */
+ (NSString *)fileSizeTotalStringWithDirectory:(NSString *)directory
{
    double size = [self fileSizeTotalNumberWithDirectory:directory];
    return [self fileSizeStringConversionWithNumber:size];
}

// 遍历目录（注意添加头文件 #include <sys/stat.h> #include <dirent.h>）
+ (long long)folderSizeAtPath:(const char *)folderPath
{
    long long folderSize = 0;
    DIR *dir = opendir(folderPath);
    if (dir == NULL)
    {
        return 0;
    }
    struct dirent *child;
    while ((child = readdir(dir)) != NULL)
    {
        if (child->d_type == DT_DIR && (
                                        (child->d_name[0] == '.' && child->d_name[1] == 0) || // 忽略目录 .
                                        (child->d_name[0] == '.' && child->d_name[1] == '.' && child->d_name[2] == 0) // 忽略目录 ..
                                        ))
        {
            continue;
        }
        
        int folderPathLength = strlen(folderPath);
        char childPath[1024]; // 子文件的路径地址
        stpcpy(childPath, folderPath);
        if (folderPath[folderPathLength-1] != '/')
        {
            childPath[folderPathLength] = '/';
            folderPathLength++;
        }
        stpcpy(childPath+folderPathLength, child->d_name);
        childPath[folderPathLength + child->d_namlen] = 0;
        if (child->d_type == DT_DIR)
        {
            // directory
            folderSize += [self folderSizeAtPath:childPath]; // 递归调用子目录
            // 把目录本身所占的空间也加上
            struct stat st;
            if (lstat(childPath, &st) == 0)
            {
                folderSize += st.st_size;
            }
        }
        else if (child->d_type == DT_REG || child->d_type == DT_LNK)
        {
            // file or link
            struct stat st;
            if (lstat(childPath, &st) == 0)
            {
                folderSize += st.st_size;
            }
        }
    }
    return folderSize;
}


@end
