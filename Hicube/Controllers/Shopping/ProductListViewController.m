//
//  ProductListViewController.m
//  Hicube
//
//  Created by AaronYang on 5/23/15.
//  Copyright (c) 2015 Aaron. All rights reserved.
//

#import "ProductListViewController.h"
#import "MJRefresh.h"
#import "Product.h"
#import "BaseTableViewCell.h"
#import "WebViewController.h"

@interface ProductListViewController ()

@end

@implementation ProductListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"产品列表";
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
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
    // Dispose of any resources that can be recreated.
}

-(void)headerRereshing{
    [contentArr removeAllObjects];
    if ([super startRequest]) {
        [client findProducts:nil limit:0 p:0];
    }
}
-(void)footerRereshing{
    if ([contentArr count]%2!=0) {
        return;
    }
    if ([super startRequest]) {
        [client findProducts:nil limit:0 p:[contentArr count]/2];
    }
}

#pragma mark -request did finish
-(BOOL)requestDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        NSArray * list = [obj getArrayForKey:@"list"];
        [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSMutableDictionary * dic = [obj mutableCopy];
            [dic setObject:[dic getStringValueForKey:@"id" defaultValue:@""] forKey:@"ID"];
            NSError  *error = nil;
            Product * work = [[Product alloc] initWithDictionary:dic error:&error];
            if (work) {
                [contentArr addObject:work];
            }
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
    return 115;
}

-(UITableViewCell *)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * CellIdentifier = @"BaseTableViewCell";
    BaseTableViewCell * cell = [sender dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Product * work = [contentArr objectAtIndex:indexPath.row];
    [cell addArrowRight];
    cell.textLabel.text = work.name;
    cell.detailTextLabel.text = work.title;
    
    cell.topLine =indexPath.row==0?NO:YES;
    
    [cell update:^(NSString *name) {
        cell.textLabel.centerY = cell.imageView.centerY-35;
        cell.textLabel.frame = CGRectMake(100, 18, 100, 20);
        cell.detailTextLabel.frame = CGRectMake(cell.textLabel.frame.origin.x, 40,cell.width-115, 60);
        cell.imageView.frame = CGRectMake(10, 20, 75, 75);
        cell.imageView.layer.cornerRadius = 5;
    }];
    return cell;
}

-(void)tableView:(UITableView *)sender didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [sender deselectRowAtIndexPath:indexPath animated:YES];
    Product * work = [contentArr objectAtIndex:indexPath.row];
    WebViewController * webVc = [WebViewController new];
    webVc.url = [NSString stringWithFormat:@"http://112.124.5.160:80/admin/ware/productDetail.htm?id=%@",work.ID];
    webVc.webTitle = @"产品详情";
    [self pushViewController:webVc];
}
-(NSString *)baseTableView:(UITableView *)sender imageURLAtIndexPath:(NSIndexPath *)indexPath{
    Product * product = [contentArr objectAtIndex:indexPath.row];
    return product.gallery;
}
@end
