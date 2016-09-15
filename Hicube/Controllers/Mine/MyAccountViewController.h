//
//  MyAccountViewController.h
//  Hicube
//
//  Created by AaronYang on 6/3/15.
//  Copyright (c) 2015 Aaron. All rights reserved.
//

#import "BaseTableViewController.h"

@class User;
@interface MyAccountViewController : BaseTableViewController

@property (nonatomic, strong) User * user;
@end
