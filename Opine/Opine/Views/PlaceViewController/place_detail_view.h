//
//  place_detail_view.h
//  Opine
//
//  Created by apple on 12/01/15.
//  Copyright (c) 2015 TheAppGururz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface place_detail_view : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
{
   NSDictionary *dic_details;
    IBOutlet UIScrollView *scroll_answer_View;
    IBOutlet UITextView *txtv_answer;
    
    // Set global count
    int index;
    int split_array;
    
    AppDelegate *object_appdelegate;
    NSString *str_comment_id;
}
@property (nonatomic, retain) NSDictionary *dic_details;
@property (nonatomic, retain) NSString *str_place_id;
@end
