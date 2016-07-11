//
//  FDTableViewCell.m
//  FlowLayoutCell
//
//  Created by depa on 15/4/9.
//  Copyright (c) 2015年 depa. All rights reserved.
//

#import "FDTableViewCell.h"
#import "FDListEntity.h"
#import "UIView+DPCollapsibleConstraints.h"
#import "Masonry.h"

@interface FDTableViewCell ()

@property (strong, nonatomic) UILabel     *titleLabel;
@property (strong, nonatomic) UILabel     *contentLabel;
@property (strong, nonatomic) UIView      *audioBubble;
@property (strong, nonatomic) UIImageView *thumbImageView;

@end

@implementation FDTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if(self)
    {
        self.backgroundColor = [UIColor whiteColor];

        self.titleLabel.dp_autoCollapse     = YES;

        self.contentLabel.dp_autoCollapse   = YES;
        self.contentLabel.dp_NSLayoutAttributes = @[@(NSLayoutAttributeTop)];

        self.thumbImageView.dp_autoCollapse = YES;
        self.thumbImageView.dp_NSLayoutAttributes = @[@(NSLayoutAttributeTop),@(NSLayoutAttributeBottom)];

        self.audioBubble.dp_EnabelManualCollapsed = YES;
        self.audioBubble.dp_NSLayoutAttributes = @[@(NSLayoutAttributeTop),@(NSLayoutAttributeHeight)];

        [self addChildSubViews];
        [self addChildConstraint];
    }
    return self;
}

-(void)addChildSubViews
{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.audioBubble];
    [self.contentView addSubview:self.thumbImageView];
}

-(void)addChildConstraint
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10.0f);
        make.top.equalTo(self.contentView).offset(8.0f);
    }];

    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10.0f);
        make.right.equalTo(self.contentView).offset(-10.0f);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10.0f);
    }];

    [self.audioBubble mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10.0f);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(10.0f);
        make.width.equalTo(@180.0f);
        make.height.equalTo(@36.0f);
    }];

    [self.thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10.0f);
        make.top.equalTo(self.audioBubble.mas_bottom).offset(10.0f);
        make.bottom.equalTo(self.contentView).offset(-10.0f);
    }];

}

- (void)setEntity:(FDListEntity *)entity
{
    _entity = entity;

    self.titleLabel.text = entity.title;
    self.contentLabel.text = entity.content;
    if (entity.imageName.length) {
        self.thumbImageView.image = [UIImage imageNamed:entity.imageName];
    } else {
        self.thumbImageView.image = nil;
    }
    self.audioBubble.dp_collapsed = !entity.hasAudioClip;
}

-(UILabel *)titleLabel
{
    if(!_titleLabel)
    {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.numberOfLines = 1;
        _titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    }

    return _titleLabel;
}

-(UILabel *)contentLabel
{
    if(!_contentLabel)
    {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = [UIFont systemFontOfSize:13.0f];
    }

    return _contentLabel;
}

-(UIView *)audioBubble
{
    if(!_audioBubble)
    {
        _audioBubble = [[UIView alloc]init];
        _audioBubble.backgroundColor = [UIColor lightGrayColor];
        _audioBubble.layer.cornerRadius = 5.0f;
        _audioBubble.layer.masksToBounds = YES;

        UILabel* textLabel = [[UILabel alloc]init];
        textLabel.alpha = 0.7;
        [_audioBubble addSubview:textLabel];
        textLabel.text = @"3''";
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_audioBubble);
            make.left.equalTo(_audioBubble).offset(5.0f);
        }];
    }

    return _audioBubble;
}

-(UIView *)thumbImageView
{
    if(!_thumbImageView)
    {
        _thumbImageView = [[UIImageView alloc]init];
    }

    return _thumbImageView;
}

@end
