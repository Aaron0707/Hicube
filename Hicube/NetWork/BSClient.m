//
//  BSClient.m
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-20.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "BSClient.h"
#import "BSEngine.h"
#import "StRequest.h"
#import "KAlertView.h"
#import "NSDictionaryAdditions.h"
#import "User.h"
#import "Bill.h"
#import "Reserve.h"


#import "KWAlertView.h"

@interface BSClient () <StRequestDelegate> {
    BOOL    needUID;
    BOOL    cancelled;
}

@property (nonatomic, assign)   id          delegate;
@property (nonatomic, assign)   SEL         action;
@property (nonatomic, strong)   StRequest   *   bsRequest;
@property (nonatomic, weak)     BSEngine    *   engine;

@end

@implementation BSClient
@synthesize action;
@synthesize bsRequest;
@synthesize engine;
@synthesize errorMessage;
@synthesize hasError;
@synthesize indexPath;
@synthesize customErrorCode;
@synthesize tag;
@synthesize delegate;


- (id)initWithDelegate:(id)del action:(SEL)act {
    self = [super init];
    if (self) {
        self.delegate = del;
        self.action = act;
        
        needUID = YES;
        self.hasError = YES;
        self.engine = [BSEngine currentEngine];
    }
    return self;
}

- (void)dealloc {
    Release(tag);
    Release(indexPath);
    Release(errorMessage);
    Release(action);
    Release(bsRequest);
    Release(engine);
    self.delegate = nil;
}

- (void)cancel {
    if (!cancelled) {
        [bsRequest disconnect];
        self.bsRequest = nil;
        cancelled = YES;
        self.action = nil;
        self.delegate = nil;
    }
}

- (void)showAlert {
    NSString* alertMsg = nil;
    if ([errorMessage isKindOfClass:[NSString class]] && errorMessage.length > 0) {
        alertMsg = errorMessage;
    } else {
        alertMsg = @"服务器出去晃悠了，等它一下吧！";
    }
    KWAlertView * alert = [[KWAlertView alloc] initWithTitle:@"提示" message:alertMsg delegate:nil cancelButtonTitle:@"确定" textViews:nil otherButtonTitles: nil];
    [alert show];
}

- (void)loadRequestWithDoMain:(BOOL)isDoMain
                   methodName:(NSString *)methodName
                       params:(NSMutableDictionary *)params
                 postDataType:(StRequestPostDataType)postDataType {
    [bsRequest disconnect];
    
    NSMutableDictionary* mutParams = [NSMutableDictionary dictionaryWithDictionary:params];
    if (needUID) {
        if (engine.token) {
            [mutParams setObject:engine.token forKey:@"token"];
        }
    }
    NSString * ID = [mutParams getStringValueForKey:@"ID" defaultValue:@""];
    if ([ID hasValue]) {
        [mutParams setObject:ID forKey:@"id"];
        [mutParams removeObjectForKey:@"ID"];
    }
    
    self.bsRequest = [StRequest requestWithURL:[NSString stringWithFormat:@"%@%@", KBSSDKAPIDomain, methodName]
                                    httpMethod:@"POST"
                                        params:mutParams
                                  postDataType:postDataType
                              httpHeaderFields:nil
                                      delegate:self];
    [bsRequest connect];
}

#pragma mark - StRequestDelegate Methods

- (void)request:(StRequest*)sender didFailWithError:(NSError *)error {
    if (cancelled) {
        return;
    }
    
    NSString * errorStr = [[error userInfo] objectForKey:@"error"];
    if (errorStr == nil || errorStr.length <= 0) {
        errorStr = [NSString stringWithFormat:@"%@", [error localizedDescription]];
    } else {
        errorStr = [NSString stringWithFormat:@"%@", [[error userInfo] objectForKey:@"error"]];
    }
    self.errorMessage = errorStr;
    NSLog(@"errorStr -======== %@",errorStr);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if (action && delegate) {
        [delegate performSelector:action withObject:self withObject:error];
    }
#pragma clang diagnostic pop
    self.bsRequest = nil;
}

-(void)request:(StRequest *)request didReceiveResponse:(NSURLResponse *)response{
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    switch ([httpResponse statusCode]) {
        case 404:
            [self cancel];
            self.hasError = YES;
            self.errorMessage = @"访问连接错误！！";
            [self showAlert];
            break;
        case 500:
            [self cancel];
            self.hasError = YES;
            self.errorMessage = @"服务器内部错误！！";
            [self showAlert];
            break;
        default:
            break;
    }
}

