//
//  MessageOfSystemViewController.m
//  Hicube
//
//  Created by AaronYang on 5/27/15.
//  Copyright (c) 2015 Aaron. All rights reserved.
//

#import "MessageOfSystemViewController.h"
#import "BaseTableViewCell.h"
#import "MJRefresh.h"
#import "Bill.h"
#import "UIImageView+WebCache.h"

static NSString *const identifier = @"BaseTableViewCell";
@interface MessageOfSystemViewController (){
    BOOL isFooterRefresh;
}

@end

@implementation MessageOfSystemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    [tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [tableView headerBeginRefreshing];
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    tableView.headerPullToRefreshText = @"下拉可以刷新了";
    tableView.headerReleaseToRefreshText = @"松开马上刷新了";
    tableView.headerRefreshingText = @"刷新中...";

    [tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    tableView.footerPullToRefreshText = @"上拉可以刷新了";
    tableView.footerReleaseToRefreshText = @"松开马上刷新了";
    tableView.footerRefreshingText = @"刷新中...";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

-(void)headerRereshing{
    isFooterRefresh = NO;
    if ([super startRequest]) {
        [client findMyRecommendBillsWithPage:currentPage limit:10];
    }
}

-(void)footerRereshing{
    isFooterRefresh = YES;
    if ([super startRequest]) {
        [client findMyRecommendBillsWithPage:currentPage limit:10];
    }
}


#pragma mark - request did finish
-(BOOL)requestDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        if (!isFooterRefresh) {
            [contentArr removeAllObjects];
        }
        NSArray * list = [obj getArrayForKey:@"list"];
        [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSMutableDictionary * dic = [obj mutableCopy];
            [dic setObject:[dic getStringValueForKey:@"id" defaultValue:@""] forKey:@"ID"];
            Bill  * bill = [[Bill alloc] initWithDictionary:dic error:nil];
            if (bill) {
                [contentArr addObject:bill];
            }
        }];
        [tableView reloadData];
        
        [tableView headerEndRefreshing];
        [tableView footerEndRefreshing];
    }
    
    return YES;
}

#pragma mark -table view delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return contentArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

-(UITableViewCell *)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    BaseTableViewCell * cell = [sender dequeueReusableCellWithIdentifier:identifier];
    
    UILabel * timeLabel = VIEWWITHTAG(cell.contentView, 999);
    if (!cell) {
        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.imageView.hidden = YES;
        timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(cell.width-200, 60, 180, 20)];
        timeLabel.textAlignment = NSTextAlignmentRight;
        timeLabel.font =Chinese_Font_12;
        [cell.contentView addSubview:timeLabel];
    }
    
    Bill * bill= [contentArr objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"标题:%@",bill.wareName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"用户:%@    金额: %@",bill.creatorId,bill.totalPrice];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    timeLabel.text = [Globals timeStringWith:bill.createTime.integerValue/1000];
    cell.topLine =indexPath.row==0?NO:YES;
    [cell update:^(NSString *name) {
        cell.textLabel.frame = CGRectMake(10, 18, cell.width, 20);
        cell.detailTextLabel.frame = CGRectMake(cell.textLabel.frame.origin.x, 40,cell.width-115, 25);
    }];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
