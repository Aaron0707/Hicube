//
//  WorkListViewController.m
//  Hicube
//
//  Created by AaronYang on 5/15/15.
//  Copyright (c) 2015 Aaron. All rights reserved.
//

#import "WorkListViewController.h"
#import "MJRefresh.h"
#import "BaseTableViewCell.h"
#import "Work.h"
#import "WorkDetailViewController.h"
#import "BasicNavigationController.h"
@interface WorkListViewController ()
{
    BOOL isFooterRefreshing;
}

@end

@implementation WorkListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"商品列表";
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
}

-(void)headerRereshing{
    isFooterRefreshing = NO;
    if ([super startRequest]) {
        [client findWork:nil limit:0 p:0];
    }
}
-(void)footerRereshing{
    isFooterRefreshing = YES;
    if ([contentArr count]%2!=0) {
        return;
    }
    if ([super startRequest]) {
        [client findWork:nil limit:0 p:[contentArr count]/2];
    }
}
#pragma mark -request did finish
-(BOOL)requestDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        if (isFooterRefreshing) {
            [contentArr removeAllObjects];
        }
        NSArray * list = [obj getArrayForKey:@"list"];
        [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSMutableDictionary * dic = [obj mutableCopy];
            [dic setObject:[dic getStringValueForKey:@"id" defaultValue:@""] forKey:@"ID"];
            Work * work = [[Work alloc] initWithDictionary:dic error:nil];
            [contentArr addObject:work];
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
    UILabel * priceLabel = VIEWWITHTAG(cell.contentView, 100);
    if (!cell) {
        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(tableView.width-115, 18, 100, 20)];
        priceLabel.tag = 100;
        priceLabel.textAlignment = NSTextAlignmentRight;
        priceLabel.font = [UIFont systemFontOfSize:18];
        priceLabel.textColor = RGBCOLOR(63, 192, 123);
        [cell.contentView addSubview:priceLabel];
        
        cell.textLabel.font = [UIFont systemFontOfSize:18];
    }
    Work * work = [contentArr objectAtIndex:indexPath.row];
    
    cell.textLabel.text = work.name;
    cell.detailTextLabel.text = work.title;
    priceLabel.text =[NSString stringWithFormat:@"￥%@元",work.price];
    cell.detailTextLabel.numberOfLines = 3;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    
    cell.topLine =indexPath.row==0?NO:YES;
    
    [cell update:^(NSString *name) {
        cell.textLabel.centerY = cell.imageView.centerY-35;
        cell.textLabel.frame = CGRectMake(100, 18, cell.width-185, 20);
        cell.detailTextLabel.frame = CGRectMake(cell.textLabel.frame.origin.x, 40,cell.width-115, 60);
        cell.imageView.frame = CGRectMake(10, 20, 75, 75);
        cell.imageView.image = [UIImage imageNamed:@"bgbg.jpg"];
        cell.imageView.layer.cornerRadius = 5;
    }];
    
    return cell;
}

-(void)tableView:(UITableView *)sender didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [sender deselectRowAtIndexPath:indexPath animated:YES];
    
    Work * work = [contentArr objectAtIndex:indexPath.row];
    WorkDetailViewController * vc = [[WorkDetailViewController alloc]init];
    vc.work = work;
    [self pushViewController:vc];
    
}
-(NSString *)baseTableView:(UITableView *)sender imageURLAtIndexPath:(NSIndexPath *)indexPath{
    Work * work = [contentArr objectAtIndex:indexPath.row];
    return work.gallery;
}

@end
