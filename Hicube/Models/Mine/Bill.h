//
//  Bill.h
//  Hicube
//
//  Created by AaronYang on 5/23/15.
//  Copyright (c) 2015 Aaron. All rights reserved.
//

#import "NSBaseObject.h"

@interface Bill : NSBaseObject
@property (nonatomic, strong) NSString * ID;
@property (nonatomic, strong) NSString * createTime;
@property (nonatomic, strong) NSString<Optional> * creatorId;
@property (nonatomic, strong) NSString * status;
@property (nonatomic, strong) NSString * wareId;
@property (nonatomic, strong) NSString * wareName;
@property (nonatomic, strong) NSString * gallery;
@property (nonatomic, strong) NSString * price;
@property (nonatomic, strong) NSString * num;
@property (nonatomic, strong) NSString * totalPrice;
@property (nonatomic, assign) BOOL  useScore;
@property (nonatomic, assign) BOOL  userBalance;
@property (nonatomic, strong) NSString * score;
@property (nonatomic, strong) NSString * balance;
@property (nonatomic, strong) NSString * needPayment;

@end
