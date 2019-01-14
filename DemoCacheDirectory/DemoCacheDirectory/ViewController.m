//
//  ViewController.m
//  DemoCacheDirectory
//
//  Created by zhangshaoyu on 17/6/27.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import "ViewController.h"
#import "SYCacheFileViewController.h"
#import "SYCacheFileManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"缓存目录";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cache" style:UIBarButtonItemStyleDone target:self action:@selector(buttonClick)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonClick
{
    // 默认
//    SYCacheFileViewController *cacheVC = [[SYCacheFileViewController alloc] init];
//    [self.navigationController pushViewController:cacheVC animated:YES];
//
//    NSString *path = [SYCacheFileManager homeDirectoryPath];
//    NSLog(@"path = %@", path);

    // 自定义
    SYCacheFileViewController *cacheVC = [[SYCacheFileViewController alloc] init];
    // 指定文件格式
    [SYCacheFileManager shareManager].cacheDocumentTypes = @[@".pages", @"wps", @".xls", @".pdf", @".rar"];
//    [SYCacheFileManager shareManager].showDoucumentUI = YES;
    // 指定目录，或默认目录
    NSString *path = [SYCacheFileManager documentDirectoryPath];
    NSArray *array = [[SYCacheFileManager shareManager] fileModelsWithFilePath:path];
    cacheVC.cacheArray = [NSMutableArray arrayWithArray:array];
    // 其它属性设置
    cacheVC.cacheTitle = @"我的缓存文件";
    //
    [self.navigationController pushViewController:cacheVC animated:YES];
    
    
//    path = [SYCacheFileManager documentDirectoryPath];
//    NSLog(@"path = %@", path);
//    
//    path = [SYCacheFileManager cacheDirectoryPath];
//    NSLog(@"path = %@", path);
//    
//    path = [SYCacheFileManager libraryDirectoryPath];
//    NSLog(@"path = %@", path);
//    
//    path = [SYCacheFileManager tmpDirectoryPath];
//    NSLog(@"path = %@", path);
//    
//    path = [SYCacheFileManager newFilePathWithPath:[SYCacheFileManager tmpDirectoryPath] name:@"Tmp001"];
//    NSLog(@"path = %@", path);
//    
//    path = [SYCacheFileManager newFilePathCacheWithName:@"Tmp002"];
//    NSLog(@"path = %@", path);
//    
//    path = [SYCacheFileManager newFilePathDocumentWithName:@"Document001"];
//    NSLog(@"path = %@", path);
//    
//    path = [SYCacheFileManager newFilePathWithPath:[SYCacheFileManager tmpDirectoryPath] name:@"Tmp001.png"];
//    NSLog(@"path = %@", path);
}

@end
