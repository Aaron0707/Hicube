//
//  ColorHelper.h
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-20.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//


#ifndef Custom_ColorHelper_h
#define Custom_ColorHelper_h

#define kBlueColor RGBCOLOR(63, 175, 225)

#define MyPinkColor RGBCOLOR(241, 62, 102)
#define MygreenColor RGBCOLOR(182, 206, 32)
#define MygrayColor RGBCOLOR(175, 175, 175)
#define NavOrBarTinColor RGBCOLOR(115, 194, 193)

#define TextOrangeColor RGBCOLOR(252, 183, 106)

#define tabColor RGBCOLOR(247, 249, 249)
#define RbkgColor RGBACOLOR(164, 158, 163, 0.382)
#define bkgViewColor RGBCOLOR(234, 234, 234)
#define BkgSkinColor RGBCOLOR(0, 188, 228)
#define BkgFontColor RGBCOLOR(114, 114, 113)


#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 \
alpha:(a)]

//RGB颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue)    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#endif
