//
//  RatingListTableViewCell.h
//  Opine
//
//  Created by EverestIndia on 20/01/15.
//  Copyright (c) 2015 TheAppGururz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYRateView.h"

@interface RatingListTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lbl_commandtitle;
@property (strong, nonatomic) IBOutlet DYRateView *view_rating;
@property (strong, nonatomic) IBOutlet UILabel *lbl_percentage;

@end
