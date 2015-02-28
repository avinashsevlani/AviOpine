//
//  My_Places_ViewController.h
//  Opine
//
//  Created by apple on 02/01/15.
//  Copyright (c) 2015 TheAppGururz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "NIDropDown.h"
#import "My_place_reportViewController.h"
#import "edit_placeViewController.h"
#import "place_detail_view.h"
#import "MBProgressHUD.h"

@interface My_Places_ViewController : UIViewController<NIDropDownDelegate>
{
    AppDelegate *objAppDelegate;
    
    BOOL is_places_selcted;
    
     NIDropDown *dropDown;
     NSMutableDictionary *dic_catch;
}
@end
