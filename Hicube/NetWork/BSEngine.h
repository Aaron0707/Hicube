//
//  BSEngine.h
//  HiCubeform
//
//  Created by kiwi on 14-1-15.
//  Copyright (c) 2013年 Kiwaro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

#define KBSLoginUserName @"HiCubeformLoginUserName"
#define KBSLoginPassWord @"HiCubeformLoginPassWord"
#define KBSCurrentUserInfo  @"HiCubeformUserInfo"
#define KBSCurrentPassword  @"HiCubeformPassWord"
#define KBSCurrentToken  @"HiCubeformToken"

@interface BSEngine : NSObject {
    
}

@property (nonatomic, strong)   User      *   user;
@property (nonatomic, strong)   NSArray   *   categoryArray; // 行业array
@property (nonatomic, strong)     NSString  *   passWord;
@property (nonatomic, strong)     NSString  *   lastLogInUserPhone;
@property (nonatomic, strong)     NSString  *   token; // 用户访问凭证

+ (BSEngine *) currentEngine;
+ (BSEngine *) allocWithZone:(NSZone *)zone;
- (id)copyWithZone:(NSZone *)zone;

- (void)setCurrentUser:(User*)item password:(NSString*)pwd tok:(NSString*)tok;
- (void)readAuthorizeData;
-(void)saveLastLogInUserPhone:(NSString *)lastLogIn;

- (void)signOut;
- (BOOL)isLoggedIn;

@end
