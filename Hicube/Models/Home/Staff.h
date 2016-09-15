//
//  Staff.h
//  Hicube
//
//  Created by AaronYang on 5/15/15.
//  Copyright (c) 2015 Aaron. All rights reserved.
//

#import "NSBaseObject.h"

@interface Staff : NSBaseObject
@property (nonatomic, strong) NSString * ID;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * avatar;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * phone;
@end
