//
//  ImageTouchView.m
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-20.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "ImageTouchView.h"

@interface ImageTouchView () {
    BOOL onAction;
}

@end

@implementation ImageTouchView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame delegate:(id <ImageTouchViewDelegate>)del {
    if (self = [super initWithFrame:frame]) {
        [self inSetup];
        self.delegate = del;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self inSetup];
    }
    return self;
}
    
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self inSetup];
    }
    return self;
}

- (id)init {
    if (self = [super init]) {
        [self inSetup];
    }
    return self;
}

- (void)inSetup {
    self.clipsToBounds = YES;
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.userInteractionEnabled = YES;
}

- (void)dealloc {
    Release(delegate);
//    Release(tag);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (delegate) {
        onAction = YES;
        [UIView beginAnimations:@"DOWN" context:NULL];
        [UIView setAnimationDelegate:nil];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:nil cache:YES];
        self.alpha = 0.5;
        [UIView commitAnimations];
        if ([delegate respondsToSelector:@selector(imageTouchViewDidBegin:)]) {
            [delegate imageTouchViewDidBegin:self];
        }
    }

}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (onAction) {
        UITouch * touch = [[event allTouches] anyObject];
        CGPoint touchLocation = [touch locationInView:self];
        if (!CGRectContainsPoint(self.bounds, touchLocation)) {
            [self touchesCancelled:touches withEvent:event];
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if (onAction) {
        onAction = NO;
        [UIView beginAnimations:@"NOR" context:NULL];
        [UIView setAnimationDelegate:nil];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:nil cache:YES];
        self.alpha = 1.0;
        [UIView commitAnimations];
        if ([delegate respondsToSelector:@selector(imageTouchViewDidCancel:)]) {
            [delegate imageTouchViewDidCancel:self];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (onAction) {
        if ([delegate respondsToSelector:@selector(imageTouchViewDidSelected:)]) {
            [delegate imageTouchViewDidSelected:self];
        }
        [self touchesCancelled:touches withEvent:event];
    }
}

- (void)startRotateAnimation
{
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        animation.fromValue = @(0);
        animation.toValue = @(2*M_PI);
        animation.duration = 1.f;
        animation.repeatCount = INT_MAX;
        
        [self.layer addAnimation:animation forKey:@"keyFrameAnimation"];
        self.alpha = 1;
    }];
}

- (void)stopRotateAnimation
{
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self.layer removeAllAnimations];
        self.alpha = 1;
    }];
}
@end
