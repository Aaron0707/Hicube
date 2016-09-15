//
//  LoginController.m
//  Hicube
//
//  Created by AaronYang on 5/9/15.
//  Copyright (c) 2015 Aaron. All rights reserved.
//

#import "LoginController.h"
#import "ForgetPasswordViewController.h"
#import "RegistViewController.h"
#define space (Main_Screen_Height==480.00?5:30)
@interface LoginController ()<UITextFieldDelegate,UINavigationControllerDelegate>{
    UITextField * phoneField;
    UITextField * passwordField;
}

@end

@implementation LoginController


- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *bgImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_bg"]];
    bgImage.frame = self.view.frame;
    [self.view addSubview:bgImage];
    [self.view sendSubviewToBack:bgImage];
    UIImageView * logoImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_logo"]];
    if (Main_Screen_Height==480.00) {
        logoImage.size = CGSizeMake(100, 100);
    }
    logoImage.centerX = Main_Screen_Width/2;
    logoImage.centerY = 110;
    
    [self.view addSubview:logoImage];
    
    UIImageView * phoneImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_phone"]];
    phoneImage.left = 20;
    phoneImage.top = logoImage.bottom +30;
    [self.view addSubview:phoneImage];
    
    phoneField = [[UITextField alloc]initWithFrame:CGRectMake(70, phoneImage.top-2, self.view.width-90, 20)];
    phoneField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入用户名" attributes:@{NSForegroundColorAttributeName: RGBCOLOR(177, 178, 177)}];
    phoneField.font = [UIFont systemFontOfSize:16];
    phoneField.textColor = [UIColor whiteColor];
    [self.view addSubview:phoneField];
    
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(20, phoneImage.bottom + 10, self.view.width-40, 1)];
    [line1 setBackgroundColor:RGBCOLOR(177, 178, 177)];
    [self.view addSubview:line1];
    
    UIImageView * passwordImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_lock"]];
    passwordImage.left = 20;
    passwordImage.top = phoneImage.bottom + 30;
    [self.view addSubview:passwordImage];
    passwordField = [[UITextField alloc]initWithFrame:CGRectMake(70, passwordImage.top-2, self.view.width-90, 20)];
    passwordField.secureTextEntry = YES;
    passwordField.textColor = [UIColor whiteColor];
    passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:@{NSForegroundColorAttributeName: RGBCOLOR(177, 178, 177)}];
    
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(20, passwordImage.bottom + 10, self.view.width-40, 1)];
    [line2 setBackgroundColor:RGBCOLOR(177, 178, 177)];
    [self.view addSubview:line2];
    [self.view addSubview:passwordField];
    
    
    //登录按钮
    UIButton * forgetPw = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width-100, line2.bottom+10, 80, 20)];
    [forgetPw setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetPw.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [forgetPw setTitleColor:RGBCOLOR(177, 178, 177) forState:UIControlStateNormal];
    [forgetPw addTarget:self action:@selector(pushForgetPasswordViewC:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetPw];
    
    
    UIButton * loginButton = [[UIButton alloc] initWithFrame:CGRectMake(20, forgetPw.bottom+30, self.view.width-40, 45)];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton commonStyle];
    [loginButton addTarget:self action:@selector(logIn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    
    
    UIButton * registButton = [[UIButton alloc] initWithFrame:CGRectMake(20, loginButton.bottom+20, self.view.width-40, 45)];
    [registButton cancelStyle];
    [registButton setTitle:@"注册" forState:UIControlStateNormal];
    [registButton addTarget:self action:@selector(pushRegistViewC:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registButton];
    
    passwordField.delegate =
    phoneField.delegate = self;
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
        self.navigationController.navigationBar.hidden = YES;
}

#pragma mark -request did finish
-(BOOL)requestDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        BSEngine * engine = [BSEngine currentEngine];
        [engine setCurrentUser:nil password:nil tok:[obj getStringValueForKey:@"msg" defaultValue:@""]];
        [engine saveLastLogInUserPhone:phoneField.text];
        
        client = [[BSClient alloc]initWithDelegate:self action:@selector(requestProfileDidFinish:obj:)];
        [client findProfileByUsername:engine.lastLogInUserPhone];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGINSUCCESS object:nil];
    }
    return YES;
}

-(void)requestProfileDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        NSArray * list = [obj getArrayForKey:@"list"];
        NSMutableDictionary * dic = list[0];
        [dic setObject:[dic getStringValueForKey:@"id" defaultValue:@""] forKey:@"ID"];
        User *user = [[User alloc] initWithDictionary:dic error:nil];
        [[BSEngine currentEngine] setCurrentUser:user password:nil tok:nil];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [passwordField resignFirstResponder];
    [phoneField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([phoneField isFirstResponder]) {
        [passwordField becomeFirstResponder];
    }
    NSString * phone = phoneField.text;
    NSString * password = passwordField.text;
    if ([passwordField isFirstResponder] && [phone hasValue] && [password hasValue]) {
        [self logIn:nil];
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark button action
-(void)pushForgetPasswordViewC:(UIButton *)sender{
    ForgetPasswordViewController * vc = [[ForgetPasswordViewController alloc]init];
    
    [self pushViewController:vc];
}
-(void)pushRegistViewC:(UIButton *)sender{
    RegistViewController * vc = [[RegistViewController alloc]init];
    [self pushViewController:vc];
}
-(void)logIn:(id)sender{
    
    NSString * phone = phoneField.text;
    NSString * password = passwordField.text;
    
    if (![phone hasValue]||![password hasValue]) {
        [self showText:@"请输入正确的账号和密码"];
        return;
    }
    
    [super startRequest];
    [client logInByPhone:phone pw:password];
}

@end
