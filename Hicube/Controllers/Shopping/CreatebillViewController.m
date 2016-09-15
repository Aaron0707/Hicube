//
//  CreatebillViewController.m
//  Hicube
//
//  Created by AaronYang on 5/17/15.
//  Copyright (c) 2015 Aaron. All rights reserved.
//

#import "CreatebillViewController.h"
#import "BaseTableViewCell.h"
#import "Work.h"
#import "UIImage+Lcy.h"
#import "Bill.h"
#import "KWAlertView.h"

#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
@interface CreatebillViewController (){
    UITextField * numberField;
    UILabel * label1;
    UILabel * label2;
    UIButton * scoreButton;
    UIButton * scoreButton1;
    User *user;
    
    UILabel * scorelabel;
    UILabel * priceLabel;
    
    BOOL needPay;
    Bill* needPaybill;
}

@property (nonatomic, strong) NSString * billPrice;

@property (nonatomic, strong) NSString * costScores;
@end

@implementation CreatebillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"提交订单";
    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.width, 100)];
    [footView setBackgroundColor:[UIColor whiteColor]];
    UIButton * donebutton = [[UIButton alloc]initWithFrame:CGRectMake(20, 60, tableView.width-40, 40)];
    [donebutton commonStyle];
    [donebutton setBackgroundColor:NavOrBarTinColor];
    [donebutton setTitle:@"提交订单" forState:UIControlStateNormal];
    [donebutton addTarget:self action:@selector(createBill) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:donebutton];
    tableView.tableFooterView = footView;
    [tableView setBackgroundColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if ([super startRequest]) {
        [client findScoreSetting];
    }
}

-(BOOL)requestDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        self.costScores = [obj valueForKey:@"costScores"];
        client = [[BSClient alloc] initWithDelegate:self action:@selector(requestUserDidFinish:obj:)];
        [client findProfileByUsername:[BSEngine currentEngine].lastLogInUserPhone];
    }
    return YES;
}
-(void)requestSaveBillDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        if (needPay) {
            needPaybill.ID = [obj valueForKey:@"billId"];
            [self payment:needPaybill];
        }else{
            [self popViewController];
        }
    }
}

-(BOOL)requestUserDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        NSArray * list = [obj getArrayForKey:@"list"];
        NSMutableDictionary * dic = list[0];
        [dic setObject:[dic getStringValueForKey:@"id" defaultValue:@""] forKey:@"ID"];
        user = [[User alloc] initWithDictionary:dic error:nil];
        [[BSEngine currentEngine] setCurrentUser:user password:nil tok:nil];
        
        scorelabel.text = [NSString stringWithFormat:@"现有积分%@",user.score];
        priceLabel.text = [NSString stringWithFormat:@"现有余额%.2f",user.balance];
    }
    return YES;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 47;
}

-(UITableViewCell *)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * CellIdentifier = @"BaseTableViewCell";
    BaseTableViewCell * cell = [sender dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.imageView.hidden = YES;
    cell.textLabel.textColor = [UIColor grayColor];
    switch (indexPath.row) {
        case 0:{
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(cell.width-110, 14, 100, 20)];
            label.textColor = NavOrBarTinColor;
            label.textAlignment = NSTextAlignmentRight;
            label.text = [NSString stringWithFormat:@"￥%@元",self.work.price];
            [cell.contentView addSubview:label];
            cell.textLabel.text = self.work.name;
            break;
        }
        case 1:{
            UIButton * button1 = [[UIButton alloc]initWithFrame:CGRectMake(cell.width-140, 11, 25, 25)];
            [button1 commonStyle];
            [button1 setTitle:@"-" forState:UIControlStateNormal];
            [cell.contentView addSubview:button1];
            [button1 setBackgroundColor:NavOrBarTinColor];
            UIButton * button2 = [[UIButton alloc]initWithFrame:CGRectMake(cell.width-40, 11, 25, 25)];
            [button2 commonStyle];
            [button2 setTitle:@"+" forState:UIControlStateNormal];
            [cell.contentView addSubview:button2];
            [button2 setBackgroundColor:NavOrBarTinColor];
            button1.titleLabel.font =
            button2.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:26];
            [button1 addTarget:self action:@selector(sub) forControlEvents:UIControlEventTouchUpInside];
            [button2 addTarget:self action:@selector(up) forControlEvents:UIControlEventTouchUpInside];
            numberField=[[UITextField alloc]initWithFrame:CGRectMake(button1.right+5, 8, 65, 30)];
            numberField.keyboardType = UIKeyboardTypeNumberPad;
            numberField.text=@"1";
            numberField.textAlignment = NSTextAlignmentCenter;
            numberField.textColor = [UIColor grayColor];
            numberField.borderStyle = UITextBorderStyleRoundedRect;
            self.billPrice = self.work.price;
            [cell.contentView addSubview:numberField];
            cell.textLabel.text = @"数量";
            break;
        }
        case 2:{
            label1 = [[UILabel alloc] initWithFrame:CGRectMake(cell.width-110, 14, 100, 20)];
            label1.textColor = RGBCOLOR(125, 82, 2);
            label1.textAlignment = NSTextAlignmentRight;
            label1.text = [NSString stringWithFormat:@"%@元",self.work.price];
            [cell.contentView addSubview:label1];
            cell.textLabel.text = @"小计";
            break;
        }
        case 3:{
            scorelabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.width-195, 14, 160, 20)];
            scorelabel.textColor = RGBCOLOR(247, 196, 77);
            scorelabel.textAlignment = NSTextAlignmentRight;
            scorelabel.text = [NSString stringWithFormat:@"现有积分%@",user.score];
            [cell.contentView addSubview:scorelabel];
            
            scoreButton = [[UIButton alloc]initWithFrame:CGRectMake(scorelabel.right+5, 14, 20, 20)];
            scoreButton.tag = 999;
            [scoreButton setBackgroundImage:[UIImage imageWithColor:RGBCOLOR(247, 196, 77)] forState:UIControlStateNormal];
            [scoreButton addTarget:self action:@selector(scoreSelected:) forControlEvents:UIControlEventTouchUpInside];
            [scoreButton setTitle:@"√" forState:UIControlStateNormal];
            [scoreButton setTitleColor:NavOrBarTinColor forState:UIControlStateSelected];
            [cell.contentView addSubview:scoreButton];
            cell.textLabel.text = @"使用积分";
            break;
        }
        case 4:{
            priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.width-195, 14, 160, 20)];
            priceLabel.textColor = RGBCOLOR(247, 196, 77);
            priceLabel.textAlignment = NSTextAlignmentRight;
            priceLabel.text = [NSString stringWithFormat:@"现有余额%.2f",user.balance];
            [cell.contentView addSubview:priceLabel];
            
            scoreButton1 = [[UIButton alloc]initWithFrame:CGRectMake(priceLabel.right+5, 14, 20, 20)];
            scoreButton1.tag = 998;
            [scoreButton1 setBackgroundImage:[UIImage imageWithColor:RGBCOLOR(247, 196, 77)] forState:UIControlStateNormal];
            [scoreButton1 addTarget:self action:@selector(scoreSelected:) forControlEvents:UIControlEventTouchUpInside];
            [scoreButton1 setTitle:@"√" forState:UIControlStateNormal];
            [scoreButton1 setTitleColor:NavOrBarTinColor forState:UIControlStateSelected];
            [cell.contentView addSubview:scoreButton1];
            cell.textLabel.text = @"使用余额";
            break;
        }
        case 5:{
            label2 = [[UILabel alloc] initWithFrame:CGRectMake(cell.width-110, 14, 100, 20)];
            label2.textColor = RGBCOLOR(125, 82, 2);
            label2.textAlignment = NSTextAlignmentRight;
            label2.text = [NSString stringWithFormat:@"%@元",self.work.price];
            [cell.contentView addSubview:label2];
            cell.textLabel.text = @"订单总额";
            break;
        }
        default:
            break;
    }
    cell.bottomLine = YES;
    return cell;
}

