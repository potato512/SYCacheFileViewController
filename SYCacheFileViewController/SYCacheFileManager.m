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

@interface SYCacheFileManager ()

/// 视频文件
@property (nonatomic, strong) NSMutableArray *cacheVideoArrayUsing;
/// 音频文件
@property (nonatomic, strong) NSMutableArray *cacheAudioArrayUsing;
/// 图片文件
@property (nonatomic, strong) NSMutableArray *cacheImageArrayUsing;
/// 文档文件
@property (nonatomic, strong) NSMutableArray *cacheDocumentArrayUsing;

/// 不能删除系统文件及文件夹
@property (nonatomic, strong) NSArray *cacheSystemArrayUsing;

@end

@implementation SYCacheFileManager


+ (instancetype)shareManager
{
    static SYCacheFileManager *fileManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fileManager = [[SYCacheFileManager alloc] init];
    });
    return fileManager;
}

#pragma mark - getter

- (NSMutableArray *)cacheVideoArrayUsing
{
    if (_cacheVideoArrayUsing == nil) {
        _cacheVideoArrayUsing = [[NSMutableArray alloc] initWithObjects:@".avi", @".dat", @".mkv", @".flv", @".vob", @".mp4", @".m4v", @".mpg", @".mpeg", @".mpe", @".3pg", @".mov", @".swf", @".wmv", @".asf", @".asx", @".rm", @".rmvb", nil];
    }
    return _cacheVideoArrayUsing;
}

- (NSMutableArray *)cacheAudioArrayUsing
{
    if (_cacheAudioArrayUsing == nil) {
        _cacheAudioArrayUsing = [[NSMutableArray alloc] initWithObjects:@".wav", @".aif", @".au", @".mp3", @".ram", @".wma", @".mmf", @".amr", @".aac", @".flac", @".midi", @".mp3", @".oog", @".cd", @".asf", @".rm", @".real", @".ape", @".vqf", nil];
    }
    return _cacheAudioArrayUsing;
}

- (NSMutableArray *)cacheImageArrayUsing
{
    if (_cacheImageArrayUsing == nil) {
        _cacheImageArrayUsing = [[NSMutableArray alloc] initWithObjects:@".jpg", @".png", @".jpeg", @".gif", @".bmp", nil];
    }
    return _cacheImageArrayUsing;
}

- (NSMutableArray *)cacheDocumentArrayUsing
{
    if (_cacheDocumentArrayUsing == nil) {
        _cacheDocumentArrayUsing = [[NSMutableArray alloc] initWithObjects:@".txt", @".sh", @".doc", @".docx", @".xls", @".xlsx", @".pdf", @".hlp", @".wps", @".rtf", @".html", @".htm", @".iso", @".rar", @".zip", @".exe", @".mdf", @".ppt", @".pptx", @".apk", nil];
    }
    return _cacheDocumentArrayUsing;
}

- (NSArray *)cacheSystemArrayUsing
{
    if (_cacheSystemArrayUsing == nil) {
        _cacheSystemArrayUsing = @[@"/tmp", @"/Library/Preferences", @"/Library/Caches/Snapshots", @"/Library/Caches", @"/Library", @"/Documents", @"/Snapshots", @"/SystemData"];
    }
    return _cacheSystemArrayUsing;
}

#pragma mark - setter

- (void)setCacheVideoTypes:(NSArray *)cacheVideoTypes
{
    _cacheVideoTypes = cacheVideoTypes;
    if (_cacheVideoTypes.count > 0) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:_cacheVideoTypes];
        [array addObjectsFromArray:self.cacheVideoArrayUsing];
        NSSet *set = [NSSet setWithArray:array];
        self.cacheVideoArrayUsing = (NSMutableArray *)[set allObjects];
    }
}

