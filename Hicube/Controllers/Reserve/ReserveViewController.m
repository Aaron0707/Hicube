//
//  ReserveViewController.m
//  Hicube
//
//  Created by AaronYang on 5/12/15.
//  Copyright (c) 2015 Aaron. All rights reserved.
//

#import "ReserveViewController.h"
#import "DatePickerView.h"
#import "Service.h"
#import "Reserve.h"
#import "ServiceListViewController.h"

@interface ReserveViewController ()<DatePickerViewDelegate,ServiceListViewControllerDelegate>{
    DatePickerView * pickerView;
    User * user;
}

@property (nonatomic, strong) Service * service;
@property (nonatomic, strong) NSString * serviceYmd;
@property (nonatomic, strong) NSString * serviceHm;
@end

@implementation ReserveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"预约";
    [self setRightBarButtonImage:[UIImage imageNamed:@"top_yes"] highlightedImage:[UIImage imageNamed:@"top_yes"] selector:@selector(saveReserve:)];
    
    [self.button1 addTarget:self action:@selector(checkTime:) forControlEvents:UIControlEventTouchUpInside];
    [self.button2 addTarget:self action:@selector(checkProgram:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!user) {
        user = [BSEngine currentEngine].user;
    }
    
    self.nameField.text = user.nickname;
    self.phoneField.text = user.phone;
}

#pragma mark -request did finish
-(BOOL)requestDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        [self showText:@"预约成功"];
        self.serviceYmd = nil;
        self.serviceHm = nil;
        self.service = nil;
        self.serviceNameField.text = @"";
        self.timeField.text = @"";
    }
    return YES;
}

#pragma mark -service delegate
-(void)selectedService:(Service *)service{
    self.serviceNameField.text = service.name;
    self.service = service;
}

#pragma mark -button action
-(void)saveReserve:(id)sender{
    if (![self.nameField.text hasValue]) {
        [self showText:@"请输入用户名"];
        return;
    }
    if (![self.phoneField.text hasValue]) {
        [self showText:@"请输入电话号码"];
        return;
    }
    if (![self.serviceYmd hasValue] && ![self.serviceHm hasValue]) {
        [self showText:@"请选择时间"];
        return;
    }
    if (!self.service) {
        [self showText:@"请选择项目"];
        return;
    }
    if (![self.numberField.text hasValue]) {
        [self showText:@"请输入数量"];
        return;
    }
    
    [super startRequest];
    Reserve * reserve = [[Reserve alloc]init];
    reserve.wareId = self.service.ID;
    reserve.serviceHm = self.serviceHm;
    reserve.serviceYmd = self.serviceYmd;
    reserve.name = self.nameField.text;
    reserve.phone = self.phoneField.text;
    reserve.num = self.numberField.text;
    
    [client saveReserve:reserve];
}

-(void)checkTime:(id)sender{
    if (!pickerView) {
         pickerView = [[DatePickerView alloc]initWithDelegate:self];   
    }
    [self.view.window addSubview:pickerView];
    [pickerView show];
}
-(void)checkProgram:(id)sender{
    ServiceListViewController * vc = [[ServiceListViewController alloc]init];
    vc.delegate = self;
    [self pushViewController:vc];
}

-(void)datePickerViewSave:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // 为日期格式器设置格式字符串
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    
    self.serviceYmd =[dateFormatter stringFromDate:date];
    [dateFormatter setDateFormat:@"HHmm"];
    self.serviceHm = [dateFormatter stringFromDate:date];
    NSLog(@"serviceYmd:%@  serviceHm:%@",self.serviceYmd,self.serviceHm);
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    self.timeField.text = [dateFormatter stringFromDate:date];
}
@end
