//
//  PlaceViewController.h
//  Opine
//
//  Created by MoonRose Infotech on 12/11/14.
//  Copyright (c) 2014 MoonRose Infotech All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MHPagingScrollView.h"
#import "NIDropDown.h"

@interface PlaceViewController : UIViewController <CLLocationManagerDelegate, MHPagingScrollViewDelegate>
{
    NSMutableArray *marrPageData, *marrSortingThing;
    NIDropDown *dropDown;
    AppDelegate *objAppDelegate;
    CLLocationManager *locationManager;
    NSMutableDictionary *dictPlaces;
}

@property (weak, nonatomic) IBOutlet UITextField *txtSearch;
@property BOOL isCategory;
@property (nonatomic) NSInteger categoryID;
@property (weak, nonatomic) IBOutlet UIButton *btnSortingPlace;
@property (weak, nonatomic) IBOutlet UILabel *lblPageNumber;
@property (weak, nonatomic) IBOutlet UIPageControl *pagingTable;
@property (strong, nonatomic) CLLocationManager *manager;
@property (weak, nonatomic) IBOutlet UITableView *tblPlace;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *vwMap;
@property (strong, nonatomic) NSString *searchWord;

@end
