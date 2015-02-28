//
//  My_Places_Cell.h
//  Opine
//
//  Created by apple on 20/01/15.
//  Copyright (c) 2015 TheAppGururz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface My_Places_Cell : UITableViewCell


// =-=-=-=-=-=-=-=-=    Allocating  =-=-=-=-=-=-=-=-=-=-=-=-=-=- //
@property (strong, nonatomic) IBOutlet UIImageView *img_user;
@property (strong, nonatomic) IBOutlet UILabel *lbl_place_tittle;
@property (strong, nonatomic) IBOutlet UILabel *lbl_place_address;
@property (strong, nonatomic) IBOutlet UILabel *lbl_place_rating;
@property (strong, nonatomic) IBOutlet UIButton *btn_place_edit;
@property (strong, nonatomic) IBOutlet UILabel *lbl_rating;


@end
