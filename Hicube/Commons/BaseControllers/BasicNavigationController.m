//
//  BasicNavigationController.m
//  CarPool
//
//  Created by kiwi on 14-6-23.
//  Copyright (c) 2014年 NigasMone. All rights reserved.
//

#import "BasicNavigationController.h"
#import "BaseViewController.h"
#import "BaseNavigationBar.h"

@interface BasicNavigationController ()

@end

@implementation BasicNavigationController

- (id)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithNavigationBarClass:[BaseNavigationBar class] toolbarClass:nil];
    if (self) {
        self.viewControllers = @[rootViewController];
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)pushViewController:(BaseViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        [viewController showBackButton];
    } else {
        viewController.hidesBottomBarWhenPushed = NO;
    }
    [super pushViewController:viewController animated:animated];
}

-(void) popBack {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
