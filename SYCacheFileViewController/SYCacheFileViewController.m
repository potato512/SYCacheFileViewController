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
@property (nonatomic, assign) BOOL isFile;

@property (nonatomic, strong) SYCacheFileRead *fileRead;

@end

@implementation SYCacheFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = (_cacheTitle ? _cacheTitle : @"缓存目录");
    
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
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
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

#pragma mark - 视图

- (void)setUI
{
    typeof(self) __weak weakSelf = self;
    
    [self.view addSubview:self.cacheTable];
    self.cacheTable.frame = self.view.bounds;
    
    self.cacheTable.itemClick = ^(NSIndexPath *indexPath) {
        
        SYCacheFileModel *model = weakSelf.cacheArray[indexPath.row];
        // 路径
        NSString *path = model.filePath;
        // 类型
        SYCacheFileType type = model.fileType;
        if (SYCacheFileTypeUnknow == type)
        {
            // 标题
            NSString *title = model.fileName;
            
            // 子目录文件
            NSArray *array = [SYCacheFileManager filesWithFilePath:path];
            NSMutableArray *files = [NSMutableArray arrayWithCapacity:array.count];
            for (id object in array)
            {
                SYCacheFileModel *model = [SYCacheFileModel new];
                model.fileName = object;
                model.filePath = [path stringByAppendingPathComponent:object];
                
                NSString *typeName = [SYCacheFileManager fileTypeWithFilePath:model.filePath];
                if ([[SYCacheFileManager fileTypeRead] containsObject:typeName])
                {
                    [files addObject:model];
                }
            }
            
            SYCacheFileViewController *cacheVC = [SYCacheFileViewController new];
            cacheVC.isFile = YES;
            cacheVC.cacheTitle = title;
            cacheVC.cacheArray = files;
            [weakSelf.navigationController pushViewController:cacheVC animated:YES];
        }
        else
        {
            [weakSelf.fileRead fileReadWithFilePath:path target:weakSelf];
        }
    };
}

#pragma mark - 响应

#pragma mark - 数据 

- (void)loadData
{
    if (self.cacheArray == nil)
    {
        // 初始化，首次显示总目录
        NSString *path = [SYCacheFileManager homeDirectoryPath];
        NSArray *array = [SYCacheFileManager fileDirectionsWithFilePath:path];
        self.cacheArray = [NSMutableArray arrayWithCapacity:array.count];
        for (id object in array)
        {
            SYCacheFileModel *model = [SYCacheFileModel new];
            model.fileName = object;
            model.filePath = [path stringByAppendingPathComponent:object];
            
            [self.cacheArray addObject:model];
        }
        
        self.isFile = NO;
    }
    
    if (self.cacheArray && 0 < self.cacheArray.count)
    {
        self.cacheTable.cacheDatas = self.cacheArray;
        [self.cacheTable reloadData];
    }
}

#pragma mark - getter

- (SYCacheFileTable *)cacheTable
{
    if (_cacheTable == nil)
    {
        _cacheTable = [[SYCacheFileTable alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _cacheTable.backgroundColor = [UIColor clearColor];
        _cacheTable.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    return _cacheTable;
}

- (SYCacheFileRead *)fileRead
{
    if (_fileRead == nil)
    {
        _fileRead = [[SYCacheFileRead alloc] init];
    }
    return _fileRead;
}

@end