-(void)createBill{
    if (!_work) {
        return;
    }
    needPay = YES;
    Bill * bill = [[Bill alloc]init];
    bill.price = self.billPrice;
    bill.wareId = _work.ID;
    bill.num = numberField.text;
    if (scoreButton.selected) {
        bill.useScore = YES;
        double score = [bill.price doubleValue]*[self.costScores doubleValue];
        if (score>[user.score doubleValue]) {
            bill.score = user.score;
            needPay = YES;
        }else{
            bill.score = [NSString stringWithFormat:@"%2f",score];
            needPay = NO;
        }
    }
    if (scoreButton1.selected && needPay) {
        bill.userBalance = YES;
        double price = [bill.price doubleValue]-[bill.score doubleValue]/[self.costScores doubleValue];
        if (price-user.balance>0) {
            bill.balance = [NSString stringWithFormat:@"%f",user.balance];
            needPay = YES;
        }else{
            bill.balance = [NSString stringWithFormat:@"%2f",price];
            needPay = NO;
        }
    }
    if (needPay) {
        bill.needPayment =[NSString stringWithFormat:@"%f",[bill.price doubleValue]-[bill.score doubleValue]/[self.costScores doubleValue]-[bill.balance doubleValue]];
        needPaybill = bill;
    }
    client = [[BSClient alloc] initWithDelegate:self action:@selector(requestSaveBillDidFinish:obj:)];
    [client saveBill:bill];
}

-(void)up{
    scoreButton1.selected =
    scoreButton.selected = NO;
    NSInteger numb = [numberField.text intValue]+1;
    NSString * price = [NSString stringWithFormat:@"%.2f",[self.work.price doubleValue] * numb];
    self.billPrice = price;
    [self updateBill:numb price:price];
}

-(void)sub{
    scoreButton1.selected =
    scoreButton.selected = NO;
    NSInteger numb = [numberField.text intValue];
    if (numb==1) {
        return;
    }
    numb -=1;
    NSString * price = [NSString stringWithFormat:@"%f",[self.work.price doubleValue] * numb];
    self.billPrice = price;
    [self updateBill:numb price:price];
}

-(void)updateBill:(NSInteger)numb price:(NSString *)price{
    numberField.text = [NSString stringWithFormat:@"%li",(long)numb];
    label1.text = [NSString stringWithFormat:@"%@元",price];
    label2.text = [NSString stringWithFormat:@"%@元",price];
}

-(void)scoreSelected:(UIButton *)button{
    button.selected = !button.selected;
    switch (button.tag) {
        case 999:{
            double score = [self.billPrice doubleValue]*[self.costScores doubleValue];
            if (score<[user.score doubleValue]) {
                scoreButton1.selected = NO;
                scoreButton1.enabled = !button.selected;
            }else{
                scoreButton1.enabled = YES;
            }
            break;
        }
        default:
            break;
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
//            KWAlertView * alert = [[KWAlertView alloc] initWithTitle:@"提示" message:[resultDic valueForKey:@"memo"] delegate:nil cancelButtonTitle:@"确定" textViews:nil otherButtonTitles: nil];
//            [alert show];

            [weakSelf popViewController];
        }];
        
    }
}
@end
