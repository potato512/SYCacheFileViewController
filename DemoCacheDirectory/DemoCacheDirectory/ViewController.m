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
    SYCacheFileViewController *cacheVC = [[SYCacheFileViewController alloc] init];
    [self.navigationController pushViewController:cacheVC animated:YES];
    
    NSString *path = [SYCacheFileManager homeDirectoryPath];
    NSLog(@"path = %@", path);
//
//    NSArray *array = [SYCacheDirectoryTools subPathsWithFilePath:path];
//    NSLog(@"array = %@", array);
//    for (id object in array)
//    {
//        NSLog(@"object = %@, class = %@", object, [object class]);
//    }
//    
//    NSArray *directorys = [SYCacheDirectoryTools fileDirectionsWithFilePath:path];
//    NSLog(@"directorys = %@", directorys);
//    NSArray *files = [SYCacheDirectoryTools filesWithFilePath:path];
//    NSLog(@"files = %@", files);
    
}

@end
