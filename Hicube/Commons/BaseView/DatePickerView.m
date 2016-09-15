//
//  DatePickerView.m
//  Hicube
//
//  Created by AaronYang on 5/13/15.
//  Copyright (c) 2015 Aaron. All rights reserved.
//

#import "DatePickerView.h"

@interface DatePickerView(){
    UIDatePicker * picker;
    UIButton * todayButton;
    UIButton * saveButton;
    UIView * bgView;
}

@end

@implementation DatePickerView

-(id)initWithDelegate:(id)delegate{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.frame = [[UIScreen mainScreen] applicationFrame];
        self.top-=20;
        self.height+=20;
        [self initView];
    }
    return self;
}

-(void)initView{
    self.alpha = 0.3;
    [self setBackgroundColor:[UIColor grayColor]];
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, self.width, 250)];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    todayButton  = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 60, 30)];
    [todayButton setTitle:@"重置" forState:UIControlStateNormal];
    [todayButton cancelStyle];
    saveButton = [[UIButton alloc]initWithFrame:CGRectMake(self.width-70, 10, 60, 30)];
    [saveButton commonStyle];
    [saveButton setTitle:@"完成" forState:UIControlStateNormal];
    
    [todayButton addTarget:self action:@selector(resetDate) forControlEvents:UIControlEventTouchUpInside];
    [saveButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
}
-(void)show{
    [self.superview addSubview:bgView];
    [self showDatePick];
}

-(void)showDatePick
{
    if (!picker) {
        picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 30, bgView.width, bgView.height-40)];
        [bgView addSubview:picker];
    }
    [bgView addSubview:saveButton];
    [bgView addSubview:todayButton];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    CGRect newFrame = bgView.frame;
    newFrame.origin.y -=250;
    bgView.frame = newFrame;
    [UIView commitAnimations];
}
-(void)dissDatePick
{
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    CGRect endFrame = bgView.frame;
    endFrame.origin.y = screenRect.origin.y + screenRect.size.height;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    bgView.frame = endFrame;
    [UIView commitAnimations];
    
    [self removeFromSuperview];
}

-(void)save{
    [self dissDatePick];
    if ([self.delegate respondsToSelector:@selector(datePickerViewSave:)]) {
        [self.delegate datePickerViewSave:picker.date];
    }
}
-(void)resetDate{
    [picker setDate:[NSDate date] animated:YES];
}
@end
