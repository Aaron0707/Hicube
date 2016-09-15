//
//  HomeViewController.m
//  Hicube
//
//  Created by AaronYang on 5/9/15.
//  Copyright (c) 2015 Aaron. All rights reserved.
//

#import "HomeViewController.h"
#import "BannerView.h"
#import "StaffListViewController.h"
#import "ProductListViewController.h"
#import "UIImage+Lcy.h"
#import "Gallery.h"
#import "BranchListViewController.h"
#import "BaseTableViewCell.h"
#import "Work.h"
#import "UIImageView+WebCache.h"
#import "WorkDetailViewController.h"


#define space (Main_Screen_Height==480.00?5:10)
#define buttonSpace 20
#define buttonWidth (Main_Screen_Width-buttonSpace*6)/3
@interface HomeViewController ()<BannerViewDelegate,UIScrollViewDelegate>{
    BannerView * bannerView;
    NSMutableArray * galleries;
    NSString * phone;
    NSString * address;
    
    UIScrollView * scrollView;
    
    UIScrollView * workListView;
    
    NSMutableArray * datas;
}

@end

@implementation HomeViewController

-(id)init{
    if (self = [super init]) {
        galleries = [NSMutableArray array];
        datas = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.navigationController.delegate = self;
    self.navigationItem.title = @"首页";
    
    scrollView  = [[UIScrollView alloc]initWithFrame:self.view.frame];
    scrollView.centerY -=64;
    scrollView.height +=64;
    scrollView.delegate = self;
    [scrollView setBackgroundColor:bkgViewColor];
    [self.view addSubview:scrollView];
    
    bannerView = [[BannerView alloc] initWithFrame:CGRectMake(-2, 0, self.view.width+2, Main_Screen_Height==480.00?220:235)];
    [bannerView setPageControlHiden:NO];
    bannerView.delegate = self;
    [scrollView addSubview:bannerView];
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(buttonSpace, bannerView.bottom+space, buttonWidth, buttonWidth)];
    UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(buttonSpace*3+buttonWidth, bannerView.bottom+space, buttonWidth, buttonWidth)];
    UIButton *button3 = [[UIButton alloc]initWithFrame:CGRectMake(buttonSpace*5+buttonWidth*2, bannerView.bottom+space, buttonWidth, buttonWidth)];
    UIButton *button4 = [[UIButton alloc] initWithFrame:CGRectMake(buttonSpace, button1.bottom+space+20, buttonWidth, buttonWidth)];
    UIButton *button5 = [[UIButton alloc] initWithFrame:CGRectMake(buttonSpace*3+buttonWidth, button1.bottom+space+20, buttonWidth, buttonWidth)];
    
    [button1 setImage:[UIImage imageNamed:@"index_jituan"] forState:UIControlStateNormal];
    [button2 setImage:[UIImage imageNamed:@"index_home"] forState:UIControlStateNormal];
    [button3 setImage:[UIImage imageNamed:@"index_map"] forState:UIControlStateNormal];
    [button4 setImage:[UIImage imageNamed:@"index_chapin"] forState:UIControlStateNormal];
    [button5 setImage:[UIImage imageNamed:@"index_chart"] forState:UIControlStateNormal];
    
    [button1 setBackgroundColor:RGBCOLOR(105, 191, 254)];
    [button2 setBackgroundColor:RGBCOLOR(249, 115, 170)];
    [button3 setBackgroundColor:RGBCOLOR(249, 197, 75)];
    [button4 setBackgroundColor:RGBCOLOR(64, 192, 163)];
    [button5 setBackgroundColor:RGBCOLOR(191, 164, 115)];
    
    button1.layer.cornerRadius =
    button2.layer.cornerRadius =
    button3.layer.cornerRadius =
    button4.layer.cornerRadius =
    button5.layer.cornerRadius = buttonWidth/2;
    button1.tag = 1;
    button2.tag = 2;
    button3.tag = 3;
    button4.tag = 4;
    button5.tag = 5;
    
    UILabel * label1 = [[UILabel alloc] init];
    UILabel * label2 = [[UILabel alloc] init];
    UILabel * label3 = [[UILabel alloc] init];
    UILabel * label4 = [[UILabel alloc] init];
    UILabel * label5 = [[UILabel alloc] init];
    
    label1.size =
    label2.size =
    label3.size =
    label4.size =
    label5.size =CGSizeMake(60, 20);
    
    label1.center = CGPointMake(button1.centerX, button1.centerY+buttonWidth/2+10);
    label2.center = CGPointMake(button2.centerX, button2.centerY+buttonWidth/2+10);
    label3.center = CGPointMake(button3.centerX, button3.centerY+buttonWidth/2+10);
    label4.center = CGPointMake(button4.centerX, button4.centerY+buttonWidth/2+10);
    label5.center = CGPointMake(button5.centerX, button5.centerY+buttonWidth/2+10);
    
    label1.text = @"集团介绍";
    label2.text = @"联系前台";
    label3.text = @"地图导航";
    label4.text = @"产品介绍";
    label5.text = @"客服列表";
    
    label1.textColor =
    label2.textColor =
    label3.textColor =
    label4.textColor =
    label5.textColor = MygrayColor;
    
    label1.font =
    label1.font =
    label2.font =
    label3.font =
    label4.font =
    label5.font = [UIFont systemFontOfSize:14];
    
    label1.textAlignment =
    label2.textAlignment =
    label3.textAlignment =
    label4.textAlignment =
    label5.textAlignment = NSTextAlignmentCenter;
    
    [button1 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [button2 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [button3 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [button4 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [button5 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [scrollView addSubview:label1];
    [scrollView addSubview:label2];
    [scrollView addSubview:label3];
    [scrollView addSubview:label4];
    [scrollView addSubview:label5];
    
    
    [scrollView addSubview:button1];
    [scrollView addSubview:button2];
    [scrollView addSubview:button3];
    [scrollView addSubview:button4];
    [scrollView addSubview:button5];
    
    workListView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(label5.frame)+10, self.view.width, self.view.width/3+25)];
    //    workListView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    workListView.delegate = self;
    //    workListView.dataSource = self;
    [workListView setBackgroundColor:[UIColor whiteColor]];
    [scrollView addSubview:workListView];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    [self loadProfile];
    //    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SIGNOUT object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}


-(void)lodadWorks{
    client = [[BSClient alloc]initWithDelegate:self action:@selector(requestWorksDidFinis:obj:)];
    [client findHotwaresWithLimit:100 p:0];
}

#pragma mark -request did finish

-(void)requestWorksDidFinis:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        [datas removeAllObjects];
        NSArray * list = [obj getArrayForKey:@"list"];
        [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSMutableDictionary * dic = [obj mutableCopy];
            [dic setObject:[dic getStringValueForKey:@"id" defaultValue:@""] forKey:@"ID"];
            Work * work = [[Work alloc] initWithDictionary:dic error:nil];
            [datas addObject:work];
        }];
        if (datas.count==0) {
            workListView.hidden = YES;
        }else{
            workListView.hidden = NO;
            [self reloadWorkList];
            scrollView.contentSize = CGSizeMake(self.view.width, CGRectGetMaxY(workListView.frame)+44);
        }
    }
}
-(void)requestProfileDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        NSArray * list = [obj getArrayForKey:@"list"];
        NSMutableDictionary * dic = list[0];
        [dic setObject:[dic getStringValueForKey:@"id" defaultValue:@""] forKey:@"ID"];
        User * user = [[User alloc] initWithDictionary:dic error:nil];
        [[BSEngine currentEngine] setCurrentUser:user password:nil tok:nil];
    }
    [self loadIndex];
}

