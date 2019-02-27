//
//  SYCacheFileManager.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 17/6/28.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//  文件管理

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SYCacheFileDefine.h"
#import "SYCacheFileAudio.h"

@interface SYCacheFileManager : NSObject

+ (instancetype)shareManager;

/// 视频文件（如：.mp4）
@property (nonatomic, strong) NSArray *cacheVideoTypes;
/// 音频文件（如：.mp3）
@property (nonatomic, strong) NSArray *cacheAudioTypes;
/// 图片文件（如：.png）
@property (nonatomic, strong) NSArray *cacheImageTypes;
/// 文档文件（如：.txt）
@property (nonatomic, strong) NSArray *cacheDocumentTypes;

/// 音视频文件浏览模式（默认NO）
@property (nonatomic, assign) BOOL showDoucumentUI;
/// 图片浏览（默认 NO单图，YES多图）
@property (nonatomic, assign) BOOL showImageShuffling;
/// 被选中浏览图片名称（默认nil，多图时匹配并显示当前索引图片）
@property (nonatomic, strong) NSString *nameImage;

/**
 *  文件model
 *
 *  @param filePath 文件路径
 *
 *  @return NSArray
 */
- (NSArray *)fileModelsWithFilePath:(NSString *)filePath;

#pragma mark - 文件类型

/**
 *  判断是否是系统文件夹
 *
 *  @param filePath 文件路径
 *
 *  @return BOOL
 */
- (BOOL)isFileSystemWithFilePath:(NSString *)filePath;

/**
 *  筛选所需类型文件
 *
 *  @param type 文件类型
 *
 *  @return BOOL
 */
- (BOOL)isFilterFileTypeWithFileType:(NSString *)type;

/**
 *  判断文件类型
 *
 *  @param filePath 文件路径
 *
 *  @return SYCacheFileType
 */
- (SYCacheFileType)fileTypeReadWithFilePath:(NSString *)filePath;

#pragma mark - 文件类型对应图标

/**
 *  文件类型对应图标
 *
 *  @param filePath 文件路径
 *
 *  @return UIImage
 */
- (UIImage *)fileTypeImageWithFilePath:(NSString *)filePath;

#pragma mark - 文件名称与类型

/**
 *  文件名称（如：hello.png）
 *
 *  @param filePath 文件路径
 *
 *  @return NSString
 */
+ (NSString *)fileNameWithFilePath:(NSString *)filePath;

/**
 *  文件类型（如：.png）
 *
 *  @param filePath 文件路径
 *
 *  @return NSString
 */
+ (NSString *)fileTypeWithFilePath:(NSString *)filePath;

/**
 *  文件类型（如：png）
 *
 *  @param filePath 文件路径
 *
 *  @return NSString
 */
+ (NSString *)fileTypeExtensionWithFilePath:(NSString *)filePath;

#pragma mark - 文件目录

#pragma mark 系统目录

/**
 *  Home目录路径
 *
 *  @return NSString
 */
+ (NSString *)homeDirectoryPath;

/**
 *  Document目录路径
 *
 *  @return NSString
 */
+ (NSString *)documentDirectoryPath;

/**
 *  Cache目录路径
 *
 *  @return NSString
 */
+ (NSString *)cacheDirectoryPath;

/**
 *  Library目录路径
 *
 *  @return NSString
 */
+ (NSString *)libraryDirectoryPath;

/**
 *  Tmp目录路径
 *
 *  @return NSString
 */
+ (NSString *)tmpDirectoryPath;

#pragma mark 目录文件

/**
 *  获取目录列表里所有层级子目录下的所有文件，及目录
 *
 *  @param filePath 文件路径
 *
 *  @return NSArray
 */
+ (NSArray *)subPathsWithFilePath:(NSString *)filePath;

/**
 *  获取目录列表里当前层级的文件名及文件夹名
 *
 *  @param filePath 文件路径
 *
 *  @return NSArray
 */
+ (NSArray *)subFilesPathsWithFilePath:(NSString *)filePath;

/**
 *  判断一个文件路径是否是文件夹
 *
 *  @param filePath 文件路径
 *
 *  @return BOOL
 */
+ (BOOL)isFileDirectoryWithFilePath:(NSString *)filePath;

/**
 *  获取指定文件路径的所有文件夹
 *
 *  @param filePath 文件路径
 *
 *  @return NSArray
 */
+ (NSArray *)subfileDirectionsWithFilePath:(NSString *)filePath;

/**
 *  获取指定文件路径的所有文件
 *
 *  @param filePath 文件路径
 *
 *  @return NSArray
 */
