//
//  FDTableViewController.m
//  FlowLayoutCell
//
//  Created by depa on 15/4/9.
//  Copyright (c) 2015年 depa. All rights reserved.
//

#import "FDTableViewController.h"
#import "FDTableViewCell.h"
#import "FDListEntity.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "Masonry.h"

@interface FDTableViewController ()

@property NSArray *entities;

@end

@implementation FDTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView registerClass:[FDTableViewCell class] forCellReuseIdentifier:NSStringFromClass([FDTableViewCell class])];

    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];

    [self buildTestDataThen:^{
        [self.tableView reloadData];
    }];
}

- (void)buildTestDataThen:(void (^)(void))then
{
    // Simulate an async request
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // Data from `data.json`
        NSString *dataFilePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:dataFilePath];
        NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSArray *feedDicts = rootDict[@"list"];
        
        // Convert to `FDFeedEntity`
        NSMutableArray *entities = @[].mutableCopy;
        [feedDicts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [entities addObject:[[FDListEntity alloc] initWithDictionary:obj]];
        }];
        self.entities = entities;
        
        // Callback
        dispatch_async(dispatch_get_main_queue(), ^{
            !then ?: then();
        });
    });
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.entities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = NSStringFromClass([FDTableViewCell class]);
    FDTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    cell.entity = self.entities[indexPath.row];
    cell.contentView.bounds = CGRectMake(0, 0, 9999, 9999);

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:@"FDTableViewCell" configuration:^(FDTableViewCell *cell) {
        cell.entity = self.entities[indexPath.row];
    }];
}

@end
