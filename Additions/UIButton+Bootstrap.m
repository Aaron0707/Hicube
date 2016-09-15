//
//  UIButton+Bootstrap.m
//  UIButton+Bootstrap
//
//  Created by Oskur on 2013-09-29.
//  Copyright (c) 2013 Oskar Groth. All rights reserved.
//
#import "UIButton+Bootstrap.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+FlatUI.h"

@implementation UIButton (Bootstrap)

-(void)bootstrapStyle{
    self.layer.cornerRadius = 3.0;
    self.layer.masksToBounds = YES;
    [self setAdjustsImageWhenHighlighted:NO];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [self.titleLabel setFont:[UIFont fontWithName:@"FontAwesome" size:self.titleLabel.font.pointSize]];
}

-(void)defaultStyle{
    [self bootstrapStyle];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderColor = [[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1] CGColor];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1]] forState:UIControlStateHighlighted];
}

-(void)cancelStyle{
    [self bootstrapStyle];
    self.backgroundColor = RGBCOLOR(158, 146, 155);
    [self setBackgroundImage:[self buttonImageFromColor:RGBCOLOR(31, 103, 148)] forState:UIControlStateHighlighted];
}

-(void)primaryStyle{
    [self bootstrapStyle];
    self.backgroundColor = [UIColor colorWithRed:66/255.0 green:139/255.0 blue:202/255.0 alpha:1];
    self.layer.borderColor = [[UIColor colorWithRed:53/255.0 green:126/255.0 blue:189/255.0 alpha:1] CGColor];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:51/255.0 green:119/255.0 blue:172/255.0 alpha:1]] forState:UIControlStateHighlighted];
}

-(void)successStyle{
    [self bootstrapStyle];
    self.backgroundColor = [UIColor colorWithRed:92/255.0 green:184/255.0 blue:92/255.0 alpha:1];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:69/255.0 green:164/255.0 blue:84/255.0 alpha:1]] forState:UIControlStateHighlighted];
}

-(void)infoStyle{
    [self bootstrapStyle];
    self.backgroundColor = [UIColor colorWithRed:91/255.0 green:192/255.0 blue:222/255.0 alpha:1];
    self.layer.borderColor = [[UIColor colorWithRed:70/255.0 green:184/255.0 blue:218/255.0 alpha:1] CGColor];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:57/255.0 green:180/255.0 blue:211/255.0 alpha:1]] forState:UIControlStateHighlighted];
}

-(void)navStyle{
    [self bootstrapStyle];
    self.backgroundColor = RGBCOLOR(0, 200, 247);
    self.layer.borderColor = [RGBCOLOR(0, 196, 245) CGColor];
    [self setBackgroundImage:[self buttonImageFromColor:RGBCOLOR(0, 188, 288)] forState:UIControlStateHighlighted];
}

-(void)navBlackStyle{
    [self bootstrapStyle];
    self.backgroundColor = BkgSkinColor;self.layer.borderWidth = 0;
    [self setBackgroundImage:[self buttonImageFromColor:RGBCOLOR(0, 168, 208)] forState:UIControlStateHighlighted];
}

-(void)warningStyle{
    [self bootstrapStyle];
    self.backgroundColor = RGBCOLOR(255, 184, 35);
    self.layer.borderColor = self.backgroundColor.CGColor;
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:237/255.0 green:155/255.0 blue:67/255.0 alpha:1]] forState:UIControlStateHighlighted];
}

- (void)commonStyle {
        [self bootstrapStyle];
    self.layer.cornerRadius = 4;
    self.backgroundColor = RGBCOLOR(115, 194, 193);
    [self setBackgroundImage:[self buttonImageFromColor:BkgSkinColor] forState:UIControlStateHighlighted];
}

-(void)dangerStyle{
    [self bootstrapStyle];
    self.backgroundColor = RGBCOLOR(217, 83, 79);
    self.layer.borderColor = [RGBCOLOR(212, 63, 58) CGColor];
    [self setBackgroundImage:[self buttonImageFromColor:RGBCOLOR(210, 48, 51)] forState:UIControlStateHighlighted];
}

- (UIImage *) buttonImageFromColor:(UIColor *)color {
    return [UIImage imageWithColor:color cornerRadius:self.layer.cornerRadius];
}
@end
