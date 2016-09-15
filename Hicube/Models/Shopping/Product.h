//
//  Product.h
//  Hicube
//
//  Created by AaronYang on 5/24/15.
//  Copyright (c) 2015 Aaron. All rights reserved.
//

#import "JSONModel.h"

@interface Product : JSONModel
@property (nonatomic, strong) NSString * ID;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * gallery;
@property (nonatomic, strong) NSString<Optional> * content;
@property (nonatomic, strong) NSString<Optional> * title;

@end
