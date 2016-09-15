//
//  ViewController.m
//  Hicube
//
//  Created by AaronYang on 5/8/15.
//  Copyright (c) 2015 AaronYang. All rights reserved.
//

#import "ViewController.h"
#import "BasicNavigationController.h"
#import "BSEngine.h"
#import "AppDelegate.h"
#import "UIImage+FlatUI.h"
#import "UIColor+FlatUI.h"
#import "Globals.h"

#import "BSClient.h"
#import "UIImageView+WebCache.h"

#define imageTabBar(idx) LOADIMAGECACHES(([NSString stringWithFormat:@"bottom_%d",idx]))
#define imageTabBarD(idx) LOADIMAGECACHES(([NSString stringWithFormat:@"bottom_%d_color",idx]))
@interface ViewController ()<UIGestureRecognizerDelegate, UITabBarControllerDelegate> {
    NSMutableArray  *   rootConArr;
    int                 selectIndex;
    int                 msgCount;
    BSClient *client;
    UIScrollView * scrollView;
}


@end

@implementation ViewController

- (id)init {
    if (self = [super init]) {
        // Custom initialization
        self.controllerArr = [NSMutableArray array];
        rootConArr = [[NSMutableArray alloc] init];
//        [self initTabbarControllers];
    }
    return self;
}

- (void)dealloc {
    Release(_controllerArr);
    Release(rootConArr);
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    [scrollView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:scrollView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate * delegate = [AppDelegate instance];
    if (!delegate.showAds) {
        client = [[BSClient alloc]initWithDelegate:self action:@selector(requestDidFinish:obj:)];
        [client findAds];
    }else{
        [scrollView removeFromSuperview];
        [self initTabbarControllers];
    }
}


-(void)requestDidFinish:(BSClient *)sender obj:(NSDictionary *)obj{
    client = nil;
    if (sender.hasError) {
        [sender showAlert];
    }
    NSArray * list = [obj valueForKey:@"list"];
    
    __weak typeof (self)  weakSelf = self;
    [scrollView removeAllSubviews];
    [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIImageView * imageview = [[UIImageView alloc]initWithFrame:weakSelf.view.frame];
//        imageview.contentMode = UIViewContentModeScaleAspectFit;
        imageview.left = idx*weakSelf.view.width;
        [imageview sd_setImageWithURL:[NSURL URLWithString:[obj valueForKey:@"gallery"]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (list.count ==idx+1) {
                UIView * view = [[UIView alloc]initWithFrame:imageview.frame];
                view.left = (list.count-1)*weakSelf.view.width;
                [view setBackgroundColor:[UIColor clearColor]];
                UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(20, imageview.height-60, imageview.width-40, 40)];
                [button setTitle:@"立即体验" forState:UIControlStateNormal];
                [button commonStyle];
                [button addTarget:weakSelf action:@selector(initTabbarControllers) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:button];
                [scrollView addSubview:view];
                [scrollView bringSubviewToFront:view];
            }
        }];
        
        [scrollView addSubview:imageview];
    }];
    [scrollView setContentSize:CGSizeMake(list.count*self.view.width, self.view.height)];
    AppDelegate * delegate = [AppDelegate instance];
    delegate.showAds = YES;
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
     // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
   UIGraphicsBeginImageContext(size);
   // 绘制改变大小的图片
   [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
   // 从当前context中创建一个改变大小后的图片
   UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
   UIGraphicsEndImageContext();
   // 返回新的改变大小后的图片
  return scaledImage;
}

#define TitleArr @[@"首页",@"预约",@"商城",@"创富系统",@"个人中心"]
#define ControllerclassArr  @[@"HomeViewController" , @"ReserveViewController",@"WorkListViewController",@"SysViewController", @"MineViewController"]

- (UITabBarItem *)tabBarItemAtindex:(int)idx {
    UITabBarItem * barItem = nil;
    NSString * name = TitleArr[idx];
    UIFont* font = [UIFont systemFontOfSize:12];
    
        barItem = [[UITabBarItem alloc] initWithTitle:name image:imageTabBar(idx) selectedImage:imageTabBarD(idx)];
        [barItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:NavOrBarTinColor, NSForegroundColorAttributeName,
                                         font,NSFontAttributeName,
                                         nil] forState:UIControlStateSelected];
        [barItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                         BkgFontColor, NSForegroundColorAttributeName,
                                         font,NSFontAttributeName,
                                         nil] forState:UIControlStateNormal];
    return barItem;
}

- (void)initTabbarControllers {
    
    scrollView.hidden = YES;
    [ControllerclassArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Class class = NSClassFromString(ControllerclassArr[idx]);
        UIViewController * tmpCon = [[class alloc] init];
        UITabBarItem * barItem = [self tabBarItemAtindex:(int)idx];
        tmpCon.tabBarItem = barItem;
        
        [rootConArr addObject:tmpCon];
        BasicNavigationController* navCon = [[BasicNavigationController alloc] initWithRootViewController:tmpCon];
        
        navCon.tabBarItem = barItem;
        [self.controllerArr addObject:navCon];
    }];
    self.delegate = self;
    self.tabBar.backgroundColor = NavOrBarTinColor;
    self.viewControllers = _controllerArr;
    
    if (Sys_Version < 7) {
        [self.tabBar setTintColor:[UIColor whiteColor]];
    } else {
        self.tabBar.translucent = NO;
        [self.tabBar setBarTintColor:[UIColor whiteColor]];
    }
    
    AppDelegate * delegate = [AppDelegate instance];
    delegate.viewControllers = _controllerArr;
}

@end
