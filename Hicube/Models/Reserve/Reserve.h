//
//  Reserve.h
//  Hicube
//
//  Created by AaronYang on 5/13/15.
//  Copyright (c) 2015 Aaron. All rights reserved.
//

#import "NSBaseObject.h"

@interface Reserve : NSBaseObject
@property (nonatomic, strong) NSString * ID;
@property (nonatomic, strong) NSString * status;
@property (nonatomic, strong) NSString * wareId;
@property (nonatomic, strong) NSString * wareName;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSString * serviceYmd;
@property (nonatomic, strong) NSString * serviceHm;
@property (nonatomic, strong) NSString * gallery;
@property (nonatomic, strong) NSString * price;
@property (nonatomic, strong) NSString * createTime;
@property (nonatomic, strong) NSString * num;
@end
