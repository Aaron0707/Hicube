//
//  ReserveViewCellTableViewCell.m
//  Hicube
//
//  Created by AaronYang on 5/23/15.
//  Copyright (c) 2015 Aaron. All rights reserved.
//

#import "ReserveViewCellTableViewCell.h"
#import "BSClient.h"


@implementation ReserveViewCellTableViewCell{
    BSClient * client;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


-(void)setReserve:(Reserve *)reserve{
    _reserve = reserve;
    
    self.nameLabel.text = self.reserve.wareName;
    self.typeLabel.text = [self reserveConvert:self.reserve.status];
    self.detailLabel.text = [NSString stringWithFormat:@"消费日期: %@   数量: %@",self.reserve.serviceYmd,self.reserve.num];
}

-(IBAction)cancelReserve:(UIButton *)sender{
    client = [[BSClient alloc]initWithDelegate:self action:@selector(requestDidFinish:obj:)];
    [client cancelReserve:self.reserve.ID];
}

-(void)requestDidFinish:(BSClient *)sender obj:(NSDictionary *)dic{
    if (sender.hasError) {
        [sender showAlert];
    }
    client = nil;
    
    [self reserveConvert:@""];
    self.typeLabel.text = @"已取消";
}

-(NSString *)reserveConvert:(NSString *)string{
    if ([string isEqualToString:@"WAIT"]) {
        self.cancelButton.hidden = NO;
        return @"预约中";
    }else if([string isEqualToString:@"COMPLETED"]){
        self.cancelButton.hidden = YES;
        return @"已完成";
    }else if([string isEqualToString:@"ACCEPTED"]){
        self.cancelButton.hidden = YES;
        return @"已接受";
    }else if([string isEqualToString:@"REJECTED"]){
        self.cancelButton.hidden = YES;
        return @"被拒绝";
    }else{
        self.cancelButton.hidden = YES;
        return @"已取消";
    }
}
@end
