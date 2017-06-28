//
//  SYCacheFileManager.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 17/6/28.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SYCacheFileDefine.h"

@interface SYCacheFileManager : NSObject

/**
 *  默认显示文件
 *  视频：.avi、.dat、.mkv、.flv、.vob、.mp4、.m4v、.mpg、.mpeg、.mpe、.3pg、.mov、.swf、.wmv、.asf、.asx、.rm、.rmvb
 *  音频：.wav、.aif、.au、.mp3、.ram、.wma、.mmf、.amr、.aac、.flac、.midi、.mp3、.oog、.cd、.asf、.rm、.real、.ape、.vqf
 *  图片：.jpg、.png、.jpeg、.gif、.bmp
 *  文档：.txt、.sh、.doc、.docx、.xls、.xlsx、.pdf、.hlp、.wps、.rtf、.html、.iso、.rar、.zip、.exe、.mdf、.ppt、.pptx
 *  @return NSArray
 */
+ (NSArray *)fileTypeRead;

+ (SYCacheFileType)fileTypeReadWithFilePath:(NSString *)filePath;

#pragma mark - 文件名称与类型

/// 文件名称（如：hello.png）
+ (NSString *)fileNameWithFilePath:(NSString *)filePath;

/// 文件类型（如：.png）
+ (NSString *)fileTypeWithFilePath:(NSString *)filePath;

/// 文件类型图标
+ (UIImage *)fileTypeImageWithFilePath:(NSString *)filePath;


/// 获取程序的Home目录路径
+ (NSString *)homeDirectoryPath;

/// 获取目录列表里所有的文件名及文件夹名
+ (NSArray *)subPathsWithFilePath:(NSString *)filePath;

/// 判断一个目录是否是文件夹
+ (BOOL)isFileDirectoryWithFilePath:(NSString *)filePath;

/// 获取沙盒目录中指定目录的的所有文件夹，或文件
+ (NSArray *)filesWithFilePath:(NSString *)filePath isDirectory:(BOOL)isDirectory;

/// 获取沙盒目录中指定目录的的所有文件夹
+ (NSArray *)fileDirectionsWithFilePath:(NSString *)filePath;

/// 获取沙盒目录中指定目录的的所有文件夹
+ (NSArray *)filesWithFilePath:(NSString *)filePath;

#pragma mark - 文件与目录的操作

/// 是否存在该文件
+ (BOOL)isFileExists:(NSString *)filepath;

/// 单个文件的大小Number
+ (double)fileSizeNumberWithFilePath:(NSString *)filePath;

/// 单个文件的大小String
+ (NSString *)fileSizeStringWithFilePath:(NSString *)filePath;

@end
