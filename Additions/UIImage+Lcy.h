//
//  UIImage+Lcy.h
//  新浪微博
//
//  Created by 神说有光 on 14-6-19.
//  Copyright (c) 2014年 Our Dream. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Lcy)

+(UIImage *)setFullScreenImaged:(NSString *)imageName;
+(UIImage *)resizeImaged:(NSString *)imageName;
-(UIImage*)scaledToSize:(CGSize)newSize;
+(UIImage*)imageWithColor:(UIColor*)color;
+(UIImage*)imageWithColor:(UIColor*)color size:(CGSize)size;
- (UIImage *)fixOrientation;
@end