- (void)request:(StRequest*)sender didFinishLoadingWithResult:(NSDictionary*)result {
    if (cancelled) {
        return;
    }
    
    BOOL state = NO;
    if (result != nil && [result isKindOfClass:[NSDictionary class]]) {
//        state = [result getBoolValueForKey:@"state" defaultValue:NO];
        int codeNumber = [result getIntValueForKey:@"state" defaultValue:1];
        if (codeNumber==1) {
            state = YES;
        }
        self.hasError = !state;
        self.customErrorCode = state;
        if (!state) {
            self.errorMessage = [result getStringValueForKey:@"msg" defaultValue:nil];
        }
    }
    
    if (!state && self.errorMessage == nil) {
        self.errorMessage = @"让网络飞一会再说吧..";
    }
    
    self.bsRequest = nil;
    if (cancelled) {
        return;
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [delegate performSelector:action withObject:self withObject:result];
#pragma clang diagnostic pop
    
}



//==================================request==================
-(void)logInByPhone:(NSString *)phone pw:(NSString *)password{
    
    needUID = NO;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:phone forKey:@"username"];
    [params setObject:password forKey:@"password"];
    [self loadRequestWithDoMain:YES
                     methodName:@"login.htm"
                         params:params
                   postDataType:KSTRequestPostDataTypeNormal];
    
}

-(void)registUser:(NSString *)phone pw:(NSString *)password verify:(NSString *)message{
    needUID = NO;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:phone forKey:@"username"];
    [params setObject:password forKey:@"password"];
    [params setObject:message forKey:@"verifyCode"];
    [self loadRequestWithDoMain:YES
                     methodName:@"register.htm"
                         params:params
                   postDataType:KSTRequestPostDataTypeNormal];
}

-(void)getVerify:(NSString *)phone{
    needUID = NO;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:phone forKey:@"username"];
    [self loadRequestWithDoMain:YES
                     methodName:@"sendRegisterCode.htm"
                         params:params
                   postDataType:KSTRequestPostDataTypeNormal];
}

-(void)getVerifyForReset:(NSString *)phone{
    needUID = NO;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:phone forKey:@"username"];
    [self loadRequestWithDoMain:YES
                     methodName:@"sendForgetCode.htm"
                         params:params
                   postDataType:KSTRequestPostDataTypeNormal];
}

-(void)resetPassword:(NSString *)username newPw:(NSString *)password verify:(NSString *)message{
    needUID = NO;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:username forKey:@"username"];
    [params setObject:password forKey:@"newPassword"];
    [params setObject:message forKey:@"verifyCode"];
    [self loadRequestWithDoMain:YES
                     methodName:@"resetPassword.htm"
                         params:params
                   postDataType:KSTRequestPostDataTypeNormal];
}

-(void)findProfileByUsername:(NSString *)phone{
    needUID = NO;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:phone forKey:@"username"];
    [self loadRequestWithDoMain:YES
                     methodName:@"findProfileByUsername.htm"
                         params:params
                   postDataType:KSTRequestPostDataTypeNormal];
}

-(void)updateProfile:(User *)user{
    NSMutableDictionary * params = (NSMutableDictionary *)[user toDictionary];
    [self loadRequestWithDoMain:YES
                     methodName:@"updateProfile.htm"
                         params:params
                   postDataType:KSTRequestPostDataTypeNormal];
}

-(void)updatePassword:(NSString *)newPassword oldPassword:(NSString *)oldPassword{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    if ([newPassword hasValue]) {
        [params setObject:newPassword forKey:@"newPassword"];
    }
    if ([oldPassword hasValue]) {
        [params setObject:oldPassword forKey:@"oldPassword"];
    }

    [self loadRequestWithDoMain:YES
                     methodName:@"updatePassword.htm"
                         params:params
                   postDataType:KSTRequestPostDataTypeNormal];
}

-(void)updateAvatar:(UIImage *)image{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    [params setObject:image forKey:@"file"];
    [self loadRequestWithDoMain:YES
                     methodName:@"updateAvatar.htm"
                         params:params
                   postDataType:KSTRequestPostDataTypeMultipart];

}

-(void)recharge:(NSString *)amount{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:amount forKey:@"amount"];
    [self loadRequestWithDoMain:YES
                     methodName:@"recharge.htm"
                         params:params
                   postDataType:KSTRequestPostDataTypeNormal];
  
}

