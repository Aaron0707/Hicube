//
//  CreaterOfSystemViewController.m
//  Hicube
//
//  Created by AaronYang on 5/27/15.
//  Copyright (c) 2015 Aaron. All rights reserved.
//

#import "CreaterOfSystemViewController.h"
#import "CreaterOfSystemCell.h"
#import "SimpleUser.h"
#import "MJRefresh.h"

static NSString *const identifier = @"CreaterOfSystemCell";
@interface CreaterOfSystemViewController ()

@end

@implementation CreaterOfSystemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"下代创业者";
    [tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [tableView headerBeginRefreshing];
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    tableView.headerPullToRefreshText = @"下拉可以刷新了";
    tableView.headerReleaseToRefreshText = @"松开马上刷新了";
    tableView.headerRefreshingText = @"刷新中...";

    [tableView registerNib:[UINib nibWithNibName:@"CreaterOfSystemCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:identifier];
}

-(void)headerRereshing{
    if ([super startRequest]) {
        [client findMyRecommended];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - request did finish
-(BOOL)requestDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        NSArray * list = [obj valueForKey:@"list"];
        [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            SimpleUser * user = [[SimpleUser alloc]initWithDictionary:obj error:nil];
            [contentArr addObject:user];
        }];
        [tableView headerEndRefreshing];
        [tableView reloadData];
    }
    return YES;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return contentArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(UITableViewCell *)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CreaterOfSystemCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    cell.user = contentArr[indexPath.row];
    return cell;
}

@end
