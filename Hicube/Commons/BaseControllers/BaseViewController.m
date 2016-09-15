//
//  BaseViewController.m
//  CarPool
//
//  Created by kiwi on 14-6-23.
//  Copyright (c) 2014年 NigasMone. All rights reserved.
//

#import "BaseViewController.h"
#import "BSEngine.h"
#import "BSClient.h"
#import "KLoadingView.h"
#import "KAlertView.h"
#import "TextInput.h"
#import "KWAlertView.h"
#import "LoginController.h"
#import "AppDelegate.h"
#import "UIImage+Lcy.h"


@interface BaseViewController () <KWAlertViewDelegate, UIGestureRecognizerDelegate> {
    KLoadingView   * loadingView;
    UIView * errorView;
    UILabel *errorMessageLabel;
}
@end

@implementation BaseViewController
@synthesize willShowBackButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self initDefault];
    }
    return self;
}

- (id)init {
    if (self = [super init]) {
        [self initDefault];
    }
    return self;
}

- (void)initDefault {
    needToLoad = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationInfoUpdate:) name:NtfInfoUpdate object:nil];
}

- (void)dealloc {
    [client cancel];
    Release(client);
    self.loading = NO;
    Release(loadingView);
    Release(currentInputView);
    Release(nib);
    
    Release(refreshControl);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -
#pragma mark - View
- (void)viewDidLoad {
    [super viewDidLoad];
    isFirstAppear = YES;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.tabBarController.tabBar.tintColor = NavOrBarTinColor;
    
    if (willShowBackButton) {
        [self setLeftBarButton:nil image:[UIImage imageNamed:@"top_back"] highlightedImage:nil selector:@selector(popViewController)];
    }
    if (Sys_Version >= 7) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    needToLoad = YES;
    keyboardHeight = DefaultKeyBoardHeight;
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.translucent = NO;
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (loadingView) [loadingView show];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (loadingView) [loadingView hide];
    isFirstAppear = NO;
    [self.view removeKeyboardControl];
    [currentInputView resignFirstResponder];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:currentInputView];
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)sender {
    currentInputView = sender;
    sender.backgroundColor = [UIColor clearColor];
    return YES;
}

- (void)showBackButton {
    willShowBackButton = YES;
}


- (void)setEdgesNone {
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

#pragma mark -
#pragma mark - Loading State

- (void)showText:(id)text {
    [KAlertView showType:KAlertTypeNone text:text for:1.45 animated:YES];
}

- (void)showAlertWithTag:(id)text isNeedCancel:(BOOL)isNeedCancel tag:(int)tag {
    KWAlertView *k = [[KWAlertView alloc] initWithTitle:nil message:text delegate:self cancelButtonTitle:isNeedCancel?@"取消":nil textViews:nil otherButtonTitles:@"确定", nil];
    k.tag = tag;
    [k show];
}

- (void)showAlert:(id)text isNeedCancel:(BOOL)isNeedCancel {
    [[[KWAlertView alloc] initWithTitle:nil message:text delegate:self cancelButtonTitle:@"确定" textViews:nil otherButtonTitles:isNeedCancel?@"取消":nil, nil] show];
}

- (void)kwAlertView:(KWAlertView*)sender didDismissWithButtonIndex:(NSInteger)index {
    
}

- (void)showTipText:(NSString*)text top:(BOOL)top {
    UILabel * lab = [UILabel singleLineText:text font:[UIFont systemFontOfSize:14] wid:320 color:RGBCOLOR(255, 255, 255)];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.backgroundColor = BkgSkinColor;
    lab.alpha = 0;
    
    CGRect frame = CGRectMake(0, -25, self.view.width, 25);
    if (top && Sys_Version >= 7) {
        frame.origin.y = 64 - 25;
    } else if (!top) {
        frame.origin.y = self.view.height;
        if (Sys_Version >= 7) frame.origin.y -= 49;
    }
    
    lab.frame = frame;
    [self.view addSubview:lab];
    
    [UIView animateWithDuration:0.55 animations:^{
        lab.alpha = 1;
        if (top) {
            if (Sys_Version < 7) lab.top = 0;
            else lab.top = 64;
        } else {
            CGFloat bottom = self.view.height;
            if (Sys_Version >= 7 && !self.hidesBottomBarWhenPushed) {
                bottom -= 49;
            }
            lab.bottom = bottom;
        }
    } completion:^(BOOL finished) {
        [self performSelector:@selector(hideTipText:) withObject:lab afterDelay:3.0];
    }];
}

- (void)hideTipText:(UILabel*)lab {
    [UIView animateWithDuration:1.0 animations:^{
        lab.top = 0;
        lab.alpha = 0;
    } completion:^(BOOL finished) {
        [lab removeFromSuperview];
    }];
}

- (void)setLoading:(BOOL)bl {
    [self setLoading:bl content:String(@"稍等一下")];
}

- (void)setLoading:(BOOL)bl content:(NSString*)con {
    if (bl) {
        self.view.userInteractionEnabled = NO;
        if (loadingView == nil) {
            loadingView = [[KLoadingView alloc] initWithText:con animated:NO];
        }
        [loadingView show];
    } else if (loadingView) {
        self.view.userInteractionEnabled = YES;
        [loadingView hide];
        loadingView = nil;
    }
}

- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pushViewController:(id)con {
    ((BaseViewController*)con).hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:con animated:YES];
}

