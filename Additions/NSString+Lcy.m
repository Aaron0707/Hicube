//
//  NSString+Lcy.m
//  新浪微博
//
//  Created by 神说有光 on 14-6-22.
//  Copyright (c) 2014年 Our Dream. All rights reserved.
//

#import "NSString+Lcy.h"

@implementation NSString (Lcy)

-(NSString *)joinFileName:(NSString *)joinString
{
    NSString* ext = [self pathExtension];
    NSString* name = [self stringByDeletingPathExtension];
    name = [name stringByAppendingString:joinString];
    return ![ext isEqualToString:@""] ? [name stringByAppendingPathExtension:ext] : name;
}

+ (instancetype)nilToEmptyStringWithString:(NSString *)string {
    if (string) {
        return string;
    } else {
        return @"";
    }
}


-(NSDate *)dateYMDHMSFromString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss.SSS"];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:self];
    return destDate;
}

-(CGSize)stringSizeWithFont:(UIFont *)font width:(CGFloat)width height:(CGFloat)height mode:(NSLineBreakMode)mode
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = mode;
    return [self boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingUsesLineFragmentOrigin attributes: @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy} context:nil].size;
}

-(NSUInteger)lengthOfBytesUsingUTF8;
{
    NSUInteger asciiLength = 0;
    for (NSUInteger i = 0; i < [self length]; i++) {
        unichar uc = [self characterAtIndex: i];
        asciiLength += isascii(uc) ? 1 : 2;
    }
    return asciiLength;
}
@end
