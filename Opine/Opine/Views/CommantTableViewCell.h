//
//  CommantTableViewCell.h
//  Opine
//
//  Created by EverestIndia on 21/01/15.
//  Copyright (c) 2015 TheAppGururz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYRateView.h"

@interface CommantTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lbl_username;
@property (strong, nonatomic) IBOutlet UILabel *lbl_date;
@property (strong, nonatomic) IBOutlet UIImageView *img_userphoto;
@property (strong, nonatomic) IBOutlet UILabel *lbl_commandTitle;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Command;
@property (strong, nonatomic) IBOutlet UIButton *btn_reply;
@property (strong, nonatomic) IBOutlet UIButton *btn_readmore;
@property (strong, nonatomic) IBOutlet DYRateView *view_rate;

@end
