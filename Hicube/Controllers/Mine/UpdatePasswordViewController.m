//
//  UpdatePasswordViewController.m
//  Hicube
//
//  Created by AaronYang on 6/3/15.
//  Copyright (c) 2015 Aaron. All rights reserved.
//

#import "UpdatePasswordViewController.h"
#import "UIImage+FlatUI.h"

@interface UpdatePasswordViewController (){
    UITextField * oldPasswordField;
    UITextField * newPasswordField;
    UITextField * confirmPasswordField;
}

@end

@implementation UpdatePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    CGFloat labelWidth = 100;
    UILabel * oldLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, labelWidth, 20)];
    oldLabel.font = Chinese_Font_16;
    oldLabel.text = @"输入旧密码:";
    [self.view addSubview:oldLabel];
    
    CGFloat fieldWidth = self.view.width-CGRectGetMaxX(oldLabel.frame)-20;
    oldPasswordField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(oldLabel.frame), oldLabel.frame.origin.y, fieldWidth, 20)];
    [self.view addSubview:oldPasswordField];
    [self.view addSubview:[self makeLineWithFrame:CGRectMake(20, CGRectGetMaxY(oldLabel.frame)+10, self.view.width-40, 1)]];
    
    UILabel * newLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(oldLabel.frame)+20, labelWidth, 20)];
    newLabel.font = Chinese_Font_16;
    newLabel.text = @"输入新密码:";
    [self.view addSubview:newLabel];
    newPasswordField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(newLabel.frame), newLabel.frame.origin.y, fieldWidth, 20)];
    [self.view addSubview:newPasswordField];
    [self.view addSubview:[self makeLineWithFrame:CGRectMake(20, CGRectGetMaxY(newLabel.frame)+10, self.view.width-40, 1)]];
    
    UILabel * confirmLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(newLabel.frame)+20, labelWidth, 20)];
    confirmLabel.font = Chinese_Font_16;
    confirmLabel.text = @"输入新密码:";
    [self.view addSubview:confirmLabel];
    
    confirmPasswordField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(confirmLabel.frame), confirmLabel.frame.origin.y, fieldWidth, 20)];
    [self.view addSubview:confirmPasswordField];
    [self.view addSubview:[self makeLineWithFrame:CGRectMake(20, CGRectGetMaxY(confirmLabel.frame)+10, self.view.width-40, 1)]];
    
    oldLabel.textColor =
    newLabel.textColor =
    confirmLabel.textColor =
    oldPasswordField.textColor =
    newPasswordField.textColor =
    confirmPasswordField.textColor = [UIColor grayColor];
    
    oldPasswordField.placeholder =
    newPasswordField.placeholder =
    confirmPasswordField.placeholder = @"请输入密码";
    
    oldPasswordField.returnKeyType =
    newPasswordField.returnKeyType =
    confirmPasswordField.returnKeyType = UIReturnKeyDone;
    
    oldPasswordField.secureTextEntry =
    newPasswordField.secureTextEntry =
    confirmPasswordField.secureTextEntry =YES;
    
    
    UIButton * saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    saveButton.frame = CGRectMake(20, CGRectGetMaxY(confirmPasswordField.frame)+30, self.view.width-40, 30);
    [saveButton commonStyle];
    [saveButton setTitle:@"提交" forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)requestDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SIGNOUT object:nil];
    }
    return YES;
}

#pragma mark -Util
-(UIImageView *)makeLineWithFrame:(CGRect)frame{
    UIImageView *topLineView = [[UIImageView alloc] initWithFrame:frame];
    topLineView.image =
    topLineView.highlightedImage = [UIImage imageWithColor:RGBCOLOR(239, 239, 239) cornerRadius:1];
    return topLineView;
}

-(void)save:(UIButton *)button{
    
    NSString * oldWord = oldPasswordField.text;
    NSString * newWord = newPasswordField.text;
    NSString * confirmWord = confirmPasswordField.text;
    if (![oldWord hasValue]) {
        [self showText:@"请输入旧密码"];
        [oldPasswordField becomeFirstResponder];
        return;
    }
    
    if (![newWord hasValue]) {
        [self showText:@"请输入新密码"];
        [newPasswordField becomeFirstResponder];
        return;
    }
    
    if (![confirmWord hasValue]) {
        [self showText:@"请输入确认密码"];
        [confirmPasswordField becomeFirstResponder];
        return;
    }
    
    if (![confirmWord isEqualToString:newWord]) {
        [self showText:@"两次输入的密码不一致"];
        return;
    }
    
    [super startRequest];
    [client updatePassword:newWord oldPassword:oldWord];
}
@end
