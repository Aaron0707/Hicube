//
//  ColorHelper.h
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-20.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//
//屏幕尺寸是否是长屏
#define iPhoneLong  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#ifndef Spartan_Education_Config_h
#define Spartan_Education_Config_h

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
#define kCGImageAlphaPremultipliedLast  (kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast)
#else
#define kCGImageAlphaPremultipliedLast  kCGImageAlphaPremultipliedLast
#endif
#define String(__key) NSLocalizedString(__key, nil)
#define areapath [NSString stringWithFormat:@"%@/Library/Cache/Images/areaCode.plist",NSHomeDirectory()]
#define KDeafultBtn [[UIImage imageNamed:@"btn_Login_d"] stretchableImageWithLeftCapWidth:11 topCapHeight:0]
#define KDeafultBtn_D [[UIImage imageNamed:@"btn_Login_n"] stretchableImageWithLeftCapWidth:11 topCapHeight:0]
#define errorLocation @"请在您设备的“设置-隐私-位置”选项中，允许“云联平台”访问您的位置。"
#define KWAlertBtnCan [[UIImage imageNamed:@"GreenColorBtn"] stretchableImageWithLeftCapWidth:5 topCapHeight:0]
#define KWAlertBtnOt [[UIImage imageNamed:@"WhiteColor"] stretchableImageWithLeftCapWidth:5 topCapHeight:0]
#define NtfLogin @"BSNotificationLogin"
#define ChangeMemberCard @"ChangeMemberCard"
#define ChangeMemberType @"ChangeMemberType"
#define NtfInfoUpdate @"BSNotificationInfoUpdate"

/*****  release   *****/

#define Release(__object) if(__object){__object=nil;}

#define KBSSDKAPIURL                 @"http://112.124.5.160:80/"
#define KBSSDKAPIDomain              @"http://112.124.5.160:80/api/"

#define Sys_Version [[UIDevice currentDevice].systemVersion doubleValue]
#define Sys_Name [[UIDevice currentDevice] systemName]

#define App_ver [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey];
#define kQueueDEFAULT dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define kQueueHIGH dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
#define kQueueLOW dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)
#define kQueueBACKGROUND dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)
#define kQueueMain dispatch_get_main_queue()

//#define LOADIMAGE(file) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:@"png"]]
#define LOADIMAGECACHES(file) [UIImage imageNamed:file]
/******************************************************/

/****  debug log **/ //NSLog输出信息

#ifdef DEBUG

#define DLog( s, ... ) NSLog( @"< %@:(%d) > %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )

#else

#define DLog( s, ... ) NSLog(@"")

#endif


/***  DEBUG RELEASE  */

#if DEBUG

#define MCRelease(x)

#else

#define MCRelease(x)

#endif


#pragma mark - Frame(宏 x,y,width,height)

#define MainScreenScale [[UIScreen mainScreen]scale] //屏幕的分辨率 当结果为1时，显示的是普通屏幕，结果为2时，显示的是Retian屏幕
// App Frame Height&Width
#define Application_Frame  [[UIScreen mainScreen] applicationFrame] //除去信号区的屏幕的frame
#define APP_Frame_Height   [[UIScreen mainScreen] applicationFrame].size.height //应用程序的屏幕高度
#define App_Frame_Width    [[UIScreen mainScreen] applicationFrame].size.width  //应用程序的屏幕宽度
/*** MainScreen Height Width */
#define Main_Screen_Height [[UIScreen mainScreen] bounds].size.height //主屏幕的高度
#define Main_Screen_Width  [[UIScreen mainScreen] bounds].size.width  //主屏幕的宽度

// View 坐标(x,y)和宽高(width,height)
#define X(v)               (v).frame.origin.x
#define Y(v)               (v).frame.origin.y
#define ViewWIDTH(v)           (v).frame.size.width
#define ViewHEIGHT(v)          (v).frame.size.height

#define MinX(v)            CGRectGetMinX((v).frame) // 获得控件屏幕的x坐标
#define MinY(v)            CGRectGetMinY((v).frame) // 获得控件屏幕的Y坐标

#define MidX(v)            CGRectGetMidX((v).frame) //横坐标加上到控件中点坐标
#define MidY(v)            CGRectGetMidY((v).frame) //纵坐标加上到控件中点坐标

#define MaxX(v)            CGRectGetMaxX((v).frame) //横坐标加上控件的宽度
#define MaxY(v)            CGRectGetMaxY((v).frame) //纵坐标加上控件的高度

#define CONTRLOS_FRAME(x,y,width,height)     CGRectMake(x,y,width,height)

//    系统控件的默认高度
#define kStatusBarHeight   (20.f)
#define kTopBarHeight      (44.f)
#define kBottomBarHeight   (49.f)

#define kCellDefaultHeight (44.f)

// 当控件为全屏时的横纵左边
#define kFrameX             (0.0)
#define kFrameY             (0.0)

#define kPhoneFrameWidth                 (320.0)
#define kPhoneWithStatusNoPhone5Height   (480.0)
#define kPhoneNoWithStatusNoPhone5Height (460.0)
#define kPhoneWithStatusPhone5Height     (568.0)
#define kPhoneNoWithStatusPhone5Height   (548.0)

#define kPadFrameWidth                   (768.0)
#define kPadWithStatusHeight             (1024.0)
#define kPadNoWithStatusHeight           (1004.0)

