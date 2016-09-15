//
//  ServiceListViewController.h
//  Hicube
//
//  Created by AaronYang on 5/14/15.
//  Copyright (c) 2015 Aaron. All rights reserved.
//

#import "BaseTableViewController.h"
@class Service;

@protocol ServiceListViewControllerDelegate <NSObject>

-(void)selectedService:(Service *)service;

@end
@interface ServiceListViewController : BaseTableViewController

@property (nonatomic, weak) id<ServiceListViewControllerDelegate>  delegate;
@end
