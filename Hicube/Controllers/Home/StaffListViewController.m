//
//  StaffListViewController.m
//  Hicube
//
//  Created by AaronYang on 5/15/15.
//  Copyright (c) 2015 Aaron. All rights reserved.
//

#import "StaffListViewController.h"
#import "BaseTableViewCell.h"
#import "MJRefresh.h"
#import "Staff.h"
#import "UIButton+NSIndexPath.h"
@interface StaffListViewController ()

@end

@implementation StaffListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"商城";
    
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
    //    [contentArr addObject:dic];
    //    [contentArr addObject:dic];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)headerRereshing{
    [contentArr removeAllObjects];
    if ([super startRequest]) {
        [client findStaffWithlimit:0 p:0];
    }
}
-(void)footerRereshing{
    if ([contentArr count]%2!=0) {
        return;
    }
    if ([super startRequest]) {
        [client findStaffWithlimit:0 p:[contentArr count]/2];
    }
}


#pragma mark -request did finish
-(BOOL)requestDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        NSArray * list = [obj getArrayForKey:@"list"];
        [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSMutableDictionary * dic = [obj mutableCopy];
            [dic setObject:[dic getStringValueForKey:@"id" defaultValue:@""] forKey:@"ID"];
            Staff * staff = [[Staff alloc] initWithDictionary:dic error:nil];
            [contentArr addObject:staff];
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
    return 80;
}

-(UITableViewCell *)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * CellIdentifier = @"BaseTableViewCell";
    BaseTableViewCell * cell = [sender dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UIButton * callButton = VIEWWITHTAG(cell.contentView, 999);
    if (!cell) {
        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:18];
        callButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.width-60, 20, 40, 40)];
        [callButton setBackgroundImage:[UIImage imageNamed:@"kefu_home"] forState:UIControlStateNormal];
        callButton.tag = 999;
        [callButton addTarget:self action:@selector(callButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:callButton];
    }
    callButton.indexPath = indexPath;
    
    Staff * staff = [contentArr objectAtIndex:indexPath.row];
    
    cell.textLabel.text = staff.name;
    cell.detailTextLabel.text = staff.title;
    cell.detailTextLabel.numberOfLines = 3;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    
    cell.topLine =indexPath.row==0?NO:YES;
    
    [cell update:^(NSString *name) {
        cell.textLabel.centerY = cell.imageView.centerY-35;
        cell.textLabel.frame = CGRectMake(80, 15, 100, 20);
        cell.detailTextLabel.frame = CGRectMake(cell.textLabel.frame.origin.x, 20,cell.width-115, 60);
        cell.imageView.frame = CGRectMake(10, 10, 60, 60);
        cell.imageView.layer.cornerRadius = 30;
    }];
    
    return cell;
}

-(NSString *)baseTableView:(UITableView *)sender imageURLAtIndexPath:(NSIndexPath *)indexPath{
    Staff * staff = [contentArr objectAtIndex:indexPath.row];
    return staff.avatar;
}
-(void)tableView:(UITableView *)sender didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [sender deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)callButtonClick:(UIButton *)button{
    NSIndexPath *path = button.indexPath;
    Staff * staff = contentArr[path.row];
    NSString * phone =[staff phone];
    if (staff &&[phone hasValue])  {
        [Globals callAction:phone parentView:self.view];
    }
}
@end
