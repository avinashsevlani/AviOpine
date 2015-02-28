//
//  place_detail_Cell.h
//  Opine
//
//  Created by apple on 13/01/15.
//  Copyright (c) 2015 TheAppGururz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface place_detail_Cell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *btn_reply;
@property (strong, nonatomic) IBOutlet UILabel *lbl_username;
@property (strong, nonatomic) IBOutlet UILabel *lbl_tittle;
@property (strong, nonatomic) IBOutlet UILabel *lbl_comment;
@property (strong, nonatomic) IBOutlet UIButton *btn_read_more;
@property (strong, nonatomic) IBOutlet UIImageView *img_place;

@end
