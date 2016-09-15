//
//  MyAccountViewController.m
//  Hicube
//
//  Created by AaronYang on 6/3/15.
//  Copyright (c) 2015 Aaron. All rights reserved.
//

#import "MyAccountViewController.h"
#import "BaseTableViewCell.h"
#import "GetOutViewController.h"

#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"


#define TitleArray @[@"余额",@"提现",@"充值"]
static NSString *const identifier = @"BaseTableViewCell";
@interface MyAccountViewController ()<UIAlertViewDelegate>
{
    NSString * rangeAmount;
}
@end

@implementation MyAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人账户";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [tableView registerClass:[BaseTableViewCell class] forCellReuseIdentifier:identifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(BOOL)requestDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        NSString * msg = [obj valueForKey:@"msg"];
        [self payment:rangeAmount billId:msg];
    }
    return YES;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return TitleArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BaseTableViewCell * cell = [sender dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    cell.imageView.hidden = YES;
    cell.textLabel.text = TitleArray[indexPath.row];
    
    if (indexPath.row !=0) {
        [cell addArrowRight];
    }else{
        UILabel * priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.width-100, 10, 80, 20)];
        priceLabel.textAlignment = NSTextAlignmentRight;
        priceLabel.text = [NSString stringWithFormat:@"%.2f元",self.user.balance];
        [cell.contentView addSubview:priceLabel];
    }
    return cell;
}


-(void)tableView:(UITableView *)sender didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [sender deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 1:{
            GetOutViewController * vc = [GetOutViewController new];
            [self pushViewController:vc];
            break;
        }
        case 2:{
            
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"充值" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            [alertView textFieldAtIndex:0].placeholder = @"请输入金额";
            [alertView show];
            break;
        }
        default:
            break;
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    rangeAmount = [alertView textFieldAtIndex:0].text;
    if (![rangeAmount hasValue]) {
        return;
    }
    
    [super startRequest];
    [client recharge:rangeAmount];
}

-(void)payment:(NSString *)amount billId:(NSString *)billId{
    
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
    order.tradeNO = billId; //订单ID（由商家自行制定）
    order.productName = billId; //商品标题
    order.productDescription =billId; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",amount.doubleValue]; //商品价格
    order.notifyURL =  @"http://112.124.5.160:80/alipay/notifyRecharge.htm"; //回调URL
    
    
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
