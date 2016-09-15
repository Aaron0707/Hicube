//
//  SimpleUser.h
//  Hicube
//
//  Created by AaronYang on 6/21/15.
//  Copyright (c) 2015 Aaron. All rights reserved.
//

#import "JSONModel.h"

@interface SimpleUser : JSONModel

@property (nonatomic, strong) NSString * username;
@property (nonatomic, strong) NSString * nickname;
@property (nonatomic, strong) NSString * avatar;
@property (nonatomic, strong) NSString * createTime;
@end
