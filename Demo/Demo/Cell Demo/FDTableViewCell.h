//
//  FDTableViewCell.h
//  FlowLayoutCell
//
//  Created by depa on 15/4/9.
//  Copyright (c) 2015年 depa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FDListEntity;

@interface FDTableViewCell : UITableViewCell

@property (nonatomic, strong) FDListEntity *entity;

@end
