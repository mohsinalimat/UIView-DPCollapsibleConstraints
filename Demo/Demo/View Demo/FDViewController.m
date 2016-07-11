//
//  FDViewController.m
//  Demo
//
//  Created by depa on 15/4/22.
//  Copyright (c) 2015年 depa. All rights reserved.
//

#import "FDViewController.h"
#import "UIView+DPCollapsibleConstraints.h"
#import "Masonry.h"

@interface FDViewController ()
@property(nonatomic,strong) UILabel*     logoLabel;
@property(nonatomic,strong) UIButton*    expandBtn;
@property(nonatomic,strong) UILabel*     collapseLabel;
@property(nonatomic,strong) UIImageView* logoImageView;
@property(nonatomic, assign) BOOL        expanding;
@end

@implementation FDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Default value
    self.logoImageView.dp_EnabelManualCollapsed = YES;
    self.logoImageView.dp_collapsed = YES;

    self.logoImageView.dp_NSLayoutAttributes = @[@(NSLayoutAttributeTop),@(NSLayoutAttributeHeight)];

    [self addChildSubViews];
    [self addChildConstraint];

    self.expanding = YES;
}

- (void)expandButtonAction:(UIButton *)sender
{
    [sender setTitle:self.expanding ? @"Expand" : @"Collapse" forState:UIControlStateNormal];
    [UIView animateWithDuration:0.5 animations:^{
        self.logoImageView.dp_collapsed = self.expanding;
        [self.view layoutSubviews];
    } completion:^(BOOL finished) {
        self.expanding = !self.expanding;
    }];
}

-(void)addChildSubViews
{
    [self.view addSubview:self.logoLabel];
    [self.view addSubview:self.expandBtn];
    [self.view addSubview:self.logoImageView];
    [self.view addSubview:self.collapseLabel];
}

-(void)addChildConstraint
{
    [self.logoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(80.0f);
    }];

    [self.expandBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.logoLabel.mas_bottom).offset(20.0f);
    }];

    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.expandBtn.mas_bottom).offset(20.0f);
        make.height.equalTo(@128.0f);
    }];

    [self.collapseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.logoImageView.mas_bottom).offset(20.0f);
    }];
}

-(UILabel *)logoLabel
{
    if(!_logoLabel)
    {
        _logoLabel = [[UILabel alloc]init];
        _logoLabel.text = @"Yo, forkingdog got a logo!";
        _logoLabel.font = [UIFont systemFontOfSize:17.0f];
    }

    return _logoLabel;
}

-(UIButton *)expandBtn
{
    if(!_expandBtn)
    {
        _expandBtn = [[UIButton alloc]init];
        [_expandBtn setTitle:@"expand" forState:UIControlStateNormal];
        [_expandBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _expandBtn.titleLabel.font = [UIFont systemFontOfSize:18.0f];
        [_expandBtn addTarget:self action:@selector(expandButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }

    return _expandBtn;
}

-(UIImageView *)logoImageView
{
    if(!_logoImageView)
    {
        _logoImageView = [[UIImageView alloc]init];
        _logoImageView.image = [UIImage imageNamed:@"forkingdog"];
    }

    return _logoImageView;
}

-(UILabel *)collapseLabel
{
    if(!_collapseLabel)
    {
        _collapseLabel = [[UILabel alloc]init];
        _collapseLabel.text = @"Image view will collapse / expand";
        _collapseLabel.font = [UIFont systemFontOfSize:17.0f];
    }
    
    return _collapseLabel;
}

@end
