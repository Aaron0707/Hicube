//
//  BSClient.h
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-20.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Declare.h"
@class User,Reserve,Bill;

typedef enum
{
    REGISTER ,
    FORGETPASSWORD,
}PhoneVerifyType;



@interface BSClient : NSObject

@property (nonatomic, strong) NSString      * errorMessage;
@property (nonatomic, strong) NSIndexPath   * indexPath;
@property (nonatomic, strong) NSString      * tag;
@property (nonatomic, assign) BOOL          hasError;
//@property (nonatomic, assign) BOOL          isOldToken;
@property (nonatomic, assign) int           customErrorCode;

#pragma mark - init
- (id)initWithDelegate:(id)del action:(SEL)act;

- (void)showAlert;

- (void)cancel;



#pragma mark -login and regist
-(void)logInByPhone:(NSString *)phone pw:(NSString *)password;
-(void)registUser:(NSString *)phone pw:(NSString *)password verify:(NSString *)message;
-(void)getVerify:(NSString *)phone;
-(void)getVerifyForReset:(NSString *)phone;

-(void)resetPassword:(NSString *)username newPw:(NSString *)password verify:(NSString *)message;
#pragma mark -Profile
-(void)findProfileByUsername:(NSString *)phone;
-(void)updateProfile:(User *)user;
-(void)updateAvatar:(UIImage *)image;
-(void)updatePassword:(NSString *)newPassword oldPassword:(NSString*)oldPassword;
-(void)recharge:(NSString *)amout;

#pragma mark -Reserve
-(void)saveReserve:(Reserve *)reserve;
-(void)cancelReserve:(NSString *)reserveId;
-(void)findReservesWithLimit:(NSInteger)count p:(NSInteger)page;

#pragma mark -Service
-(void)findService:(NSString *)query limit:(NSInteger)count p:(NSInteger)page;

#pragma mark -Work
-(void)findWork:(NSString *)query limit:(NSInteger)count p:(NSInteger)page;
-(void)findProducts:(NSString *)query limit:(NSInteger)count p:(NSInteger)page;
-(void)findHotwaresWithLimit:(NSInteger)count p:(NSInteger)page;

#pragma mark -staff
-(void)findStaffWithlimit:(NSInteger)count p:(NSInteger)page;
#pragma mark -gallery
-(void)findGalleries:(NSString *)workId;
-(void)findGalleries;
#pragma mark -system
-(void)loadSystemSetting;
-(void)findAboutUs;
#pragma mark -branch company
-(void)loadCorPorations;

#pragma mark -bill
-(void)findBillsWithLimit:(NSInteger)count p:(NSInteger)page;
-(void)saveBill:(Bill *)bill;
-(void)cancelBill:(NSString *)billId;
-(void)findScoreSetting;


#pragma mark -withdraw
-(void)drawCashWtihBankName:(NSString *)bankName
             branchBankName:(NSString *)bBankName
                 accountNum:(NSString *)accountNum
                  ownerName:(NSString *)name
                     amount:(NSString *)amount;



#pragma mark -Recommended
-(void)isRichMember;
-(void)findMyRecommended;
-(void)findMyRecommendInCome;
-(void)findMyRecommendBillsWithPage:(NSInteger)p limit:(NSInteger)limit;


-(void)findAds;
@end