#pragma mark -Reserve
-(void)saveReserve:(Reserve *)reserve{
    NSMutableDictionary * params = [[reserve toDictionary] mutableCopy];
    [self loadRequestWithDoMain:YES
                     methodName:@"order.htm"
                         params:params
                   postDataType:KSTRequestPostDataTypeNormal];
}

-(void)cancelReserve:(NSString *)reserveId{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    if ([reserveId hasValue]) {
        [params setObject:reserveId forKey:@"id"];
    }
    [self loadRequestWithDoMain:YES
                     methodName:@"cancelOrder.htm"
                         params:params
                   postDataType:KSTRequestPostDataTypeNormal];
}

-(void)findReservesWithLimit:(NSInteger)count p:(NSInteger)page{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    if (count >0) {
        [params setObject:[NSString stringWithFormat:@"%li",(long)count] forKey:@"limit"];
    }
    if (page>1) {
        [params setObject:[NSString stringWithFormat:@"%li",(long)page] forKey:@"p"];
    }
    [self loadRequestWithDoMain:YES
                     methodName:@"orders.htm"
                         params:params
                   postDataType:KSTRequestPostDataTypeNormal];
}

#pragma mark -service
-(void)findService:(NSString *)query limit:(NSInteger)count p:(NSInteger)page{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    if ([query hasValue]) {
        [params setObject:query forKey:@"query"];
    }
    if (count >0) {
        [params setObject:[NSString stringWithFormat:@"%li",(long)count] forKey:@"limit"];
    }
    if (page>1) {
        [params setObject:[NSString stringWithFormat:@"%li",(long)count] forKey:@"p"];
    }
    [self loadRequestWithDoMain:YES
                     methodName:@"services.htm"
                         params:params
                   postDataType:KSTRequestPostDataTypeNormal];
    
}
#pragma mark -service
-(void)findWork:(NSString *)query limit:(NSInteger)count p:(NSInteger)page{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    if ([query hasValue]) {
        [params setObject:query forKey:@"query"];
    }
    if (count >0) {
        [params setObject:[NSString stringWithFormat:@"%li",(long)count] forKey:@"limit"];
    }
    if (page>1) {
        [params setObject:[NSString stringWithFormat:@"%li",(long)count] forKey:@"p"];
    }
    [self loadRequestWithDoMain:YES
                     methodName:@"wares.htm"
                         params:params
                   postDataType:KSTRequestPostDataTypeNormal];
}
-(void)findProducts:(NSString *)query limit:(NSInteger)count p:(NSInteger)page{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    if ([query hasValue]) {
        [params setObject:query forKey:@"query"];
    }
    if (count >0) {
        [params setObject:[NSString stringWithFormat:@"%li",(long)count] forKey:@"limit"];
    }
    if (page>1) {
        [params setObject:[NSString stringWithFormat:@"%li",(long)count] forKey:@"p"];
    }
    [self loadRequestWithDoMain:YES
                     methodName:@"products.htm"
                         params:params
                   postDataType:KSTRequestPostDataTypeNormal];
}

-(void)findHotwaresWithLimit:(NSInteger)count p:(NSInteger)page{
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
    if (count >0) {
        [params setObject:[NSString stringWithFormat:@"%li",(long)count] forKey:@"limit"];
    }
    if (page>1) {
        [params setObject:[NSString stringWithFormat:@"%li",(long)count] forKey:@"p"];
    }
    [self loadRequestWithDoMain:YES
                     methodName:@"hotwares.htm"
                         params:params
                   postDataType:KSTRequestPostDataTypeNormal];
}

#pragma mark -staff
-(void)findStaffWithlimit:(NSInteger)count p:(NSInteger)page{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];

    if (count >0) {
        [params setObject:[NSString stringWithFormat:@"%li",(long)count] forKey:@"limit"];
    }
    if (page>1) {
        [params setObject:[NSString stringWithFormat:@"%li",(long)count] forKey:@"p"];
    }
    [self loadRequestWithDoMain:YES
                     methodName:@"staffs.htm"
                         params:params
                   postDataType:KSTRequestPostDataTypeNormal];

}

#pragma mark -grallery
-(void)findGalleries:(NSString *)workId{
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    if ([workId hasValue]) {
        [params setObject:workId forKey:@"id"];
    }
    
    [self loadRequestWithDoMain:YES
                     methodName:@"galleries.htm"
                         params:params
                   postDataType:KSTRequestPostDataTypeNormal];

}
-(void)findGalleries{
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [self loadRequestWithDoMain:YES
                     methodName:@"surface.htm"
                         params:params
                   postDataType:KSTRequestPostDataTypeNormal];
}

