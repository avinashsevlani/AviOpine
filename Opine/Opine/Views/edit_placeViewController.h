//
//  edit_placeViewController.h
//  Opine
//
//  Created by apple on 06/01/15.
//  Copyright (c) 2015 TheAppGururz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"
#import "AppDelegate.h"

@interface edit_placeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,UITextViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,NIDropDownDelegate>
{
    UIImagePickerController *controller;
    NIDropDown *dropDown;
    AppDelegate *objAppDelegate;
    
    IBOutlet UITableView *tbl_state_list;
    NSString *str_state;
    
    BOOL isstate_btn_click;
}
@property (nonatomic, retain) NSDictionary *dic_response;
@property (nonatomic) int str_place_id;
@end