- (void)setCacheAudioTypes:(NSArray *)cacheAudioTypes
{
    _cacheAudioTypes = cacheAudioTypes;
    if (_cacheAudioTypes.count > 0) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:_cacheAudioTypes];
        [array addObjectsFromArray:self.cacheAudioArrayUsing];
        NSSet *set = [NSSet setWithArray:array];
        self.cacheAudioArrayUsing = (NSMutableArray *)[set allObjects];
    }
}

- (void)setCacheImageTypes:(NSArray *)cacheImageTypes
{
    _cacheImageTypes = cacheImageTypes;
    if (_cacheImageTypes.count > 0) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:_cacheImageTypes];
        [array addObjectsFromArray:self.cacheImageArrayUsing];
        NSSet *set = [NSSet setWithArray:array];
        self.cacheImageArrayUsing = (NSMutableArray *)[set allObjects];
    }
}

- (void)setCacheDocumentTypes:(NSArray *)cacheDocumentTypes
{
    _cacheDocumentTypes = cacheDocumentTypes;
    if (_cacheDocumentTypes.count > 0) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:_cacheDocumentTypes];
        [array addObjectsFromArray:self.cacheDocumentArrayUsing];
        NSSet *set = [NSSet setWithArray:array];
        self.cacheDocumentArrayUsing = (NSMutableArray *)[set allObjects];
    }
}

#pragma mark -

/**
 *  文件model
 *
 *  @param filePath 文件路径
 *
 *  @return NSArray
 */
- (NSArray *)fileModelsWithFilePath:(NSString *)filePath
{
    NSArray *array = [SYCacheFileManager subFilesPathsWithFilePath:filePath];
    NSMutableArray *fileArray = [NSMutableArray arrayWithCapacity:array.count];
    for (id object in array) {
        SYCacheFileModel *model = [SYCacheFileModel new];
        model.fileName = object;
        model.filePath = [filePath stringByAppendingPathComponent:object];
        
        SYCacheFileType type = [self fileTypeReadWithFilePath:model.filePath];
        if (SYCacheFileTypeUnknow == type) {
            // 过滤系统文件夹
            // 原方法
//            NSRange range = [model.filePath rangeOfString:@"." options:NSBackwardsSearch];
//            if (range.location != NSNotFound) {
//                continue;
//            }
            if ([model.fileName hasPrefix:@"."] || ![SYCacheFileManager isFileDirectoryWithFilePath:model.filePath]) {
                continue;
            }
        } else {
            // 过滤系统文件
            NSString *typeName = [SYCacheFileManager fileTypeWithFilePath:model.filePath];
            if (![self isFilterFileTypeWithFileType:typeName]) {
                continue;
            }
        }
        
        [fileArray addObject:model];
    }

    return fileArray;
}


#pragma mark - 文件类型

- (NSArray *)fileTypeArray
{
    NSMutableArray *array = [NSMutableArray array];
    [array addObjectsFromArray:self.cacheVideoArrayUsing];
    [array addObjectsFromArray:self.cacheAudioArrayUsing];
    [array addObjectsFromArray:self.cacheImageArrayUsing];
    [array addObjectsFromArray:self.cacheDocumentArrayUsing];
    
    return array;
}

/**
 *  判断是否是系统文件夹
 *
 *  @param filePath 文件路径
 *
 *  @return BOOL
 */
- (BOOL)isFileSystemWithFilePath:(NSString *)filePath
{
    for (NSString *file in self.cacheSystemArrayUsing) {
        if ([filePath hasSuffix:file]) {
            return YES;
            break;
        }
    }
    return NO;
}

/**
 *  筛选所需类型文件
 *
 *  @param type 文件类型
 *
 *  @return BOOL
 */
