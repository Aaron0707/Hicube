//
//  ReserveViewCellTableViewCell.h
//  Hicube
//
//  Created by AaronYang on 5/23/15.
//  Copyright (c) 2015 Aaron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reserve.h"
#import "BaseTableViewCell.h"

@interface ReserveViewCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (nonatomic, strong) Reserve * reserve;
@end
