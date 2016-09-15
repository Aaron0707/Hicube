//
//  WebViewController.m
//  CarPool
//
//  Created by kiwi on 14-6-23.
//  Copyright (c) 2014年 NigasMone. All rights reserved.
//

#import "WebViewController.h"
#import "CameraActionSheet.h"
#import "Globals.h"
//#import "Config.h"

@interface WebViewController ()<CameraActionSheetDelegate>
@end

@implementation WebViewController
@synthesize url, webTitle, nid;

- (id)init
{
    self = [super initWithNibName:@"WebViewController" bundle:NULL];
    if (self) {
        // Custom initialization
//        webView.width = App_Frame_Width;
//        webView.height = APP_Frame_Height;
    }
    return self;
}

- (void)dealloc
{
    self.item = nil;
    self.url = nil;
    self.nid = nil;
    [activityIndicator stopAnimating];
    Release(activityIndicator);
    Release(webView);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIScrollView  *scroller = [webView.subviews objectAtIndex:0];
    if (scroller) {
        for (UIView *v in [scroller subviews]) {
            if ([v isKindOfClass:[UIImageView class]]) {
                [v removeFromSuperview];
            }
        }
    }
    self.navigationItem.title = webTitle;

    UIView *view = [[UIView alloc] initWithFrame:webView.frame];
    [view setBackgroundColor:[UIColor clearColor]];
    view.tag = 999;
    [view setAlpha:0.8];
    [self.view addSubview:view];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    [activityIndicator setCenter:view.center];
    activityIndicator.color = BkgSkinColor;
    [view addSubview:activityIndicator];
    // Do any additional setup after loading the view from its nib.
    if ([self.content hasValue]) {
        [webView loadHTMLString:self.content baseURL:[NSURL URLWithString:KBSSDKAPIURL]];
    }else{
        NSURL *nsurl =[NSURL URLWithString:self.url];
        NSURLRequest *request =[NSURLRequest requestWithURL:nsurl];
        [webView loadRequest:request];
    }
    webView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
}

//开始加载数据
- (void)webViewDidStartLoad:(UIWebView *)sender {
    [activityIndicator startAnimating];
}

//数据加载完
- (void)webViewDidFinishLoad:(UIWebView *)sender {
    [activityIndicator stopAnimating];
    UIView *view = (UIView *)[self.view viewWithTag:999];
    [view removeFromSuperview];
    if (!webTitle) {
       self.navigationItem.title = [sender stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
    
}


- (void)cameraActionSheet:(CameraActionSheet *)sender didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 3) {
		return;
	}
}

- (BOOL)requestDidFinish:(BSClient *)sender obj:(NSDictionary *)obj
{
    if ([super requestDidFinish:sender obj:obj]) {
    
    }
    return NO;
}

@end
