//
//  MemberOfSystemViewController.m
//  Hicube
//
//  Created by AaronYang on 5/27/15.
//  Copyright (c) 2015 Aaron. All rights reserved.
//

#import "FanliSystemViewController.h"
#import "BaseTableViewCell.h"
#import "MJRefresh.h"
#import "InCome.h"
#import "Globals.h"

static NSString *const identfier = @"BaseTableViewCell";
@interface FanliSystemViewController ()

@end

@implementation FanliSystemViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"返利信息";
    
    [tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [tableView headerBeginRefreshing];
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    tableView.headerPullToRefreshText = @"下拉可以刷新了";
    tableView.headerReleaseToRefreshText = @"松开马上刷新了";
    tableView.headerRefreshingText = @"刷新中...";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)headerRereshing{
    if ([super startRequest]) {
        [client findMyRecommendInCome];
    }
}

#pragma mark -request did finish
-(BOOL)requestDidFinish:(id)sender obj:(NSDictionary *)obj
{
    if ([super requestDidFinish:sender obj:obj]) {
        NSArray * list = [obj valueForKey:@"list"];
        
        [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            InCome * come = [[InCome alloc]initWithDictionary:obj error:nil];
            if (come) {
                [contentArr addObject:come];
            }
        }];
        [tableView headerEndRefreshing];
        [tableView reloadData];
    }else{
        [tableView headerEndRefreshing];
    }
    
    return YES;
}

#pragma mark table delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return contentArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BaseTableViewCell * cell = [sender dequeueReusableCellWithIdentifier:identfier];
    
    UILabel * label = VIEWWITHTAG(cell.contentView, 100);
    if (!cell) {
        cell = [[BaseTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identfier];
        label = [UILabel new];
        label.font = [UIFont systemFontOfSize:13];
        label.tag =100;
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:label];
    }
    
    InCome * income = [contentArr objectAtIndex:indexPath.row];
    cell.imageView.hidden = YES;
    cell.textLabel.text = [NSString stringWithFormat:@"返利: %@",income.amount];
    NSString * content = [NSString stringWithFormat:@"内容: 推荐用户 %@",income.nickname];
    cell.detailTextLabel.text = content;
    CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(cell.width-20, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    label.text = [NSString stringWithFormat:@"%@",[Globals sendTimeString:income.createTime.doubleValue]];
    [cell update:^(NSString *name) {
        cell.textLabel.frame = CGRectMake(10, 10, 100, 20);
        cell.detailTextLabel.frame = CGRectMake(10, 30,cell.width-20, size.height);
        label.frame = CGRectMake(10, CGRectGetMaxY(cell.detailTextLabel.frame), cell.width-20, 20);
    }];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.bottomLine = indexPath.row==contentArr.count-1;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
@end
