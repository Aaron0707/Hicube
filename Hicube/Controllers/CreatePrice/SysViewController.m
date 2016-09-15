//
//  SysViewController.m
//  Hicube
//
//  Created by AaronYang on 5/9/15.
//  Copyright (c) 2015 Aaron. All rights reserved.
//

#import "SysViewController.h"
#import "BaseTableViewCell.h"
#import "FanliSystemViewController.h"
#import "CreaterOfSystemViewController.h"
#import "MessageOfSystemViewController.h"

static NSString *const identifier = @"BaseTableViewCell";
@interface SysViewController ()

@end

@implementation SysViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"创富系统";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
//    [self initWithMember:YES];
    [tableView registerClass:[BaseTableViewCell class] forCellReuseIdentifier:identifier];
    
    [self richMember];
}


-(void)initWithMember:(BOOL)isMember{
    if (!isMember) {
        tableView.hidden = YES;
        UIImage * image = [UIImage imageNamed:@"feihuiyuan"];
        
        UIImageView * imageView = [[UIImageView alloc]initWithImage:image];
        imageView.centerX = self.view.centerX;
        imageView.centerY = self.view.centerY-100;
        [self.view addSubview:imageView];
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(imageView.frame)+10, self.view.width-80, 20)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"你还不是创富系统的会员哦!";
        label.textColor = [UIColor grayColor];
        [self.view addSubview:label];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}

-(void)richMember{
    if ([super startRequest]) {
        [client isRichMember];
    }
}

-(BOOL)requestDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        BOOL richMember = [obj getBoolValueForKey:@"richMember" defaultValue:NO];
        [self initWithMember:richMember];
    }
    return YES;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BaseTableViewCell * cell = [sender dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    [cell update:^(NSString *name) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"下代创业者";
                [cell addArrowRight];
                [cell.imageView setImage:[UIImage imageNamed:@"chuanyezhe_color"]];
                break;
            case 1:
                cell.textLabel.text = @"返利统计";
                [cell addArrowRight];
                [cell.imageView setImage:[UIImage imageNamed:@"fanli_color"]];
                break;
                
            default:
                cell.textLabel.text = @"消息";
                [cell addArrowRight];
                [cell.imageView setImage:[UIImage imageNamed:@"xiaoxi_color"]];
                break;
        }
        
        cell.imageView.frame = CGRectMake(10, 10, 40, 40);
        cell.textLabel.left = 60;
    }];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            [self pushViewController:[CreaterOfSystemViewController new]];
            break;
        case 1:
            [self pushViewController:[FanliSystemViewController new]];
            break;
        default:
            [self pushViewController:[MessageOfSystemViewController new]];
            break;
    }
}
@end