+ (NSArray *)subfilesWithFilePath:(NSString *)filePath;

/**
 *  获取指定文件路径的所有图片文件
 *
 *  @param filePath 文件路径
 *
 *  @return NSArray
 */
+ (NSArray *)imagefilesWithFilePath:(NSString *)filePath;

#pragma mark - 文件与目录的操作

/**
 *  文件，或文件夹是否存在
 *
 *  @param filePath 文件路径
 *
 *  @return BOOL
 */
+ (BOOL)isFileExists:(NSString *)filePath;

#pragma mark 文件写入

// 比如NSArray、NSDictionary、NSData、NSString都可以直接调用writeToFile方法写入文件
+ (BOOL)writeFileWithFilePath:(NSString *)filePath data:(id)data;

#pragma mark 文件数据

/**
 *  指定文件路径的二进制数据
 *
 *  @param filePath 文件路径
 *
 *  @return NSData
 */
+ (NSData *)readFileWithFilePath:(NSString *)filePath;

#pragma mark 文件创建

/**
 *  新建目录，或文件
 *
 *  @param filePath 新建目录所在的目录
 *  @param fileName 新建目录的目录名称，如xxx，或xxx/xxx，或xxx.png，或xxx/xx.png
 *
 *  @return NSString
 */
+ (NSString *)newFilePathWithPath:(NSString *)filePath name:(NSString *)fileName;

/**
 *  新建Document目录的目录
 *
 *  @param fileName 新建的目录名称
 *
 *  @return NSString
 */
+ (NSString *)newFilePathDocumentWithName:(NSString *)fileName;

/**
 *  新建Cache目录下的目录
 *
 *  @param fileName 新建的目录名称
 *
 *  @return NSString
 */
+ (NSString *)newFilePathCacheWithName:(NSString *)fileName;

#pragma mark 文件删除

/**
 *  删除指定文件路径的文件
 *
 *  @param filePath 文件路径
 *
 *  @return BOOL
 */
+ (BOOL)deleteFileWithFilePath:(NSString *)filePath;

/**
 *  删除指定目录的所有文件
 *
 *  @param directory 指定目录
 *
 *  @return BOOL
 */
+ (BOOL)deleteFileWithDirectory:(NSString *)directory;

#pragma mark 文件复制

/**
 *  文件复制
 *
 *  @param fromPath 目标文件路径
 *  @param toPath   复制后文件路径
 *
 *  @return BOOL
 */
+ (BOOL)copyFileWithFilePath:(NSString *)fromPath toPath:(NSString *)toPath;

#pragma mark 文件移动

/**
 *  文件移动
 *
 *  @param fromPath 移动前位置
 *  @param toPath   移动后位置
 *
 *  @return BOOL
 */

+ (BOOL)moveFileWithFilePath:(NSString *)fromPath toPath:(NSString *)toPath;

#pragma mark 文件重命名

/**
 *  文件重命名
 *
 *  @param filePath 文件路径
 *  @param newName 文件新名称
 *
 *  @return BOOL
 */
+ (BOOL)renameFileWithFilePath:(NSString *)filePath newName:(NSString *)newName;

#pragma mark - 文件信息

/**
 *  文件信息字典
 *
 *  @param filePath 文件路径
 *
 *  @return NSDictionary
 */
+ (NSDictionary *)fileAttributesWithFilePath:(NSString *)filePath;

/**
 *  单个文件的大小 double
 *
 *  @param filePath 文件路径
 *
 *  @return double
 */
+ (double)fileSizeNumberWithFilePath:(NSString *)filePath;

/**
 *  文件类型转换：数值型转字符型
 *
 *  1MB = 1024KB 1KB = 1024B
 *
 *  @param fileSize 文件大小
 *
 *  @return NSString
 */
+ (NSString *)fileSizeStringConversionWithNumber:(double)fileSize;

/**
 *  单个文件的大小 String
 *
 *  @param filePath 文件路径
 *
 *  @return String
 */
+ (NSString *)fileSizeStringWithFilePath:(NSString *)filePath;

/**
 *  遍历文件夹大小 double
 *
 *  @param directory 指定目录
 *
 *  @return double
 */
+ (double)fileSizeTotalNumberWithDirectory:(NSString *)directory;

/**
 *  遍历文件夹大小 NSString
 *
 *  @param directory 指定目录
 *
 *  @return NSString
 */
+ (NSString *)fileSizeTotalStringWithDirectory:(NSString *)directory;


@end
