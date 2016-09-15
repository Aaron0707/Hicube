//
//  BSClient.m
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-20.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "BSEngine.h"
#import "Globals.h"
#import "NSStringAdditions.h"

static BSEngine * _currentBSEngine = nil;

@interface BSEngine () {
    
}

@end

@implementation BSEngine

@synthesize user ;
@synthesize passWord;
@synthesize token;

#pragma mark - BSEngine Life Circle
+ (BSEngine *) currentEngine {
    
      @synchronized(self){  //为了确保多线程情况下，仍然确保实体的唯一性
        if (!_currentBSEngine) {
            _currentBSEngine = [[BSEngine alloc] init];
        }
      }
	return _currentBSEngine;
}

+(id)allocWithZone:(NSZone *)zone{
    @synchronized(self){
        if (!_currentBSEngine) {
            _currentBSEngine = [super allocWithZone:zone]; //确保使用同一块内存地址
            return _currentBSEngine;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone{
    
    return self; //确保copy对象也是唯一
    
}



- (id)init {
    if (self = [super init]) {
        [self readAuthorizeData];
    }
    return self;
}

- (void)dealloc {
    self.categoryArray = nil;
    self.token = nil;
    self.passWord = nil;
    self.lastLogInUserPhone = nil;
    self.user = nil;
}

#pragma mark - BSEngine Private Methods

- (void)saveAuthorizeData {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:user];
    if (data) {
        [defaults setObject:data forKey:KBSCurrentUserInfo];
        if (passWord) {
            [defaults setObject:passWord forKey:KBSCurrentPassword];
        }
    }
    if (token) {
        [defaults setObject:token forKey:KBSCurrentToken];
    }
    if (self.lastLogInUserPhone) {
        [defaults setObject:self.lastLogInUserPhone forKey:KBSLoginUserName];
    }
	[defaults synchronize];
}

- (void)readAuthorizeData {
    self.user = nil;
    self.passWord = nil;
    self.token = nil;
    self.lastLogInUserPhone = nil;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSData* data = [defaults objectForKey:KBSCurrentUserInfo];
    NSString* pwd = [defaults objectForKey:KBSCurrentPassword];
    NSString* tok = [defaults objectForKey:KBSCurrentToken];
    NSString* lastLogIn = [defaults objectForKey:KBSLoginUserName];
    if (data) {
        self.user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    if (pwd) {
        self.passWord = pwd;
    }
    if (tok) {
        self.token = tok;
    }
    if (lastLogIn) {
        self.lastLogInUserPhone = lastLogIn;
    }
}

- (void)deleteAuthorizeData {
    self.user = nil;
    self.passWord = nil;
    
    self.token = nil;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults removeObjectForKey:KBSCurrentUserInfo];
    [defaults removeObjectForKey:KBSCurrentPassword];
    [defaults removeObjectForKey:KBSCurrentToken];
    
	[defaults synchronize];
}

- (void)setCurrentUser:(User*)item password:(NSString*)pwd tok:(NSString*)tok{
    if (item) {
        self.user = item;
    }
    if (pwd) {
         self.passWord = pwd;
    }
    if (tok) {
         self.token = tok;
    }
    NSLog(@"保存的登录对象 %@",item);
    NSLog(@"保存的登录token %@",tok);
    
    [self saveAuthorizeData];
}

#pragma mark - BSEngine Public Methods

- (void)signOut {
    [self deleteAuthorizeData];
}

#pragma mark Authorization

- (BOOL)isLoggedIn {
    return self.token.hasValue;
}

-(void)saveLastLogInUserPhone:(NSString *)lastLogIn{
    if (lastLogIn) {
         self.lastLogInUserPhone = lastLogIn;
    }
    [self saveAuthorizeData];
}
@end
