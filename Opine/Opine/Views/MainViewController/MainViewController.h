//
//  MainViewController.h
//  Opine
//
//  Created by MoonRose Infotech on 06/11/14.
//  Copyright (c) 2014 MoonRose Infotech All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"
#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import "My_Places_ViewController.h"

@interface MainViewController : UIViewController <CLLocationManagerDelegate>
{
    NSMutableArray *marrSettingItem;
    NIDropDown *dropDown;
    AppDelegate *objAppDelegate;
    CLLocationManager *locationManager;
    double lat, lon;
}

@property (weak, nonatomic) IBOutlet UICollectionView *cvControllerPlace;
@property (weak, nonatomic) IBOutlet UITextField *txtSearch;
@property (weak, nonatomic) IBOutlet UIButton *btnLeftArrowPlace;
@property (weak, nonatomic) IBOutlet UIButton *btnLeftArrowCategory;
@property (weak, nonatomic) IBOutlet UIButton *btnRightArrowCategory;
@property (weak, nonatomic) IBOutlet UIButton *btnRightArrowPlace;
@property (weak, nonatomic) IBOutlet UIButton *btnChooseCategory;
@property (weak, nonatomic) IBOutlet UICollectionView *cvCatagory;
@property (weak, nonatomic) IBOutlet UICollectionView *cvPlace;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIImageView *imgLogin;
@property (weak, nonatomic) IBOutlet UIView *vwAboutUs;

@end
