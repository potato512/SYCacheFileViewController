//
//  SYCacheFileImage.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 2019/2/12.
//  Copyright © 2019年 zhangshaoyu. All rights reserved.
//

#import "SYCacheFileImage.h"

static CGFloat const scaleMini = 1.0;
static CGFloat const scaleMax = 3.0;

@interface SYCacheScaleImage () <UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation SYCacheScaleImage

- (void)showImageWithFilePath:(NSString *)filePath
{
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:filePath];
    if (self.imageView == nil) {
        UIView *superView = self;
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:superView.bounds];
        scrollView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:1.0];
        scrollView.delegate = self;
        [scrollView setMinimumZoomScale:scaleMini];
        [scrollView setMaximumZoomScale:scaleMax];
        [superView addSubview:scrollView];
        //
        self.imageView = [[UIImageView alloc] init];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        // 隐藏
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideClick:)];
        self.imageView.userInteractionEnabled = YES;
        [self.imageView addGestureRecognizer:tapRecognizer];
        //
        self.imageView.frame = scrollView.bounds;
        [scrollView addSubview:self.imageView];
    }
    self.imageView.image = image;
}

- (void)hideClick:(UITapGestureRecognizer *)recognizer
{
    if (self.imageTap) {
        //
        UIScrollView *scrollView = (UIScrollView *)self.imageView.superview;
        [scrollView setZoomScale:scaleMini];
        //
        self.imageTap();
    }
}

- (void)showInCenter:(UIScrollView *)scrollView imageView:(UIImageView *)imageView
{
    // 居中显示
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ? (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height) ?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    for (UIView *view in scrollView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            UIImageView *imageView = (UIImageView *)view;
            [self showInCenter:scrollView imageView:imageView];
        }
    }
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    // 缩放效果 放大或缩小
    if (scrollView.minimumZoomScale >= scale) {
        [scrollView setZoomScale:scaleMini animated:YES];
    }
    if (scrollView.maximumZoomScale <= scale) {
        [scrollView setZoomScale:scaleMax animated:YES];
    }
}

@end
#pragma mark -

@interface SYCacheFileImage () <UIScrollViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation SYCacheFileImage

- (instancetype)init
{
    self = [super init];
    if (self) {
        UIView *superView = [UIApplication sharedApplication].delegate.window;
        self.frame = CGRectMake(0.0, superView.frame.size.height, superView.frame.size.width, superView.frame.size.height);
        [superView addSubview:self];
        [self addSubview:self.scrollView];
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)reloadImages
{
    if (self.images && self.images.count > 0) {
        //
        [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        //
        self.titleLabel.text = [NSString stringWithFormat:@"%@/%@", @(self.index + 1), @(self.images.count)];
        //
        SYCacheFileImage __weak *weakSelf = self;
        [self.images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *filePath = (NSString *)obj;
            CGRect rect = CGRectMake((weakSelf.scrollView.frame.size.width * idx), 0.0, weakSelf.scrollView.frame.size.width, weakSelf.frame.size.height);
            
            SYCacheScaleImage *imageView = [[SYCacheScaleImage alloc] initWithFrame:rect];
            [weakSelf.scrollView addSubview:imageView];
            [imageView showImageWithFilePath:filePath];
            imageView.imageTap = ^{
                [UIView animateWithDuration:0.3 animations:^{
                    weakSelf.frame = CGRectMake(0.0, weakSelf.superview.frame.size.height, weakSelf.superview.frame.size.width, weakSelf.superview.frame.size.height);
                } completion:^(BOOL finished) {
                    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
                }];
            };
        }];
        
        //
        self.scrollView.contentSize = CGSizeMake(self.images.count * self.scrollView.frame.size.width, self.scrollView.frame.size.height);

        //
        self.scrollView.scrollEnabled = NO;
        self.titleLabel.hidden = YES;
        if (self.images.count > 1) {
            self.titleLabel.hidden = NO;
            self.scrollView.scrollEnabled = YES;
            [self.scrollView setContentOffset:CGPointMake((self.scrollView.frame.size.width * self.index), 0.0)];
        }

        //
        if (self.frame.origin.y != 0.0) {
            [UIView animateWithDuration:0.3 animations:^{
                self.frame = CGRectMake(0.0, 0.0, self.superview.frame.size.width, self.superview.frame.size.height);
            } completion:^(BOOL finished) {
                [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
            }];
        }
    }
}

#pragma mark - getter

- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.backgroundColor = [UIColor blackColor];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        CGFloat top = 0.0;
        if (@available(iOS 11.0, *)) {
            UIWindow *window = [UIApplication sharedApplication].delegate.window;
            if (window.safeAreaInsets.bottom > 0.0) {
                top = 34.0;
            }
        }
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, top, self.bounds.size.width, 40.0)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

#pragma mark -

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger page = (scrollView.contentOffset.x / scrollView.frame.size.width);
    self.titleLabel.text = [NSString stringWithFormat:@"%@/%@", @(page + 1), @(self.images.count)];
}

@end
