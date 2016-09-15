//
//  ForgetPasswordViewController.m
//  Hicube
//
//  Created by AaronYang on 5/10/15.
//  Copyright (c) 2015 Aaron. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "UIImage+Lcy.h"
#define space (Main_Screen_Height==480.00?150:200)
@interface ForgetPasswordViewController ()<UINavigationControllerDelegate,UITextFieldDelegate>{
    UITextField * phoneField;
    UITextField * passwordField;
    UITextField * confimPWField;
    UITextField * verifymessage;
    UIButton * getVerifyBtn;
}

@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    self.willShowBackButton = YES;
    [super viewDidLoad];
    self.navigationItem.title =@"重置密码";
    self.navigationController.delegate = self;
    UIImageView *bgImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_bg"]];
    bgImage.frame = self.view.frame;
    [self.view addSubview:bgImage];
    [self.view sendSubviewToBack:bgImage];
    
    
    UIImageView * phoneImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_phone"]];
    phoneImage.left = 20;
    phoneImage.top = space;
    [self.view addSubview:phoneImage];
    
    phoneField = [[UITextField alloc]initWithFrame:CGRectMake(70, phoneImage.top-2, self.view.width-90, 20)];
    phoneField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号" attributes:@{NSForegroundColorAttributeName: RGBCOLOR(177, 178, 177)}];
    phoneField.font = [UIFont systemFontOfSize:16];
    phoneField.textColor = [UIColor whiteColor];
    [self.view addSubview:phoneField];
    
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(20, phoneImage.bottom + 10, self.view.width-40, 1)];
    [line1 setBackgroundColor:RGBCOLOR(177, 178, 177)];
    [self.view addSubview:line1];
    
    
    UIImageView * verifyImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_yanzheng"]];
    verifyImage.left = 20;
    verifyImage.top = line1.bottom + 30;
    [self.view addSubview:verifyImage];
    verifymessage = [[UITextField alloc]initWithFrame:CGRectMake(70, verifyImage.top-2, 90, 20)];
    verifymessage.textColor = [UIColor whiteColor];
    verifymessage.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"验证码" attributes:@{NSForegroundColorAttributeName: RGBCOLOR(177, 178, 177)}];
    
    UIView * line4 = [[UIView alloc]initWithFrame:CGRectMake(20, verifymessage.bottom + 10, self.view.width-40, 1)];
    [line4 setBackgroundColor:RGBCOLOR(177, 178, 177)];
    [self.view addSubview:line4];
    [self.view addSubview:verifymessage];
    //登录按钮
    getVerifyBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width-120, verifyImage.top-5, 100, 30)];
    [getVerifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getVerifyBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [getVerifyBtn setTitleColor:RGBCOLOR(177, 178, 177) forState:UIControlStateNormal];
    [getVerifyBtn setBackgroundColor:RGBCOLOR(164, 155, 162)];
    [getVerifyBtn addTarget:self action:@selector(getVerify) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getVerifyBtn];

    
    
    
    UIImageView * passwordImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_lock"]];
    passwordImage.left = 20;
    passwordImage.top = verifyImage.bottom + 30;
    [self.view addSubview:passwordImage];
    passwordField = [[UITextField alloc]initWithFrame:CGRectMake(70, passwordImage.top-2, self.view.width-90, 20)];
    passwordField.secureTextEntry = YES;
    passwordField.textColor = [UIColor whiteColor];
    passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入登录密码" attributes:@{NSForegroundColorAttributeName: RGBCOLOR(177, 178, 177)}];
    
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(20, passwordImage.bottom + 10, self.view.width-40, 1)];
    [line2 setBackgroundColor:RGBCOLOR(177, 178, 177)];
    [self.view addSubview:line2];
    [self.view addSubview:passwordField];
    
    
    confimPWField = [[UITextField alloc]initWithFrame:CGRectMake(70, line2.bottom+10, self.view.width-90, 20)];
    confimPWField.secureTextEntry = YES;
    confimPWField.textColor = [UIColor whiteColor];
    confimPWField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入登录密码" attributes:@{NSForegroundColorAttributeName: RGBCOLOR(177, 178, 177)}];
    [self.view addSubview:confimPWField];
    
    UIView * line3 = [[UIView alloc]initWithFrame:CGRectMake(20, confimPWField.bottom + 10, self.view.width-40, 1)];
    [line3 setBackgroundColor:RGBCOLOR(177, 178, 177)];
    [self.view addSubview:line3];
    

    
    UIButton * registerButton = [[UIButton alloc] initWithFrame:CGRectMake(20, line3.bottom+30, self.view.width-40, 45)];
    [registerButton setTitle:@"确认" forState:UIControlStateNormal];
    [registerButton commonStyle];
    [registerButton addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];
    
    
    phoneField.delegate =
    passwordField.delegate =
    confimPWField.delegate =
    verifymessage.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -request
-(BOOL)requestDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_RESITPASSWORD object:    nil];
    }
    return YES;
}

-(void)requestVerifyDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        [self showText:@"获取成功"];
        getVerifyBtn.enabled = NO;
        [getVerifyBtn setBackgroundColor:MygrayColor];
        
        [self performSelector:@selector(openVerificationBtn) withObject:nil afterDelay:60.0f];
    }
}


#pragma mark -UINavigationControllerDelegate
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    NSMutableDictionary * textDic = [NSMutableDictionary dictionaryWithCapacity:4];
    [textDic setObject:[UIFont boldSystemFontOfSize:18] forKey:NSFontAttributeName];
    [textDic setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = textDic;
    
    NSArray *list = self.navigationController.navigationBar.subviews;
    for (id obj in list) {
        if ([obj isKindOfClass:[UIImageView class]]) {
            UIImageView *imageView = (UIImageView *)obj;
            imageView.hidden = YES;
        }
    }
    
}

#pragma mark button action
-(void)registerAction:(UIButton *)sender{
    NSString * phone = phoneField.text;
    NSString * password = passwordField.text;
    NSString * confrim = confimPWField.text;
    NSString * verify = verifymessage.text;
    
    if (![phone hasValue]) {
        [self showText:@"请输入手机号码"];
        return;
    }
    if (![password hasValue]) {
        [self showText:@"请输入密码"];
        return;
    }
    if (![confrim hasValue]) {
        [self showText:@"请输入第二次密码"];
        return;
    }
    if (![verify hasValue]) {
        [self showText:@"请输入验证码"];
        return;
    }
    
    if (![password isEqualToString:confrim]) {
        [self showText:@"两次输入密码不一致"];
        return;
    }
    
    [super startRequest];
    [client resetPassword:phone newPw:password verify:verify];
    
}

-(void)getVerify{
    NSString * phone = phoneField.text;
    if ([Globals isPhoneNumber:phone]) {
        client = [[BSClient alloc]initWithDelegate:self action:@selector(requestVerifyDidFinish:obj:)];
        [client getVerifyForReset:phone];
    }else {
        [self showText:@"请输入正确的手机号码"];
    }
    
}

-(void)openVerificationBtn{
    getVerifyBtn.enabled = YES;
    [getVerifyBtn setBackgroundColor:MygreenColor];
}

@end
