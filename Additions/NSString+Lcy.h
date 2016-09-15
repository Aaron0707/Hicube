//
//  NSString+Lcy.h
//  新浪微博
//
//  Created by 神说有光 on 14-6-22.
//  Copyright (c) 2014年 Our Dream. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Lcy)

-(NSString *)joinFileName:(NSString *)joinString;
-(NSDate *)dateYMDHMSFromString;
/**
 *  计算文字大小
 *
 *  @param font   字体
 *  @param width  宽度
 *  @param height 高度
 *  @param mode   模式
 *
 *  @return 尺寸
 */
-(CGSize)stringSizeWithFont:(UIFont *)font width:(CGFloat)width height:(CGFloat)height mode:(NSLineBreakMode) mode;

-(NSUInteger)lengthOfBytesUsingUTF8;

+ (instancetype)nilToEmptyStringWithString:(NSString *)string;
@end
