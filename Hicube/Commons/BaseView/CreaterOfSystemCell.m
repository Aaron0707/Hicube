//
//  CreaterOfSystemCell.m
//  Hicube
//
//  Created by AaronYang on 5/27/15.
//  Copyright (c) 2015 Aaron. All rights reserved.
//

#import "CreaterOfSystemCell.h"
#import "UIImageView+WebCache.h"
#import "Globals.h"

@implementation CreaterOfSystemCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    self.headerImage.layer.masksToBounds= YES;
    self.headerImage.layer.cornerRadius = self.headerImage.width/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setUser:(SimpleUser *)user{
    _user = user;
    
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"defaultHeadImage"]];
    self.nameLabel.text = user.username;

    self.timeLabel.text = [NSString stringWithFormat:@"%@加入",[Globals sendTimeString:user.createTime.doubleValue]];
    
    self.numberLabel.hidden = YES;
}
@end
