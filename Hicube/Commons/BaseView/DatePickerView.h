//
//  DatePickerView.h
//  Hicube
//
//  Created by AaronYang on 5/13/15.
//  Copyright (c) 2015 Aaron. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DatePickerViewDelegate <NSObject>

-(void)datePickerViewSave:(NSDate *)date;

@end
@interface DatePickerView : UIView

@property (nonatomic, weak) id<DatePickerViewDelegate> delegate;
-(id)initWithDelegate:(id)delegate;
-(void)show;
@end