#pragma mark -system
-(void)loadSystemSetting{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [self loadRequestWithDoMain:YES
                     methodName:@"systemSetting.htm"
                         params:params
                   postDataType:KSTRequestPostDataTypeNormal];
}

-(void)findAboutUs{
    [self loadRequestWithDoMain:YES
                     methodName:@"about.htm"
                         params:[NSMutableDictionary dictionary]
                   postDataType:KSTRequestPostDataTypeNormal];

}
#pragma mark -branch company
-(void)loadCorPorations{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [self loadRequestWithDoMain:YES
                     methodName:@"corporations.htm"
                         params:params
                   postDataType:KSTRequestPostDataTypeNormal];

}

#pragma mark -bill
-(void)findBillsWithLimit:(NSInteger)count p:(NSInteger)page{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    if (count >0) {
        [params setObject:[NSString stringWithFormat:@"%li",(long)count] forKey:@"limit"];
    }
    if (page>1) {
        [params setObject:[NSString stringWithFormat:@"%li",(long)page] forKey:@"p"];
    }
    [self loadRequestWithDoMain:YES
                     methodName:@"bills.htm"
                         params:params
                   postDataType:KSTRequestPostDataTypeNormal];
}

-(void)saveBill:(Bill *)bill{
    NSMutableDictionary * params = [[bill toDictionary] mutableCopy];
    if (bill.useScore) {
        [params setObject:@"true" forKey:@"userScore"];
    }else{
        [params setObject:@"false" forKey:@"userScore"];
    }
    if (bill.userBalance) {
        [params setObject:@"true" forKey:@"useBalance"];
    }else{
        [params setObject:@"false" forKey:@"balance"];
    }
    [self loadRequestWithDoMain:YES
                     methodName:@"bill.htm"
                         params:params
                   postDataType:KSTRequestPostDataTypeNormal];

}

-(void)cancelBill:(NSString *)billId{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    if ([billId hasValue]) {
        [params setObject:billId forKey:@"id"];
    }
    
    [self loadRequestWithDoMain:YES
                     methodName:@"cancelBill.htm"
                         params:params
                   postDataType:KSTRequestPostDataTypeNormal];
}

-(void)findScoreSetting{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [self loadRequestWithDoMain:YES
                     methodName:@"scoreSetting.htm"
                         params:params
                   postDataType:KSTRequestPostDataTypeNormal];
}

#pragma mark - drawCash
-(void)drawCashWtihBankName:(NSString *)bankName branchBankName:(NSString *)bBankName accountNum:(NSString *)accountNum ownerName:(NSString *)name amount:(NSString *)amount{
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:bankName forKey:@"bankName"];
    [para setObject:bBankName forKey:@"branchBankName"];
    [para setObject:accountNum forKey:@"accountNumber"];
    [para setObject:name forKey:@"ownerName"];
    [para setObject:amount forKey:@"amount"];
    
    [self loadRequestWithDoMain:YES
                     methodName:@"withdraw.htm"
                         params:para
                   postDataType:KSTRequestPostDataTypeNormal];
}

#pragma mark findMyRecommended
-(void)isRichMember{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [self loadRequestWithDoMain:YES
                     methodName:@"isRichMember.htm"
                         params:para
                   postDataType:KSTRequestPostDataTypeNormal];
}
-(void)findMyRecommended{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [self loadRequestWithDoMain:YES
                     methodName:@"recommended.htm"
                         params:para
                   postDataType:KSTRequestPostDataTypeNormal];
}
-(void)findMyRecommendInCome{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [self loadRequestWithDoMain:YES
                     methodName:@"recommendIncome.htm"
                         params:para
                   postDataType:KSTRequestPostDataTypeNormal];
}

-(void)findMyRecommendBillsWithPage:(NSInteger)p limit:(NSInteger)limit{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    if (limit>0) {
        [para setObject:@(limit) forKey:@"limit"];
    }
    if (p>1) {
        [para setObject:@(p) forKey:@"p"];
    }
    [self loadRequestWithDoMain:YES
                     methodName:@"recommendBills.htm"
                         params:para
                   postDataType:KSTRequestPostDataTypeNormal];

}

-(void)findAds{
        NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [self loadRequestWithDoMain:YES
                     methodName:@"ads.htm"
                         params:para
                   postDataType:KSTRequestPostDataTypeNormal];
}
@end