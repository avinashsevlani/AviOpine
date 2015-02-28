//
//  My_place_reportViewController.h
//  Opine
//
//  Created by apple on 03/01/15.
//  Copyright (c) 2015 TheAppGururz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"
#import "LineChartView.h"
#import "PlaceDetailModel.h"
#import "Utility_Class.h"

@interface My_place_reportViewController : UIViewController <NIDropDownDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NIDropDown *dropDown;
    IBOutlet UILabel *lbl_comment_count;
    IBOutlet UILabel *lbl_rate_count;
    
    IBOutlet UITableView *tbl_comment;
    
    PlaceDetailModel *objPlaceDetail;
    
    
    // Allocating For report
    BOOL isfrom_comment;
    NSString *str_shorting_type;
}
@property (nonatomic)  int str_placeid;
@end
