//
//  CreaterOfSystemCell.h
//  Hicube
//
//  Created by AaronYang on 5/27/15.
//  Copyright (c) 2015 Aaron. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SimpleUser.h"
@interface CreaterOfSystemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) SimpleUser * user;
@end