//中英状态下键盘的高度
#define kEnglishKeyboardHeight  (216.f)
#define kChineseKeyboardHeight  (252.f)

#pragma mark - Funtion Method (宏 方法)
//PNG JPG 图片路径
#define PNGPATH(NAME)          [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:NAME] ofType:@"png"]
#define JPGPATH(NAME)          [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:NAME] ofType:@"jpg"]
#define PATH(NAME,EXT)         [[NSBundle mainBundle] pathForResource:(NAME) ofType:(EXT)]

//加载图片
#define PNGIMAGE(NAME)         [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:@"png"]]
#define JPGIMAGE(NAME)         [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:@"jpg"]]
#define IMAGE(NAME,EXT)        [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:(EXT)]]
#define IMAGENAMED(NAME)       [UIImage imageNamed:NAME]

//字体大小（常规/粗体）
#define BOLDSYSTEMFONT(FONTSIZE) [UIFont boldSystemFontOfSize:FONTSIZE]
#define SYSTEMFONT(FONTSIZE)     [UIFont systemFontOfSize:FONTSIZE]
#define FONT(NAME,FONTSIZE)      [UIFont fontWithName:(NAME) size:(FONTSIZE)]

//当前版本
#define FSystenVersion            ([[[UIDevice currentDevice] systemVersion] floatValue])
#define DSystenVersion            ([[[UIDevice currentDevice] systemVersion] doubleValue])
#define SSystemVersion            ([[UIDevice currentDevice] systemVersion])

//当前语言
#define CURRENTLANGUAGE           ([[NSLocale preferredLanguages] objectAtIndex:0])

//是否Retina屏
#define isRetina                  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) :NO)
//是否iPhone5
#define ISIPHONE                  [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone
#define ISIPHONE5                 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

// UIView - viewWithTag 通过tag值获得子视图
#define VIEWWITHTAG(_OBJECT,_TAG)   (id)[_OBJECT viewWithTag : _TAG]

//应用程序的名字
#define AppDisplayName              [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]

//判断设备室真机还是模拟器
#if TARGET_OS_IPHONE
/** iPhone Device */
#endif

#if TARGET_IPHONE_SIMULATOR
/** iPhone Simulator */
#endif





#define NOTIFICATION_LOGINSUCCESS @"LOGINSUCCESS"
#define NOTIFICATION_RESITPASSWORD @"RESITPASSWORD"
#define NOTIFICATION_SIGNOUT @"NOTIFICATION_SIGNOUT"


#define NobelFont_22            [UIFont fontWithName:FontRegular size:22]
#define NobelFont_20            [UIFont fontWithName:FontRegular size:20]
#define NobelFont_18            [UIFont fontWithName:FontRegular size:18]
#define NobelFont_15            [UIFont fontWithName:FontRegular size:15]
#define NobelFont_14            [UIFont fontWithName:FontRegular size:14]
#define NobelFont_13            [UIFont fontWithName:FontRegular size:13]
#define NobelFont_12            [UIFont fontWithName:FontRegular size:12]
#define NobelFont_10            [UIFont fontWithName:FontRegular size:10]

#define Helvetica_22_Bold       [UIFont fontWithName:FONTBOLD size:22]
#define Helvetica_22            [UIFont fontWithName:FONTNORMAL size:22]

#define Helvetica_18_Bold       [UIFont fontWithName:FONTBOLD size:18]
#define Helvetica_18            [UIFont fontWithName:FONTNORMAL size:18]

#define Helvetica_14_Bold       [UIFont fontWithName:FONTBOLD size:14]
#define Helvetica_14            [UIFont fontWithName:FONTNORMAL size:14]

#define Helvetica_10            [UIFont fontWithName:FONTNORMAL size:10]

#define Chinese_Font_22_Bold    [UIFont boldSystemFontOfSize:22]
#define Chinese_Font_22         [UIFont systemFontOfSize:22]

#define Chinese_Font_18_Bold    [UIFont boldSystemFontOfSize:18]
#define Chinese_Font_18         [UIFont systemFontOfSize:18]

#define Chinese_Font_16_Bold    [UIFont boldSystemFontOfSize:16]
#define Chinese_Font_16         [UIFont systemFontOfSize:16]

#define Chinese_Font_15         [UIFont systemFontOfSize:15]
#define Chinese_Font_15_Bold    [UIFont boldSystemFontOfSize:15]

#define Chinese_Font_14_Bold    [UIFont boldSystemFontOfSize:14]
#define Chinese_Font_14         [UIFont systemFontOfSize:14]

#define Chinese_Font_13         [UIFont systemFontOfSize:13]

#define Chinese_Font_12_Bold    [UIFont boldSystemFontOfSize:12]
#define Chinese_Font_12         [UIFont systemFontOfSize:12]

#define Chinese_Font_11_Bold    [UIFont boldSystemFontOfSize:11]
#define Chinese_Font_11         [UIFont systemFontOfSize:11]

#define Chinese_Font_10_Bold    [UIFont boldSystemFontOfSize:10]
#define Chinese_Font_10         [UIFont systemFontOfSize:10]

#define Chinese_Font_9_Bold    [UIFont boldSystemFontOfSize:9]
#define Chinese_Font_9         [UIFont systemFontOfSize:9]

#define Chinese_Font_8         [UIFont systemFontOfSize:8]



#endif