-(BOOL)requestDidFinish:(id)sender obj:(NSDictionary *)obj{
    
    if ([super requestDidFinish:sender obj:obj]) {
        [galleries removeAllObjects];
        NSArray * list = [obj getArrayForKey:@"list"];
        [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [obj setObject:[obj getStringValueForKey:@"id" defaultValue:@""] forKey:@"ID"];
            Gallery * gallery = [[Gallery alloc] initWithDictionary:obj error:nil];
            [galleries addObject:gallery];
        }];
        [bannerView reloadData];
        [self loadIndexSetting];
        return YES;
    }
    return NO;
}

-(void)requestIndexSettingDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        phone = [obj getStringValueForKey:@"phone" defaultValue:@""];
        address = [obj getStringValueForKey:@"address" defaultValue:@""];
        
        [self lodadWorks];
    }
}

-(void)reloadWorkList{
    
    [workListView removeAllSubviews];
    
    [workListView setContentSize:CGSizeMake(datas.count>0?datas.count*self.view.width/3:self.view.width, 130)];
    
    for (NSInteger idx = 0; idx<datas.count; idx++) {
        Work * work = datas[idx];
        UIView * workView = [[UIView alloc]initWithFrame:CGRectMake(idx*self.view.width/3, 0, self.view.width/3, self.view.width/3)];
        
        UIImageView * workImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, workView.width-20, workView.width-20)];
        workImage.layer.masksToBounds = YES;
        workImage.layer.cornerRadius = 6;
        [workImage sd_setImageWithURL:[NSURL URLWithString:work.gallery] placeholderImage:nil];
        [workView addSubview:workImage];
        
        UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(workImage.frame.origin.x, CGRectGetMaxY(workImage.frame)+5, workImage.width, 20)];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.textColor = MygrayColor;
        nameLabel.font = Chinese_Font_12;
        nameLabel.text = work.name;
        [workView addSubview:nameLabel];
        
        UIButton * touchButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.width/3, 130)];
        touchButton.tag = idx;
        [touchButton addTarget:self action:@selector(gotoWorkDetail:) forControlEvents:UIControlEventTouchUpInside];
        [workView addSubview:touchButton];
        [workListView addSubview:workView];
    }
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


