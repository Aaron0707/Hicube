//
//  WorkDetailViewController.m
//  Hicube
//
//  Created by AaronYang on 5/16/15.
//  Copyright (c) 2015 Aaron. All rights reserved.
//

#import "WorkDetailViewController.h"
#import "BannerView.h"
#import "Work.h"
#import "Gallery.h"
#import "UIImage+Lcy.h"
#import "UIImage+FlatUI.h"
#import "CreatebillViewController.h"

@interface WorkDetailViewController ()<BannerViewDelegate>{
    BannerView * bannerView;
    NSMutableArray * galleries;
}

@end

@implementation WorkDetailViewController

-(id)init{
    if (self = [super init]) {
        galleries = [NSMutableArray array];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"商品详情";
    
    bannerView = [[BannerView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, Main_Screen_Height==480.00?250:265)];
    [bannerView setPageControlHiden:NO];
    bannerView.delegate = self;
    [bannerView setPageControlHiden:YES];
    [self.view addSubview:bannerView];

    UILabel * priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, bannerView.bottom+10, (self.view.width-20)/2+20, 40)];
    priceLabel.font = [UIFont systemFontOfSize:26];
    priceLabel.textColor = NavOrBarTinColor;
    priceLabel.text = [NSString stringWithFormat:@"￥%@元",self.work.price];
    [self.view addSubview:priceLabel];
    
    UIButton * buyButton = [[UIButton alloc]initWithFrame:CGRectMake(priceLabel.right, bannerView.bottom+10, (self.view.width-20)/2-20, 40)];
    [buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    [buyButton commonStyle];
    [buyButton setBackgroundColor:RGBCOLOR(248, 197, 76)];
    [buyButton addTarget:self action:@selector(buy) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buyButton];
    
    UIImageView *line = [[UIImageView alloc]initWithImage:[UIImage imageWithColor:RGBCOLOR(239, 239, 239) cornerRadius:1]];
    line.frame = CGRectMake(0, buyButton.bottom+10, self.view.width, 1);
    [self.view addSubview:line];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, line.bottom, 100, 30)];
    label.text = @"商品介绍:";
    label.textColor = [UIColor grayColor];
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    [self.view addSubview:label];
    
    self.work.content = @"  发的卡拉斯加饭肯定撒垃圾费快乐到死的 的疯狂撒酒疯肯定撒激发代课老师;\n减肥的快乐撒风景圣诞快乐; ";
    CGSize size = [self.work.content sizeWithFont:[UIFont systemFontOfSize:12] maxWidth:self.view.width-20 maxNumberLines:10];
    size.height +=10;
    
    UITextView * textView = [[UITextView alloc]initWithFrame:CGRectMake(10, label.bottom, self.view.width-20, 100)];
    textView.size = size;
    textView.font = [UIFont systemFontOfSize:12];
    textView.text = self.work.content;
    textView.userInteractionEnabled = NO;
    textView.textColor = [UIColor grayColor];
    [self.view addSubview:textView];
    
    if ([self.work.gallery hasValue]) {
        Gallery * gallery = [Gallery new];
        gallery.gallery = self.work.gallery;
        [galleries addObject:gallery];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    if ([galleries count]<2) {
        [self loadGalleries];
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - request did finish
-(BOOL)requestDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        NSArray * list = [obj getArrayForKey:@"list"];
        [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSMutableDictionary * dic = [obj mutableCopy];
            [dic setObject:[dic getStringValueForKey:@"id" defaultValue:@""] forKey:@"ID"];
            Gallery * gallery = [[Gallery alloc] initWithDictionary:dic error:nil];
            [galleries addObject:gallery];
        }];
        [bannerView reloadData];
        return YES;
    }
    return NO;
}
#pragma mark -banner view delegate
- (NSInteger)numberOfPagesInBannerView:(BannerView*)sender {
    return galleries.count;
}

- (BannerCell*)bannerView:(BannerView*)sender cellForPage:(NSInteger)page {
    BannerCell* cell = [sender cellForPage:page];
    if (cell == nil) {
        cell = [[BannerCell alloc] initWithPage:page];
    }
    Gallery * gallery = galleries[page];
    NSString *urlStr = gallery.gallery;
    cell.image = [Globals getImageGray];
    [Globals imageDownload:^(UIImage *img) {
        cell.image = img;
    } url:urlStr];
    return cell;
}

- (void)bannerView:(BannerView*)sender willDisplayCell:(BannerCell*)cell forPage:(NSInteger)page {
    
    Gallery * gallery = galleries[page];
    NSString *urlStr = gallery.gallery;
    cell.image = [Globals getImageGray];
    [Globals imageDownload:^(UIImage *img) {
        cell.image = img;
    } url:urlStr];
}

- (void)imageProgressCompleted:(UIImage*)img indexPath:(NSIndexPath*)indexPath tag:(int)tag url:(NSString *)url {
    BannerCell *cell = [bannerView cellForPage:tag];
    cell.image = img;
}

- (void)bannerView:(BannerView*)sender tappedOnPage:(NSInteger)page {
    
}


-(void)loadGalleries{
    if (self.work && [self.work.ID hasValue]) {
        [super startRequest];
        [client findGalleries:self.work.ID];
    }
}

-(void)buy{
    if (!self.work) {
        [self showText:@"商品数据错误无法购买"];
    }
    CreatebillViewController  *vc = [[CreatebillViewController alloc]init];
    vc.work = self.work;
    [self pushViewController: vc];
}
@end
