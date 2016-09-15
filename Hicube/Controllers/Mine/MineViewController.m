//
//  MineViewController.m
//  Hicube
//
//  Created by AaronYang on 5/9/15.
//  Copyright (c) 2015 Aaron. All rights reserved.
//

#import "MineViewController.h"
#import "BaseTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MyBillViewController.h"
#import "MyReserveViewController.h"
#import "CameraActionSheet.h"
#import "UploadPreViewController.h"
#import "WebViewController.h"
#import "UpdatePasswordViewController.h"
#import "MyAccountViewController.h"
#import "AboutUsViewController.h"

#define TitleArray @[@"修改密码",@"我的订单",@"我的预约",@"关于我们"]
#define imageOfCell(idx) LOADIMAGECACHES(([NSString stringWithFormat:@"center_%d",idx]))
@interface MineViewController ()<UINavigationControllerDelegate,updateDidDelegate>{
    UIImageView * headerImage;
    UILabel * nameLabel;
    
    UILabel * pointLabel;
    UILabel * priceLabel;
    
    User * user;
}

@end

@implementation MineViewController

-(instancetype)init{
    self = [super init];
    if (self) {
        user = [BSEngine currentEngine].user;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人中心";
    NSLog(@"%f",self.view.width);
    UIView * tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 190)];
    tableView.tableHeaderView = tableHeaderView;
    
    UIImageView * bgImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"center_bg"]];
    bgImage.size = tableHeaderView.size;
    [tableHeaderView addSubview:bgImage];
    [tableHeaderView sendSubviewToBack:bgImage];
    
    headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [headerImage setImage:[Globals getImageUserHeadDefault]];
    headerImage.layer.masksToBounds = YES;
    headerImage.layer.cornerRadius = 50;
    [headerImage setCenter:CGPointMake(tableHeaderView.centerX,70)];
    [headerImage setImage:[UIImage imageNamed:@"login_logo"]];
    [tableHeaderView addSubview:headerImage];
    
    nameLabel = [[UILabel alloc] init];
    [nameLabel setSize:CGSizeMake(140, 20)];
    [nameLabel setCenter:CGPointMake(headerImage.centerX, 140)];
    nameLabel.text = @"用户名";
    [nameLabel setTextAlignment:NSTextAlignmentCenter];
    [nameLabel setFont:[UIFont systemFontOfSize:18]];
    [nameLabel setTextColor:[UIColor whiteColor]];
    [tableHeaderView addSubview:nameLabel];
    
    UIImageView * pointImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"center_Integral"]];
    [tableHeaderView addSubview:pointImage];
    [pointImage setCenter:CGPointMake(nameLabel.centerX-nameLabel.width/2-50, nameLabel.bottom+20)];
    
    pointLabel = [[UILabel alloc]initWithFrame:CGRectMake(pointImage.frame.origin.x+20, pointImage.frame.origin.y-2, 100, 20)];
    [pointLabel setFont:[UIFont systemFontOfSize:14]];
    [pointLabel setTextColor:[UIColor whiteColor]];
    pointLabel.text = @"积分：0000";
    [tableHeaderView addSubview: pointLabel];
    
    UIImageView * priceImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"center_balance"]];
    [tableHeaderView addSubview:priceImage];
    [priceImage setCenter:CGPointMake(nameLabel.centerX+nameLabel.width/2-25, nameLabel.bottom+20)];
    
    priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(priceImage.frame.origin.x+20, priceImage.frame.origin.y-2, 100, 20)];
    [priceLabel setFont:[UIFont systemFontOfSize:14]];
    [priceLabel setTextColor:[UIColor whiteColor]];
    priceLabel.text = @"余额：00.00";
    [tableHeaderView addSubview: priceLabel];
    
    
    UIButton * button = [[UIButton alloc] initWithFrame:priceLabel.frame];
    [tableHeaderView addSubview:button];
    [button addTarget:self action:@selector(remain) forControlEvents:UIControlEventTouchUpInside];
    
    [self setRightBarButton:@"退出" selector:@selector(signOut:)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [super startRequest];
    
    [super setLoading:NO];
    [client findProfileByUsername:[BSEngine currentEngine].lastLogInUserPhone];
}


#pragma mark - request did finish
-(BOOL)requestDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        NSArray * list = [obj getArrayForKey:@"list"];
        NSMutableDictionary * dic = list[0];
        [dic setObject:[dic getStringValueForKey:@"id" defaultValue:@""] forKey:@"ID"];
        user = [[User alloc] initWithDictionary:dic error:nil];
        [[BSEngine currentEngine] setCurrentUser:user password:nil tok:nil];
        [self insertUserToView];
    }
    return YES;
}

#pragma mark -table view delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * CellIdentifier = @"BaseTableViewCell";
    BaseTableViewCell * cell = [sender dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UIImageView *imageView =  (UIImageView *)[cell.contentView viewWithTag:999];
    if (!cell) {
        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 8, 32, 32)];
        imageView.tag = 999;
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 16;
        [cell.contentView addSubview:imageView];
    }
    cell.textLabel.text = TitleArray[indexPath.row];
    cell.textLabel.textColor = MygrayColor;
    [cell addArrowRight];
    cell.topLine =indexPath.row==0? NO:YES;
    
    [imageView setImage:imageOfCell((int)indexPath.row)];
    
    [cell update:^(NSString *name) {
        cell.textLabel.left-=10;
    }];
    return cell;
}

-(void)tableView:(UITableView *)sender didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [sender deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:{
            UpdatePasswordViewController * vc = [UpdatePasswordViewController new];
            [self pushViewController:vc];
            break;
        }
        case 1:{
            MyBillViewController * con = [[MyBillViewController alloc] init];
            [self pushViewController:con];
            break;
        }
        case 2:{
            MyReserveViewController * con = [[MyReserveViewController alloc] init];
            [self pushViewController:con];
            
            break;
        }
        case 3:{
            AboutUsViewController * web = [AboutUsViewController new];
            [self pushViewController:web];
            break;
        }
        default:
            break;
    }
}

#pragma mark -update avater

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage * img = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    img = [UIImage rotateImage:img];
    UploadPreViewController * up = [[UploadPreViewController alloc] init];
    up.image = img;
    up.del = self;
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [self pushViewController:up];
    }];
}

-(void)saveBtnPressed:(UIImage *)image{
    [headerImage setImage:image];
}

#pragma mark -private Util
-(void)insertUserToView{
    if (!user) {
        return;
    }
//    if ([user.avatar hasValue]) {
//        [headerImage sd_setImageWithURL:[NSURL URLWithString:user.avatar]];
//    }
    pointLabel.text = [NSString stringWithFormat:@"积分：%@",user.score];
    priceLabel.text = [NSString stringWithFormat:@"余额：%.2f",user.balance];
    if ([user.nickname hasValue]) {
        nameLabel.text = user.nickname;
    }else
        nameLabel.text = user.phone;
}
//-(void)updateAvatarAction:(id)sender{
//    CameraActionSheet *actionSheet = [[CameraActionSheet alloc] initWithActionTitle:nil TextViews:nil CancelTitle:@"取消" withDelegate:self otherButtonTitles:@[@"拍一张",@"从相册选择"]];
//    actionSheet.tag = 0;
//    [actionSheet show];
//}
-(void)signOut:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SIGNOUT object:nil];
}

-(void)remain{
    MyAccountViewController * vc = [MyAccountViewController new];
    vc.user = user;
    [self pushViewController:vc];
}
@end