- (void)imageProgressCompleted:(UIImage*)img indexPath:(NSIndexPath*)indexPath tag:(int)tag url:(NSString *)url {
    BannerCell *cell = [bannerView cellForPage:tag];
    cell.image = img;
}

- (void)bannerView:(BannerView*)sender tappedOnPage:(NSInteger)page {
    
}


#pragma mark -Util
-(void)buttonAction:(UIButton *)sender{
    switch (sender.tag) {
        case 1:{
            BranchListViewController * vc = [[BranchListViewController alloc]init];
            [self pushViewController:vc];
            break;
        }
        case 2:
            if ([phone hasValue]) {
                [Globals callAction:phone parentView:self.view];
            }
            break;
        case 3:
            if ([address hasValue]) {
                [Globals jumpToBaiduMapAppForMark:address];
            }
            break;
        case 4:
            [self pushViewController:[[ProductListViewController alloc]init]];
            break;
        case 5:
            [self pushViewController:[[StaffListViewController alloc]init]];
            break;
            
        default:
            break;
    }
}

-(void)gotoWorkDetail:(UIButton *)sender{
    Work * work = datas[sender.tag];
    WorkDetailViewController * vc = [[WorkDetailViewController alloc]init];
    vc.work = work;
    [self pushViewController:vc];
}

-(void)loadIndex{
    [super startRequest];
    [client findGalleries];
}

-(void)loadProfile{
    User * user = [BSEngine currentEngine].user;
    if (!user) {
        client =[[BSClient alloc] initWithDelegate:self action:@selector(requestProfileDidFinish:obj:)];
        [client findProfileByUsername:[BSEngine currentEngine].lastLogInUserPhone];
    }
    [self loadIndex];
    
}

-(void)loadIndexSetting{
    client = [[BSClient alloc]initWithDelegate:self action:@selector(requestIndexSettingDidFinish:obj:)];
    [client loadSystemSetting];
}



@end
