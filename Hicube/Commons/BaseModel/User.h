//
//  User.h
//  Hicube
//
//  Created by AaronYang on 5/9/15.
//  Copyright (c) 2015 Aaron. All rights reserved.
//

#import "NSBaseObject.h"

@interface User : NSBaseObject
@property (nonatomic, strong) NSString * ID;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSString * avatar;
@property (nonatomic, strong) NSString * gender;
@property (nonatomic, strong) NSString * currentTown;
@property (nonatomic, strong) NSString * homeTown;
@property (nonatomic, strong) NSString * nickname;
@property (nonatomic)         BOOL       openPhone;
@property (nonatomic, strong) NSString * signature;
@property (nonatomic, strong) NSString * truename;
@property (nonatomic, strong) NSString * score;
@property (nonatomic, assign) double  balance;

@end
