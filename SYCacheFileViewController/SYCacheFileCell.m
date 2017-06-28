//
//  SYCacheFileCell.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 17/6/27.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import "SYCacheFileCell.h"
#import "SYCacheFileManager.h"

static CGFloat const originXY = 10.0;
static CGFloat const heightTitle = 40.0;
static CGFloat const heightDetail = 20.0;

#define sizeImage (heightSYCacheDirectoryCell - originXY * 2)
#define frameImage (CGRectMake(originXY, originXY, (heightSYCacheDirectoryCell - originXY * 2), (heightSYCacheDirectoryCell - originXY * 2)))

#define widthScreen [UIScreen mainScreen].bounds.size.width

@interface SYCacheFileCell ()

/// 图标
@property (nonatomic, strong) UIImageView *typeImageView;
/// 标题
@property (nonatomic, strong) UILabel *typeTitleLabel;
/// 详情标题
@property (nonatomic, strong) UILabel *typeDetailLabel;

@end

@implementation SYCacheFileCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        
        self.separatorInset = UIEdgeInsetsMake(0.0, -50.0, 0.0, 0.0);;
        self.layoutMargins = UIEdgeInsetsMake(0.0, -50.0, 0.0, 0.0);
   
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  
        [self setUI];
    }
    return self;
}

#pragma mark - 视图

- (void)setUI
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, widthScreen, heightSYCacheDirectoryCell)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:backView];
    
    self.typeImageView = [[UIImageView alloc] initWithFrame:frameImage];
    self.typeImageView.backgroundColor = [UIColor clearColor];
    self.typeImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.typeImageView.clipsToBounds = YES;
    [backView addSubview:self.typeImageView];
    
    CGFloat originTitle = (originXY + sizeImage + originXY);
    CGFloat widthTitle = (widthScreen - originXY - sizeImage * 1.5 - originXY - originXY);
    
    self.typeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originTitle, 0.0, widthTitle, heightTitle)];
    self.typeTitleLabel.backgroundColor = [UIColor clearColor];
    self.typeTitleLabel.font = [UIFont systemFontOfSize:13.0];
    self.typeTitleLabel.textColor = [UIColor blackColor];
    self.typeTitleLabel.numberOfLines = 2;
    [backView addSubview:self.typeTitleLabel];
    
    self.typeDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(originTitle, (backView.frame.size.height - heightDetail - originXY / 2), widthTitle, heightDetail)];
    self.typeDetailLabel.backgroundColor = [UIColor clearColor];
    self.typeDetailLabel.font = [UIFont systemFontOfSize:11.0];
    self.typeDetailLabel.textColor = [UIColor lightGrayColor];
    [backView addSubview:self.typeDetailLabel];
}

#pragma mark - setter

- (void)setModel:(SYCacheFileModel *)model
{
    _model = model;
    if (_model)
    {
        // 图标
        UIImage *image = [SYCacheFileManager fileTypeImageWithFilePath:_model.filePath];
        self.typeImageView.image = image;
        
        // 标题
        NSString *nameText = _model.fileName;
        self.typeTitleLabel.text = nameText;
        // 大小
        NSString *sizeText = _model.fileSize;
        self.typeDetailLabel.text = sizeText;
    }
}

@end
