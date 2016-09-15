//
//  InCome.h
//  Hicube
//
//  Created by AaronYang on 6/21/15.
//  Copyright (c) 2015 Aaron. All rights reserved.
//

#import "JSONModel.h"

@interface InCome : JSONModel

@property (nonatomic, strong) NSString * amount;
@property (nonatomic, strong) NSString * preBalance;
@property (nonatomic, strong) NSString * postBalance;
@property (nonatomic, strong) NSString * userId;
@property (nonatomic, strong) NSString * targetUserId;
@property (nonatomic, strong) NSString * createTime;
@property (nonatomic, strong) NSString * remark;
@property (nonatomic, strong) NSString * nickname;
@property (nonatomic, strong) NSString<Optional> * totalAmount;
@end
