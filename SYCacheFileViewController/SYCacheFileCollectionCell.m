//
//  SYCacheFileCollectionCell.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 2019/2/27.
//  Copyright © 2019年 zhangshaoyu. All rights reserved.
//

#import "SYCacheFileCollectionCell.h"
#import "SYCacheFileManager.h"

static CGFloat const originXY = 10.0;
static CGFloat const heightTitle = 40.0;
static CGFloat const heightDetail = 20.0;
static CGFloat const sizeImage = 40.0;

#define frameImage (CGRectMake((widthCollectionViewCell - sizeImage) / 2, originXY, sizeImage, sizeImage))

@interface SYCacheFileCollectionCell ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *typeImageView;
@property (nonatomic, strong) UILabel *typeTitleLabel;
@property (nonatomic, strong) UILabel *typeDetailLabel;

@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation SYCacheFileCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView.backgroundColor = [UIColor clearColor];
        
        [self setUI];
    }
    
    return self;
}

#pragma mark - 视图

- (void)dealloc
{
    [self removeNotificationDuration];
    
    NSLog(@"<-- %@ 被释放了-->" , [self class]);
}

#pragma mark - 视图

- (void)setUI
{
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, widthCollectionViewCell, heightCollectionViewCell)];
    _backView.backgroundColor = [UIColor whiteColor];
    _backView.layer.cornerRadius = 10.0;
    _backView.layer.masksToBounds = YES;
    [self.contentView addSubview:_backView];
    //
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    _backView.userInteractionEnabled = YES;
    [_backView addGestureRecognizer:longPressRecognizer];
    //
    self.typeImageView = [[UIImageView alloc] initWithFrame:frameImage];
    self.typeImageView.backgroundColor = [UIColor clearColor];
    self.typeImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.typeImageView.clipsToBounds = YES;
    [_backView addSubview:self.typeImageView];
    //
    CGFloat originYTitle = (originXY + sizeImage + originXY);
    CGFloat widthTitle = (self.backView.frame.size.width - originXY * 2);
    //
    self.typeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originXY, originYTitle, widthTitle, heightTitle)];
    self.typeTitleLabel.backgroundColor = [UIColor clearColor];
    self.typeTitleLabel.font = [UIFont systemFontOfSize:13.0];
    self.typeTitleLabel.textColor = [UIColor blackColor];
    self.typeTitleLabel.numberOfLines = 2;
    [_backView addSubview:self.typeTitleLabel];
    //
    self.typeDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(originXY, (originYTitle + heightTitle), widthTitle, heightDetail)];
    self.typeDetailLabel.backgroundColor = [UIColor clearColor];
    self.typeDetailLabel.font = [UIFont systemFontOfSize:11.0];
    self.typeDetailLabel.textColor = [UIColor lightGrayColor];
    [_backView addSubview:self.typeDetailLabel];
}

#pragma mark - methord

- (void)addNotificationDuration
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetAudioProgress:) name:SYCacheFileAudioDurationValueChangeNotificationName object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetAudioStop) name:SYCacheFileAudioStopNotificationName object:nil];
}

- (void)removeNotificationDuration
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)resetAudioProgress:(NSNotification *)notification
{
    if (self.model.fileType == SYCacheFileTypeAudio) {
        if (self.model.fileProgressShow) {
            self.progressView.hidden = NO;
            
            NSNumber *number = notification.object;
            NSTimeInterval progress = number.floatValue;
            self.model.fileProgress = progress;
            //
            [UIView animateWithDuration:0.5 animations:^{
                self.progressView.progress = progress;
                self.typeImageView.transform = CGAffineTransformMakeRotation(M_PI_2 * progress * 100);
            }];
        } else {
            
            if (self.progressView.hidden) {
                return;
            } else {
                [UIView animateWithDuration:0.5 animations:^{
                    self.progressView.hidden = YES;
                    self.progressView.progress = 0.0;
                    
                    self.typeImageView.transform = CGAffineTransformMakeRotation(0.0);
                }];
            }
        }
    }
}

- (void)resetAudioStop
{
    if (self.model.fileType == SYCacheFileTypeAudio) {
        [UIView animateWithDuration:0.5 animations:^{
            self.progressView.hidden = YES;
            self.progressView.progress = 0.0;
            //
            self.typeImageView.transform = CGAffineTransformMakeRotation(0.0);
        }];
    }
}

- (void)longPress:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        if (self.longPress) {
            self.longPress();
        }
    }
}

#pragma mark - getter

- (UIProgressView *)progressView
{
    if (_progressView == nil) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.progressTintColor = [UIColor redColor];
        CGFloat height = 3.0;
        _progressView.frame = CGRectMake(0.0, (_backView.frame.size.height - height), _backView.frame.size.width, height);
        [_backView addSubview:_progressView];
    }
    return _progressView;
}

#pragma mark - setter

- (void)setModel:(SYCacheFileModel *)model
{
    _model = model;
    if (_model) {
        // 图标
        UIImage *image = [[SYCacheFileManager shareManager] fileTypeImageWithFilePath:_model.filePath];
        self.typeImageView.image = image;
        
        // 标题
        NSString *nameText = _model.fileName;
        self.typeTitleLabel.text = nameText;
        // 大小
        NSString *sizeText = _model.fileSize;
        self.typeDetailLabel.text = sizeText;
        
        SYCacheFileType type = _model.fileType;
        if (type == SYCacheFileTypeAudio) {
            self.progressView.hidden = !_model.fileProgressShow;
            self.progressView.progress = _model.fileProgress;
            [self addNotificationDuration];
        } else {
            self.progressView.hidden = YES;
            [self removeNotificationDuration];
        }
    }
}

@end
