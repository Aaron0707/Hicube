//
//  Service.h
//  Hicube
//
//  Created by AaronYang on 5/13/15.
//  Copyright (c) 2015 Aaron. All rights reserved.
//

#import "NSBaseObject.h"

@interface Service : NSBaseObject

@property (nonatomic, strong) NSString * ID;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * gallery;
@property (nonatomic, strong) NSString * price;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * type;
@property (nonatomic, strong) NSString * title;
@end
