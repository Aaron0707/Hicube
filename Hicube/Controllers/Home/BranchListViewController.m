//
//  BranchListViewController.m
//  Hicube
//
//  Created by AaronYang on 5/17/15.
//  Copyright (c) 2015 Aaron. All rights reserved.
//

#import "BranchListViewController.h"
#import "MJRefresh.h"
#import "Company.h"
#import "BaseTableViewCell.h"
#import "WebViewController.h"

@interface BranchListViewController ()

@end

@implementation BranchListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"集团介绍";
    
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)headerRereshing{
    if ([super startRequest]) {
        [client loadCorPorations];
    }
}
-(void)footerRereshing{
    
}

#pragma mark -request did finish

-(BOOL)requestDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        
        NSArray * list = [obj getArrayForKey:@"list"];
        [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [obj setObject:[obj getStringValueForKey:@"id" defaultValue:@""] forKey:@"ID"];
            Company * company = [[Company alloc] initWithDictionary:obj error:nil];
            [contentArr addObject:company];
        }];
        [tableView reloadData];
        [tableView headerEndRefreshing];
        [tableView footerEndRefreshing];
        return YES;
    }
    return NO;
}

#pragma mark table view delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return contentArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * CellIdentifier = @"BaseTableViewCell";
    BaseTableViewCell * cell = [sender dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];        
        cell.textLabel.font = [UIFont systemFontOfSize:18];
    }
    
    Company * company = [contentArr objectAtIndex:indexPath.row];
    
    cell.textLabel.text = company.name;
    cell.topLine =indexPath.row==0?NO:YES;
    
    cell.imageView.hidden = YES;
    return cell;
}

-(void)tableView:(UITableView *)sender didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [sender deselectRowAtIndexPath:indexPath animated:YES];
    
    Company * company = [contentArr objectAtIndex:indexPath.row];
    WebViewController * vc = [[WebViewController alloc]init];
    
    NSString *url = [NSString stringWithFormat:@"http://112.124.5.160:80/admin/corporation/corporationDetail.htm?id=%@",company.ID];
    vc.url = url;
    [self pushViewController:vc];
}
@end
