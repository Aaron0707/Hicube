//
//  AboutUsViewController.m
//  Hicube
//
//  Created by AaronYang on 6/22/15.
//  Copyright (c) 2015 Aaron. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()
{
    UITextView * view;
}
@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"海立方";
    view = [[UITextView alloc]initWithFrame:self.view.frame];
    view.editable = NO;
    [self.view addSubview:view];
    if ([self.content hasValue]) {
        view.text = self.content;
    }
    
    [self loadContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)loadContent{
    if ([super startRequest]) {
        [client findAboutUs];
    }
}

-(BOOL)requestDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        NSString *content = [obj valueForKey:@"msg"];
        self.content =content;
        view.text = content;
    }
    return YES;
}

@end
