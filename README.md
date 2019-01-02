# SYCacheFileViewController
缓存文件视图控制器


* 显示指定目录下的子目录及文件
  * 子目录可以继续点击进入下级子目录，及显示下级文件
  * 文件可以点击查看，根据不格式进行展示，如音频播放、视频播放、doc/excel/ppt/pdf/txt等打开
* 目录与文件的删除操作
  * 左滑出现删除按钮
  * 系统文件及文件夹不可删除


![SYCacheFileViewController.png](./images/SYCacheFileViewController.png)


# 效果图-目录与文件

![cacheFile_directory.gif](./images/cacheFile_directory.gif)

# 效果图-图片查看

![cacheFile_image.gif](./images/cacheFile_image.gif)

# 效果图-视频播放

![cacheFile_video.gif](./images/cacheFile_video.gif)

# 效果图-音频播放

![cacheFile_audio.gif](./images/cacheFile_audio.gif)

# 效果图-文档查看-word/excel/ppt/pdf

![cacheFile_File01.gif](./images/cacheFile_File01.gif)

# 效果图-文档查看：txt/htm/……

![cacheFile_File02.gif](./images/cacheFile_File02.gif)


# 效果图-删除操作（系统文件不可删除）

![cacheFile_delete.gif](./images/cacheFile_delete.gif)

![cacheFile_delete.png](./images/cacheFile_delete.png)



* 使用介绍
  * 自动导入：使用命令`pod 'SYCacheFileViewController'`导入到项目中
  * 手动导入：或下载源码后，将源码添加到项目中
  
  
# 使用示例
~~~ javascript

// 导入头文件
#import "SYCacheFileViewController.h"

~~~

~~~ javascript

// 实例化 使用默认路径home
SYCacheFileViewController *cacheVC = [[SYCacheFileViewController alloc] init];
[self.navigationController pushViewController:cacheVC animated:YES];

~~~

~~~ javascript

// 自定义
SYCacheFileViewController *cacheVC = [[SYCacheFileViewController alloc] init];
// 指定文件格式
[SYCacheFileManager shareManager].cacheDocumentArray = @[@".pages", @"wps", @".xls", @".pdf", @".rar"];

// 指定目录，或默认目录
NSString *path = [SYCacheFileManager documentDirectoryPath];
NSArray *array = [[SYCacheFileManager shareManager] fileModelsWithFilePath:path];
cacheVC.cacheArray = [NSMutableArray arrayWithArray:array];

// 其它属性设置
cacheVC.cacheTitle = @"我的缓存文件";

//
[self.navigationController pushViewController:cacheVC animated:YES];
~~~




# 修改完善
* 20190102
  * 版本号：1.2.0
  * 修改完善
    * 区分音视频播放模式
    * 单独窗口播放音乐
    * 单独窗口播放视频
    * 播放前文件异常判断

* 20181120
  * 版本号：1.1.0
  * 修改完善
    * 添加自定义文件格式

* 20180731
  * 版本号：1.0.0
  * 完善方法
    * 文件复制
    * 文件移动
    * 文件重命名
    
* 待完善
  * 文件删除后文件目录大小改变



