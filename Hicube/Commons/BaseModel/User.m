//
//  User.m
//  Hicube
//
//  Created by AaronYang on 5/9/15.
//  Copyright (c) 2015 Aaron. All rights reserved.
//

#import "User.h"

@implementation User


-(double)balance{
    NSString * dob = [NSString stringWithFormat:@"%.2f",_balance];
    return [dob doubleValue];
}
@end