- (BOOL)isFilterFileTypeWithFileType:(NSString *)type
{
    if ([self.fileTypeArray containsObject:type]) {
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
- (SYCacheFileType)fileTypeReadWithFilePath:(NSString *)filePath
{
    NSString *fileType = [SYCacheFileManager fileTypeWithFilePath:filePath];
    fileType = fileType.lowercaseString;
    SYCacheFileType type = SYCacheFileTypeUnknow;
    if ([self.cacheVideoArrayUsing containsObject:fileType]) {
        type = SYCacheFileTypeVideo;
    } else if ([self.cacheAudioArrayUsing containsObject:fileType]) {
        type = SYCacheFileTypeAudio;
    } else if ([self.cacheImageArrayUsing containsObject:fileType]) {
        type = SYCacheFileTypeImage;
    } else if ([self.cacheDocumentArrayUsing containsObject:fileType]) {
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
- (UIImage *)fileTypeImageWithFilePath:(NSString *)filePath
{
    UIImage *image = [UIImage imageNamed:@"folder_cacheFile"];
    if (filePath && 0 < filePath.length) {
        SYCacheFileType type = [self fileTypeReadWithFilePath:filePath];
        if (SYCacheFileTypeUnknow == type) {
            image = [UIImage imageNamed:@"folder_cacheFile"];
        } else {
            NSString *fileType = [SYCacheFileManager fileTypeWithFilePath:filePath];
            fileType = fileType.lowercaseString;
            if ([self.cacheImageArrayUsing containsObject:fileType]) {
                image = [UIImage imageNamed:@"image_cacheFile"];
            } else if ([self.cacheVideoArrayUsing containsObject:fileType]) {
                image = [UIImage imageNamed:@"video_cacheFile"];
            } else if ([self.cacheAudioArrayUsing containsObject:fileType]) {
                image = [UIImage imageNamed:@"audio_cacheFile"];
            } else if ([@[@".doc", @".docx"] containsObject:fileType]) {
                image = [UIImage imageNamed:@"doc_cacheFile"];
            } else if ([@[@".xls", @".xlsx"] containsObject:fileType]) {
                image = [UIImage imageNamed:@"xls_cacheFile"];
            } else if ([@[@".pdf"] containsObject:fileType]) {
                image = [UIImage imageNamed:@"pdf_cacheFile"];
            } else if ([@[@".ppt", @".pptx"] containsObject:fileType]) {
                image = [UIImage imageNamed:@"ppt_cacheFile"];
            } else if ([@[@".zip", @".rar", @".iso"] containsObject:fileType]) {
                image = [UIImage imageNamed:@"zip_cacheFile"];
            } else if ([@[@".apk"] containsObject:fileType]) {
                image = [UIImage imageNamed:@"apk_cacheFile"];
            } else {
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
//    if ([self isFileExists:filePath]) {
//        NSRange range = [filePath rangeOfString:@"/" options:NSBackwardsSearch];
//        if (range.location != NSNotFound) {
//            NSString *text = [filePath substringFromIndex:(range.location + range.length)];
//            return text;
//        }
//
//        return nil;
//    }
//
//    return nil;
    
    NSString *text = filePath.lastPathComponent;
    return text;
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
//    if ([self isFileExists:filePath]) {
//        NSRange range = [filePath rangeOfString:@"." options:NSBackwardsSearch];
//        if (range.location != NSNotFound) {
//            NSString *text = [filePath substringFromIndex:(range.location)];
//            text = text.lowercaseString;
//            return text;
//        }
//
//        return nil;
//    }
//
//    return nil;
    
    NSString *text = filePath.pathExtension;
    text = [NSString stringWithFormat:@".%@", text];
    return text;
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
//    if ([self isFileExists:filePath]) {
//        NSString *text = filePath.pathExtension;
//        return text;
//    }
//
//    return nil;
    
    NSString *text = filePath.pathExtension;
    return text;
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
    for (id object in files) {
        BOOL isDir = [[self class] isFileDirectoryWithFilePath:object];
        if (isDirectory) {
            if (isDir) {
                [directions addObject:object];
            }
        } else {
            if (!isDir) {
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

/**
 *  获取指定文件路径的所有图片文件
 *
 *  @param filePath 文件路径
 *
 *  @return NSArray
 */
+ (NSArray *)imagefilesWithFilePath:(NSString *)filePath
{
    NSArray *files = [[self class] filesWithFilePath:filePath isDirectory:NO];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [files enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *file = (NSString *)obj;
        SYCacheFileType type = [[SYCacheFileManager shareManager] fileTypeReadWithFilePath:file];
        if (type == SYCacheFileTypeImage) {
            file = [filePath stringByAppendingPathComponent:file];
            [array addObject:file];
        }
    }];
    return array;
}

#pragma mark - 文件与目录的操作

/**
 *  文件，或文件夹是否存在
 *
 *  @param filePath 文件路径
 *
 *  @return BOOL
 */
+ (BOOL)isFileExists:(NSString *)filePath
{
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

#pragma mark 文件写入

// 比如NSArray、NSDictionary、NSData、NSString都可以直接调用writeToFile方法写入文件
+ (BOOL)writeFileWithFilePath:(NSString *)filePath data:(id)data
{
    if (![self isFileExists:filePath]) {
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
    if ([self isFileExists:filePath]) {
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
    if ([self isFileExists:fileDirectory]) {
        NSLog(@"<--exist-->%@", fileDirectory);
    } else {
        NSError *error;
        BOOL isSuccessDirectory = [[NSFileManager defaultManager] createDirectoryAtPath:fileDirectory withIntermediateDirectories:YES attributes:nil error:&error];
        if (!isSuccessDirectory) {
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
 *  @param filePath 文件路径
 *
 *  @return BOOL
 */
+ (BOOL)deleteFileWithFilePath:(NSString *)filePath
{
    if ([self isFileExists:filePath]) {
        return [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
    return NO;
}

/**
 *  删除指定目录的所有文件
 *
 *  @param directory 指定目录
 *
 *  @return BOOL
 */
+ (BOOL)deleteFileWithDirectory:(NSString *)directory;
{
    return [self deleteFileWithFilePath:directory];
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
    BOOL isSuccess = NO;
    BOOL isExists = [[NSFileManager defaultManager] fileExistsAtPath:fromPath];
    if (isExists) {
        isSuccess = [[NSFileManager defaultManager] copyItemAtPath:fromPath toPath:toPath error:nil];
    }
    return isSuccess;
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
    BOOL isSuccess = NO;
    BOOL isExists = [[NSFileManager defaultManager] fileExistsAtPath:fromPath];
    if (isExists) {
        isSuccess = [[NSFileManager defaultManager] moveItemAtPath:fromPath toPath:toPath error:nil];
    }
    return isSuccess;
}

#pragma mark 文件重命名

/**
 *  文件重命名
 *
 *  @param filePath 文件路径
 *  @param newName 文件新名称
 *
 *  @return BOOL
 */
+ (BOOL)renameFileWithFilePath:(NSString *)filePath newName:(NSString *)newName
{
    BOOL isSuccess = NO;
    BOOL isExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if (isExists) {
        NSString *fileName = filePath.lastPathComponent;
        NSString *filePathTmp = [filePath substringToIndex:(filePath.length - fileName.length)];
        filePathTmp = [filePathTmp stringByAppendingPathComponent:newName];
        isSuccess = [[NSFileManager defaultManager] moveItemAtPath:filePath toPath:filePathTmp error:nil];
    }
    return isSuccess;
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
    if ([self isFileExists:filePath]) {
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
    if ([self isFileExists:filePath]) {
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
    if (size > (1024 * 1024)) {
        size = size / (1024 * 1024);
        message = [NSString stringWithFormat:@"%.2fM", size];
    } else if (size > 1024) {
        size = size / 1024;
        message = [NSString stringWithFormat:@"%.2fKB", size];
    } else if (size > 0.0) {
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
    if ([self isFileExists:directory]) {
        NSArray *array = [self subPathsWithFilePath:directory];
        
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *filePath = [directory stringByAppendingPathComponent:obj];
            if ([self isFileDirectoryWithFilePath:filePath])
            {
                [self fileSizeTotalNumberWithDirectory:filePath];
            }
            size += [self fileSizeNumberWithFilePath:filePath];
        }];
    }
    
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

@end
