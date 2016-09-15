//
//  MyBillViewController.m
//  Hicube
//
//  Created by AaronYang on 5/12/15.
//  Copyright (c) 2015 Aaron. All rights reserved.
//

#import "MyBillViewController.h"
#import "BaseTableViewCell.h"
#import "Bill.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "UIButton+NSIndexPath.h"

#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"

@interface MyBillViewController ()
@property (nonatomic, assign) BOOL isHeaderRefresh;
@end

@implementation MyBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的订单";
    
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
    self.isHeaderRefresh = YES;
    if ([super startRequest]) {
        [client findBillsWithLimit:10 p:1];
    }
}
-(void)footerRereshing{
    self.isHeaderRefresh = NO;
    client = [[BSClient alloc] initWithDelegate:self action:@selector(requestDidFinish:obj:)];
    [client findBillsWithLimit:10 p:currentPage];
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
            Bill  * bill = [[Bill alloc] initWithDictionary:dic error:nil];
            if (bill) {
                [contentArr addObject:bill];
            }
        }];
        [tableView reloadData];
        return YES;
    }
    return NO;
}

-(void)requestBillActionDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        [self showText:@"已取消"];
        
        [self headerRereshing];
    }
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
    
    UILabel * stateLabel = VIEWWITHTAG(cell.contentView, 999);
    
    UIButton * button1 = VIEWWITHTAG(cell.contentView, 998);
    UIButton * button2 = VIEWWITHTAG(cell.contentView, 997);
    
    if (!cell) {
        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:18];
        stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(cell.width-90, 20, 80, 20)];
        [stateLabel setTextColor:NavOrBarTinColor];
        stateLabel.tag = 999;
        [cell.contentView addSubview:stateLabel];
        
        button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button1.frame = CGRectMake(cell.width-70, 70, 60, 30);
        button1.tag = 998;
        button1.hidden = YES;
        [button1 addTarget:self action:@selector(billAction:) forControlEvents:UIControlEventTouchUpInside];
        [button1 dangerStyle];
        [cell.contentView addSubview:button1];
        
        button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button2.frame = CGRectMake(cell.width-140, 70, 60, 30);
        button2.tag = 997;
        button2.hidden = YES;
        [button2 addTarget:self action:@selector(billAction:) forControlEvents:UIControlEventTouchUpInside];
        [button2 warningStyle];
        [cell.contentView addSubview:button2];
    }
    
            button1.indexPath = indexPath;
            button2.indexPath = indexPath;
    Bill * bill= [contentArr objectAtIndex:indexPath.row];
    stateLabel.textAlignment = NSTextAlignmentRight;
    [self stringCorvernt:bill.status viewLabel:stateLabel billAciton:button1 billAction2:button2];
    cell.textLabel.text = bill.wareName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"总价: %@元    数量: %@",bill.totalPrice,bill.num];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    
    cell.topLine =indexPath.row==0?NO:YES;
    [cell update:^(NSString *name) {
        cell.textLabel.centerY = cell.imageView.centerY-35;
        cell.textLabel.frame = CGRectMake(100, 18, cell.width-170, 20);
        cell.detailTextLabel.frame = CGRectMake(cell.textLabel.frame.origin.x, 40,cell.width-115, 25);
        cell.imageView.frame = CGRectMake(10, 20, 75, 75);
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:bill.gallery]];
        cell.imageView.layer.cornerRadius = 5;
    }];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(void)stringCorvernt:(NSString *)string viewLabel:(UILabel *)label billAciton:(UIButton *)button1 billAction2:(UIButton *)button2{
    if ([string isEqualToString:@"WAIT_PAY"]) {
        label.text =  @"未支付";
        label.textColor = TextOrangeColor;
        [button1 setTitle:@"支付" forState:UIControlStateNormal];
        [button2 setTitle:@"取消" forState:UIControlStateNormal];
        button1.hidden =
        button2.hidden = NO;
    }else if([string isEqualToString:@"COMPLETED"]){
        label.text =  @"已消费";
        label.textColor = NavOrBarTinColor;
        button1.hidden =
        button2.hidden = YES;
    }else if([string isEqualToString:@"CANCELED"]){
        label.textColor = TextOrangeColor;
        label.text =  @"已关闭";
        button1.hidden =
        button2.hidden = YES;
    }else{
        label.textColor = TextOrangeColor;
        label.text =  @"未消费";
        button1.hidden =
        button2.hidden = YES;
    }
}

-(void)billAction:(UIButton *)button{
    Bill * bill = contentArr[button.indexPath.row];
    if (![bill.status isEqualToString:@"WAIT_PAY"]) {
        return;
    }
    client = [[BSClient alloc]initWithDelegate:self action:@selector(requestBillActionDidFinish:obj:)];
    
    if (button.tag==998) {
        [self payment:bill];
    }else{
        [client cancelBill:bill.ID];
    }
    
}

-(void)payment:(Bill *)bill{
    
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = @"2088611672002014";
    NSString *seller = @"hlf_2014@sina.com";
    NSString *privateKey = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAL6HDGHEHrWVsqQVE+5fkgJF/yhwjcDp/YXXzy7tqFaNnq3f6LxLEEiGDp09jw1qNY6RRjnql8KhdfLuEhsfhJ7TEhYyItUP2QVs2NoacgzKPC6sp2EJwUYsw0rqglUIp1v72asGtG7GmVXCEDSSKVhdWsZnYH+C9/RiDAro7PXdAgMBAAECgYEAnmFHErJkUNB7Ktj2s44wosEr    JaPCwp4AiNVoPfuDl0eso59hKb1AcPk3htCYbS9gC/6JoTV5KGrt0J7E4FUn+Sv5    xCy5qQbEbQ7Di5sJWOAgMbY3VZs3Dohh5tn4/gADjBHbAuid3Zu79FfttfTBCyUxYmABPxMs/luyK59LxIECQQDhxfmM/8CkJnPubdYtcxGdWCbpRhBe6WrTXsjvwCzSono6N1iFwqZEgPwpupxUqUB4g6WNanZia8e/6HbPerUhAkEA2AkUQUOWyhN0T9CL0KpmBTPBXCfcTU9dTeWMJ1DNQ/HLPJIJVOpUWDqDA1rrVN00pXYvIBULW3H6sqrzwrktPQJAWeA+xIN3Q6FPG0Y8MaGSDInwC4Lpt27CKNydrttYvI0TjSNFKRJgr/qM52uzGfy6fn8ho1cTQ4DWZq36xgN6IQJAXilO58di8P8bwjIezruGrhvJ2rYRAq1l+K7lsLk6TrQUJnlskdN1IeOW+R5m1l14NepWTgB+K8R5RejXSHdX7QJBANeXpBv0nBTbEGXgiaQwqbHa2BYK1HzKvG4uRIuoduQKYSM/9m40nFpxzmbS+7S5ax/enRmS17NKtC7z40HaSRU=";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 || [seller length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = bill.ID; //订单ID（由商家自行制定）
    order.productName = bill.ID; //商品标题
    order.productDescription =bill.ID; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",bill.needPayment.doubleValue]; //商品价格
    order.notifyURL =  @"http://112.124.5.160:80/alipay/notify.htm"; //回调URL
    
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"Hicube";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
                        __weak typeof(self) weakSelf = self;
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
                        [weakSelf popViewController];
        }];
        
    }
}
@end
