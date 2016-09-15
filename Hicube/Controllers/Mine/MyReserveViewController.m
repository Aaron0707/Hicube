//
//  MyReserveViewController.m
//  Hicube
//
//  Created by AaronYang on 5/12/15.
//  Copyright (c) 2015 Aaron. All rights reserved.
//

#import "MyReserveViewController.h"
#import "ReserveViewCellTableViewCell.h"
#import "MJRefresh.h"
#import "Reserve.h"
static NSString * CellIdentifier = @"ReserveViewCellTableViewCell";
@interface MyReserveViewController ()

@property (nonatomic, assign) BOOL isHeaderRefresh;
@end

@implementation MyReserveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的预约";
    [tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [tableView headerBeginRefreshing];
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    tableView.headerPullToRefreshText = @"下拉可以刷新了";
    tableView.headerReleaseToRefreshText = @"松开马上刷新了";
    tableView.headerRefreshingText = @"刷新中...";
    
    [tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    tableView.footerRefreshingText = @"加载中...";
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [tableView registerNib:[UINib nibWithNibName:@"ReserveViewCellTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CellIdentifier];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)headerRereshing{
    self.isHeaderRefresh = YES;
    if ([super startRequest]) {
        [client findReservesWithLimit:0 p:1];
    }
}
-(void)footerRereshing{
    self.isHeaderRefresh = NO;
    if ([super startRequest]) {
        [client findReservesWithLimit:0 p:currentPage];
    }
}

#pragma mark -request did finish
-(BOOL)requestDidFinish:(id)sender obj:(NSDictionary *)obj{
    if (self.isHeaderRefresh) {
         [tableView headerEndRefreshing];
    }else{
        [tableView footerEndRefreshing];
    }
    if ([super requestDidFinish:sender obj:obj]) {
        NSArray * list = [obj getArrayForKey:@"list"];
        if (self.isHeaderRefresh) {
            [contentArr removeAllObjects];
        }
        [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSMutableDictionary * dic = [obj mutableCopy];
            [dic setObject:[dic getStringValueForKey:@"id" defaultValue:@""] forKey:@"ID"];
            Reserve  * reserve = [[Reserve alloc] initWithDictionary:dic error:nil];
            if (reserve) {
                [contentArr addObject:reserve];
            }
        }];
        [tableView reloadData];
        return YES;
    }
    return NO;
}


#pragma mark table view delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return contentArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 135;
}

-(UITableViewCell *)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReserveViewCellTableViewCell * cell = [sender dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Reserve * reserve = [contentArr objectAtIndex:indexPath.row];
    
    cell.reserve = reserve;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