- (void)sendNotificationInfoUpdate:(id)obj {
    [[NSNotificationCenter defaultCenter] postNotificationName:NtfInfoUpdate object:obj];
}

- (void)notificationInfoUpdate:(NSNotification*)notification {
    //to be implemented in sub-classes
}

#pragma mark -
#pragma mark - Modal View Controller
- (void)presentModalController:(id)con animated:(BOOL)animated {
    [self presentViewController:con animated:animated completion:nil];
}

- (void)dismissModalController:(BOOL)animated {
    [self dismissViewControllerAnimated:animated completion:nil];
}

- (void)resignAllKeyboard:(UIView*)aView
{
    if([aView isKindOfClass:[UITextField class]] ||
       [aView isKindOfClass:[UITextView class]])
    {
        UITextField* tf = (UITextField*)aView;
        if([tf canResignFirstResponder])
            [tf resignFirstResponder];
    }
    
    for (UIView* pView in aView.subviews) {
        [self resignAllKeyboard:pView];
    }
}

+ (void)resignAllKeyboard:(UIView*)aView
{
    if([aView isKindOfClass:[UITextField class]] ||
       [aView isKindOfClass:[UITextView class]])
    {
        UITextField* tf = (UITextField*)aView;
        if([tf canResignFirstResponder])
            [tf resignFirstResponder];
    }
    
    for (UIView* pView in aView.subviews) {
        [self resignAllKeyboard:pView];
    }
}

#pragma mark -
#pragma mark - Bar Style
- (UIButton*)buttonWithTitle:(NSString*)title image:(UIImage*)img selector:(SEL)sel {
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (title) {
        UIFont * font = [UIFont boldSystemFontOfSize:14];
        CGSize size = CGSizeMake(150, 18);
        size = [title sizeWithFont:font constrainedToSize:size];
        btn.frame = CGRectMake(0, 0, size.width + 20, 31);
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitle:title forState:UIControlStateHighlighted];
        [btn setTitleColor:MygreenColor forState:UIControlStateNormal];
        //        [btn setTitleColor:RGBCOLOR(0, 121, 220) forState:UIControlStateHighlighted];
        btn.titleLabel.font = font;
        if (img) {
            btn.frame = CGRectMake(0, 0, img.size.width, img.size.height);
            [btn setBackgroundImage:img forState:UIControlStateNormal];
        }
    } else if (img) {
        btn.frame = CGRectMake(0, 0, img.size.width, img.size.height);
        [btn setImage:img forState:UIControlStateNormal];
    }
    if (sel != nil) {
        [btn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    }
    return btn;
}

