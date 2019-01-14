//
//  SYCacheFileViewController.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 17/6/27.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import "SYCacheFileViewController.h"
#import "SYCacheFileTable.h"
#import "SYCacheFileManager.h"
#import "SYCacheFileModel.h"
#import "SYCacheFileRead.h"

@interface SYCacheFileViewController ()

@property (nonatomic, strong) SYCacheFileTable *cacheTable;
@property (nonatomic, strong) SYCacheFileRead *fileRead;

@end

@implementation SYCacheFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = (_cacheTitle ? _cacheTitle : SYCacheFileTitle);
    
    [self setUI];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.1];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
        self.navigationController.navigationBar.translucent = NO;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)dealloc
{
    NSLog(@"<--- %@ 被释放了 --->", [self class]);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.fileRead) {
        [self.fileRead releaseSYCacheFileRead];
    }
}

#pragma mark - 视图

- (void)setUI
{
    typeof(self) __weak weakSelf = self;
    
    [self.view addSubview:self.cacheTable];
    self.cacheTable.frame = self.view.bounds;
    
    // 点击
    self.cacheTable.itemClick = ^(NSIndexPath *indexPath) {
        
        if (weakSelf.cacheTable.isEditing) {
            return ;
        }
        
        SYCacheFileModel *model = weakSelf.cacheArray[indexPath.row];
        // 路径
        NSString *path = model.filePath;
        // 类型
        SYCacheFileType type = model.fileType;
        if (SYCacheFileTypeUnknow == type) {
            // 标题
            NSString *title = model.fileName;
            // 子目录文件
            NSArray *files = [[SYCacheFileManager shareManager] fileModelsWithFilePath:path];
            SYCacheFileViewController *cacheVC = [SYCacheFileViewController new];
            cacheVC.cacheTitle = title;
            cacheVC.cacheArray = (NSMutableArray *)files;
            [weakSelf.navigationController pushViewController:cacheVC animated:YES];
        } else {
            [weakSelf.fileRead fileReadWithFilePath:path target:weakSelf];
        }
    };
    // 长按
    self.cacheTable.longPress = ^(NSIndexPath *indexPath) {
        //
        SYCacheFileModel *model = weakSelf.cacheArray[indexPath.row];
        SYCacheFileType type = model.fileType;
        //
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:cancelAction];
        if (type == SYCacheFileTypeVideo || type == SYCacheFileTypeImage) {
            UIAlertAction *cacheAction = [UIAlertAction actionWithTitle:@"保存到相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (type == SYCacheFileTypeVideo) {
                    UISaveVideoAtPathToSavedPhotosAlbum(model.filePath, weakSelf, @selector(video:didFinishSavingWithError: contextInfo:), nil);
                } else if (type == SYCacheFileTypeImage) {
                    UIImage *image = [UIImage imageWithContentsOfFile:model.filePath];
                    UIImageWriteToSavedPhotosAlbum(image, weakSelf, @selector(image:didFinishSavingWithError:contextInfo:), nil);
                }
            }];
            [alertController addAction:cacheAction];
        }
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // 系统数据不可删除
            if ([[SYCacheFileManager shareManager] isFileSystemWithFilePath:model.filePath]) {
                [[[UIAlertView alloc] initWithTitle:nil message:@"系统文件不能删除" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
                return;
            }
            
            // 删除数据：删除数组、删除本地文件/文件夹、刷新页面、发通知刷新文件大小统计
            // 删除数组
            [weakSelf.cacheArray removeObjectAtIndex:indexPath.row];
            // 删除本地文件/文件夹
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                BOOL isDelete = [SYCacheFileManager deleteFileWithDirectory:model.filePath];
                NSLog(@"删除：%@", (isDelete ? @"成功" : @"失败"));
            });
            // 刷新页面
            [weakSelf.cacheTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
        [alertController addAction:deleteAction];
        [weakSelf presentViewController:alertController animated:YES completion:NULL];
    };
}

#pragma mark - 视频图片保存

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = @"保存视频到相册成功";
    if (error) {
        message = @"保存视频到相册失败";
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:NULL];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = @"保存图片到相册成功";
    if (error) {
        message = @"保存图片到相册失败";
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:NULL];
}

#pragma mark - 响应

#pragma mark - 数据 

- (void)loadData
{
    if (self.cacheArray == nil) {
        // 初始化，首次显示总目录
        NSString *path = [SYCacheFileManager homeDirectoryPath];
        NSArray *array = [[SYCacheFileManager shareManager] fileModelsWithFilePath:path];
        self.cacheArray = [NSMutableArray arrayWithArray:array];
    }
    
    if (self.cacheArray && 0 < self.cacheArray.count) {
        self.cacheTable.cacheDatas = self.cacheArray;
        [self.cacheTable reloadData];
    }
}

#pragma mark - getter

- (SYCacheFileTable *)cacheTable
{
    if (_cacheTable == nil) {
        _cacheTable = [[SYCacheFileTable alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _cacheTable.backgroundColor = [UIColor clearColor];
        _cacheTable.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    return _cacheTable;
}

- (SYCacheFileRead *)fileRead
{
    if (_fileRead == nil) {
        _fileRead = [[SYCacheFileRead alloc] init];
    }
    return _fileRead;
}

@end