- (void)setRightBarButton:(NSString*)title selector:(SEL)sel {
    UIButton * btn = [self buttonWithTitle:title image:nil selector:sel];
    btn.titleEdgeInsets = UIEdgeInsetsMake(5, 10, 0, 0);
    [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    UIBarButtonItem * itemRight = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = itemRight;
}

- (void)setLeftBarButton:(NSString*)title selector:(SEL)sel {
    UIButton * btn = [self buttonWithTitle:title image:nil selector:sel];
    UIBarButtonItem * itemLeft = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = itemLeft;
}

- (void)setLeftBarButton:(NSString*)title image:(UIImage*)img highlightedImage:(UIImage*)himg selector:(SEL)sel {
    UIButton * btn = [self buttonWithTitle:title image:img selector:sel];
    if (himg) {
        [btn setBackgroundImage:himg forState:UIControlStateHighlighted];
    }
    UIBarButtonItem * itemLeft = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = itemLeft;
}

- (void)setRightBarButtonImage:(UIImage*)img highlightedImage:(UIImage*)himg selector:(SEL)sel {
    UIButton * btn = [self buttonWithTitle:nil image:img selector:sel];
    if (himg) {
        [btn setImage:himg forState:UIControlStateHighlighted];
    }
    UIBarButtonItem * itemRight = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = itemRight;
}

- (void)setLeftBarButtonImage:(UIImage*)img selector:(SEL)sel {
    UIButton * btn = [self buttonWithTitle:nil image:img selector:sel];
    //    btn.frame = CGRectMake(0, 0, 18.0f, 20.0f);
    UIBarButtonItem * itemLeft = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = itemLeft;
}

//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    [self resignAllKeyboard:self.view];
//}

- (void)loginControllerDidLoginSuccess:(id)sender
{
    DLog(@"loginControllerDidLoginSuccess");
}

#pragma mark - Requests
- (BOOL)startRequest {
    if (client) {
        return NO;
    }
    if (needToLoad) {
        self.loading = YES;
    }
    client = [[BSClient alloc] initWithDelegate:self action:@selector(requestDidFinish:obj:)];
    return YES;
}

- (BOOL)requestDidFinish:(BSClient*)sender obj:(NSDictionary*)obj {
    client = nil;
    self.loading = NO;
    [refreshControl performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
    if (sender.hasError) {
        [sender showAlert];
        return NO;
    }
    return YES;
}

- (void)loadMoreRequest {
    if (client) return;
    client = [[BSClient alloc] initWithDelegate:self action:@selector(requestDidFinish:obj:)];
    [self prepareLoadMoreWithPage:currentPage maxID:maxID];
}

- (void)prepareLoadMoreWithPage:(int)page maxID:(int)mID {
    //to be implemented in sub-classes
}

- (void)updatePageInfo:(id)obj {
    //to be implemented in sub-classes
}
- (void)textFieldDidBeginEditing:(UITextField *)sender {
    currentInputView = sender;
}

- (void)textViewDidBeginEditing:(UITextView *)sender {
    currentInputView = sender;
}

- (BOOL)textFieldShouldReturn:(UITextField *)sender{
    [sender resignFirstResponder];
    currentInputView = nil;
    return YES;
}

- (BOOL)textField:(UITextField *)sender shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    sender.backgroundColor = [UIColor clearColor];
    return YES;
}
- (BOOL)textView:(UITextView*)sender shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text {
    if ([text hasPrefix:@"\n"]) {
        [sender resignFirstResponder];
        return NO;
    }
    return YES;
}



-(UIView *)errorView:(NSString *)message{
    if (!errorView) {
        errorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        [errorView setBackgroundColor:[UIColor whiteColor]];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.width-70)/2, 80, 70, 80)];
        [imageView setImage:[UIImage imageNamed:@"加载失败"]];
        [errorView addSubview:imageView];
        
        errorMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.width-150)/2, 170, 150, 80)];
        errorMessageLabel.textAlignment = NSTextAlignmentCenter;
        errorMessageLabel.textColor = MygrayColor;
        errorMessageLabel.numberOfLines = 0;
        errorMessageLabel.font=[UIFont systemFontOfSize:14];
        [errorView addSubview:errorMessageLabel];
        
        UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake((self.view.width-70)/2, 260, 70, 30)];
        [backBtn warningStyle];
        [backBtn setTitle:@"重载" forState:UIControlStateNormal];
        [errorView addSubview:backBtn];
        [backBtn addTarget:self action:@selector(removeErrorView) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:errorView];
        [self myAnimation:UIViewAnimationTransitionFlipFromLeft];
        NSString *title = self.navigationItem.title;
        
        if (!title.hasValue) {
            self.navigationItem.title = @"错误";
        }
    }
    errorMessageLabel.text = message;
    [self.view bringSubviewToFront:errorView];
    return errorView;
}

-(void)removeErrorView{
    [self viewDidAppear:YES];
    [errorView removeFromSuperview];
    errorView = nil;
}

- (void)myAnimation:(UIViewAnimationTransition)transition{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationTransition:transition forView:self.view cache:YES];
    
    [self.view bringSubviewToFront:errorView];
    
    [UIView commitAnimations];
}


@end
