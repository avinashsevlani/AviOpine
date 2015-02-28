//
//  MainViewController.m
//  Opine
//
//  Created by MoonRose Infotech on 06/11/14.
//  Copyright (c) 2014 MoonRose Infotech All rights reserved.
//

#import "MainViewController.h"
#import "CatagoryCollectionViewCell.h"
#import "PlaceCollectionViewCell.h"
#import "QuartzCore/QuartzCore.h"
#import "DetailViewController.h"
#import "SignupViewController.h"
#import "PlaceViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ECSlidingViewController.h"
#import "SettingViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "ProfileViewController.h"
#import "CategoryModel.h"
#import "MBProgressHUD.h"
#import "PlaceModel.h"
#import <FacebookSDK/FacebookSDK.h>
#import "DYRateView.h"
#import "UIImageView+WebCache.h"
#import "Reachability.h"
#import "ClaimMyPlaceViewController.h"

@interface MainViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate, SignupViewControllerDelegate, DetailViewControllerDelegate, SettingTableViewControllerDelegate, UIAlertViewDelegate,ClaimMyPlaceViewControllerDelegate>

@end

@implementation MainViewController

@synthesize cvCatagory, cvPlace;
@synthesize btnLogin, btnChooseCategory, btnLeftArrowCategory, btnLeftArrowPlace, btnRightArrowCategory, btnRightArrowPlace;
@synthesize imgLogin;
@synthesize vwAboutUs;
@synthesize txtSearch;
@synthesize cvControllerPlace;

int countCatagory = 0, countPlace = 0, categoryID = 0, catID = -1;
bool isPlaceByCategoryDone = NO;

#pragma mark - ViewLifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (![self isInternetAvailable]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Internet Unavailable" message:@"Please check your Internet Connection." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    [self loadData];
    [self getCatagory];
}

- (void)viewDidLayoutSubviews
{
    if (cvCatagory.contentSize.width < 246) {
        [btnRightArrowCategory setImage:[UIImage imageNamed:@"imgRightArrowDisable.png"] forState:UIControlStateNormal];
        [btnLeftArrowCategory setImage:[UIImage imageNamed:@"imgLeftArrowDisable.png"] forState:UIControlStateNormal];
        [btnRightArrowCategory setUserInteractionEnabled:NO];
        [btnLeftArrowCategory setUserInteractionEnabled:NO];
    } else {
        [btnRightArrowCategory setImage:[UIImage imageNamed:@"imgRightArrowEnable.png"] forState:UIControlStateNormal];
        [btnLeftArrowCategory setImage:[UIImage imageNamed:@"imgLeftArrowEnable.png"] forState:UIControlStateNormal];
        [btnRightArrowCategory setUserInteractionEnabled:YES];
        [btnLeftArrowCategory setUserInteractionEnabled:YES];
    }
    if (cvPlace.contentSize.width < 246) {
        [btnRightArrowPlace setImage:[UIImage imageNamed:@"imgRightArrowDisable.png"] forState:UIControlStateNormal];
        [btnLeftArrowPlace setImage:[UIImage imageNamed:@"imgLeftArrowDisable.png"] forState:UIControlStateNormal];
        [btnRightArrowPlace setUserInteractionEnabled:NO];
        [btnLeftArrowPlace setUserInteractionEnabled:NO];
    } else {
        [btnRightArrowPlace setImage:[UIImage imageNamed:@"imgRightArrowEnable.png"] forState:UIControlStateNormal];
        [btnLeftArrowPlace setImage:[UIImage imageNamed:@"imgLeftArrowEnable.png"] forState:UIControlStateNormal];
        [btnRightArrowPlace setUserInteractionEnabled:YES];
        [btnLeftArrowPlace setUserInteractionEnabled:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self createLocationObject];
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [[UIColor blackColor] CGColor];
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[SettingViewController class]]) {
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
        [(SettingViewController *)self.slidingViewController.underLeftViewController setMarrSetting:marrSettingItem];
        [(SettingViewController *)self.slidingViewController.underLeftViewController setDelegate:self];
    }
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIApplication *app = [UIApplication sharedApplication];
    [app performSelector:@selector(suspend)];
     [NSThread sleepForTimeInterval:2.0];
    exit(0);
}

-(BOOL) isInternetAvailable
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - UITextFieldDelegate Method
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - SignUpViewControllerDelegate Method
- (void)setUserName:(NSString *)username
{
    [btnLogin setTitle:@"Logout" forState:UIControlStateNormal];
    imgLogin.hidden = YES;
    btnLogin.tag = 1;
    marrSettingItem = nil;
    if (objAppDelegate.ispaid_user)
    {
        marrSettingItem = [[NSMutableArray alloc] initWithObjects:@"My Profile",@"My Places",@"About US", nil];
    }
    else
    {
        marrSettingItem = [[NSMutableArray alloc] initWithObjects:@"About US", nil];
    }
    [(SettingViewController *)self.slidingViewController.underLeftViewController setMarrSetting:marrSettingItem];
}

#pragma mark - DetailViewControllerDelegate Method
- (void)setLoginEnable
{
    if (objAppDelegate.isLogin) {
        [btnLogin setTitle:@"Logout" forState:UIControlStateNormal];
        imgLogin.hidden = YES;
        btnLogin.tag = 1;
    }
}

#pragma mark - UICollectionView Method
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView.tag == 0) {
        return [objAppDelegate.marrCategory count]-1;
    } else {
        return [objAppDelegate.marrPlace count];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 0) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        CatagoryCollectionViewCell *cellCatagory = [collectionView dequeueReusableCellWithReuseIdentifier:@"CatagoryCell" forIndexPath:indexPath];
        cellCatagory.layer.shouldRasterize = YES;
        cellCatagory.layer.rasterizationScale = [UIScreen mainScreen].scale;
        cellCatagory.lblCategoryName.text = [[objAppDelegate.marrCategory objectAtIndex:(indexPath.row)+1] valueForKey:@"_categoryTitle"];
        cellCatagory.tag = [[[objAppDelegate.marrCategory objectAtIndex:(indexPath.row)+1] valueForKey:@"_categoryID"] integerValue];
        if (![[[objAppDelegate.marrCategory objectAtIndex:(indexPath.row)+1] valueForKey:@"_categoryImage"]  isEqual: @""]) {
            NSString *string = [[objAppDelegate.marrCategory objectAtIndex:(indexPath.row)+1] valueForKey:@"_categoryImage"];
            NSURL *url = [NSURL URLWithString:[string stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
            [cellCatagory.imgCatagoryPhoto setImageWithURL:url placeholderImage:[UIImage imageNamed:@"imagenotfound.png"]];
        }
        return cellCatagory;
    } else {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        PlaceCollectionViewCell *cellPlace = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlaceCell" forIndexPath:indexPath];
        cellPlace.layer.shouldRasterize = YES;
        cellPlace.layer.rasterizationScale = [UIScreen mainScreen].scale;
        if (![[[objAppDelegate.marrPlace objectAtIndex:indexPath.row] valueForKey:@"_placeImage"]  isEqual: @""]) {
            [cellPlace.imgPlacePhoto setImageWithURL:[NSURL URLWithString:[[objAppDelegate.marrPlace objectAtIndex:indexPath.row] valueForKey:@"_placeImage"]] placeholderImage:[UIImage imageNamed:@"imagenotfound.png"]];
        }
        cellPlace.tag = [[[objAppDelegate.marrPlace objectAtIndex:indexPath.row] valueForKey:@"_placeID"] integerValue];
        [self loadEditableRateControl:cellPlace.vwRating tagForControl:indexPath.row rate:[[[objAppDelegate.marrPlace objectAtIndex:indexPath.row] valueForKey:@"_placeRating"] doubleValue]];
        cellPlace.lblPlaceName.text = [[objAppDelegate.marrPlace objectAtIndex:indexPath.row] valueForKey:@"_placeName"];
        cellPlace.lblPlaceCity.text = [[objAppDelegate.marrPlace objectAtIndex:indexPath.row] valueForKey:@"_placeCity"];
        return cellPlace;
    }
}

- (void)loadEditableRateControl: (RateView *) rateView tagForControl:(int)tag rate:(float)rate
{
    rateView.notSelectedImage = [UIImage imageNamed:@"kermit_empty.png"];
    rateView.halfSelectedImage = [UIImage imageNamed:@"kermit_half.png"];
    rateView.fullSelectedImage = [UIImage imageNamed:@"kermit_full.png"];
    rateView.rating = rate;
    rateView.editable = NO;
    rateView.maxRating = 10;
    rateView.delegate = nil;
    rateView.midMargin = 2;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 0) {
        CatagoryCollectionViewCell *cellCatagory = (CatagoryCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PlaceViewController *objPlaceViewController = [storyBoard instantiateViewControllerWithIdentifier:@"PlaceViewController"];
        objPlaceViewController.categoryID = cellCatagory.tag;
        objPlaceViewController.isCategory = YES;
        [self presentViewController:objPlaceViewController animated:YES completion:nil];
    } else {
        PlaceCollectionViewCell *cellPlace = (PlaceCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        
        // Avi to make the place detail from the category and nearby same
        /*
        DetailViewController *objDetailViewController = [storyBoard instantiateViewControllerWithIdentifier:@"DetailViewController"];
        objDetailViewController.delegate = self;
        objDetailViewController.placeID = cellPlace.tag;
        [self presentViewController:objDetailViewController animated:YES completion:nil];*/
        
        ClaimMyPlaceViewController *vc =[[ClaimMyPlaceViewController alloc] initWithNibName:@"ClaimMyPlaceViewController" bundle:nil];
        vc.delegate = self;
        vc.placeID = cellPlace.tag;
        [self presentViewController:vc animated:YES completion:^{
            
        }];

        
    }
}

#pragma mark - IBAction Method
- (IBAction)btnCatagoryLeftTapped:(id)sender
{
    if (countCatagory > 0) {
        countCatagory--;
        [self snapToLeftCellAtIndex:countCatagory withAnimation:YES collectionView:cvCatagory];
    }
}

- (IBAction)btnCatagoryRightTapped:(id)sender
{
    if (countCatagory < ([objAppDelegate.marrCategory count] - 1)) {
        countCatagory++;
        [self snapToRightCellAtIndex:countCatagory withAnimation:YES collectionView:cvCatagory];
    }
}

- (IBAction)btnPlaceLeftTapped:(id)sender
{
    if (countPlace > 0) {
        countPlace--;
        [self snapToLeftCellAtIndex:countPlace withAnimation:YES collectionView:cvPlace];
    }
}

- (IBAction)btnPlaceRightTapped:(id)sender
{
    if (countPlace < ([objAppDelegate.marrPlace count] - 1)) {
        countPlace++;
        [self snapToRightCellAtIndex:countPlace withAnimation:YES collectionView:cvPlace];
    }
}

- (IBAction)btnSelectCatagoryTapped:(id)sender
{
    objAppDelegate.isSorting = NO;
    if(dropDown == nil) {
        CGFloat f = 160;
        dropDown = [[NIDropDown alloc] showDropDown:sender :&f :objAppDelegate.marrCategory :nil :@"down"];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
    }
}

- (IBAction)btnSearchTapped:(id)sender
{
    [txtSearch resignFirstResponder];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PlaceViewController *objPlaceViewController = [storyBoard instantiateViewControllerWithIdentifier:@"PlaceViewController"];
    objPlaceViewController.isCategory = NO;
    objPlaceViewController.searchWord = [txtSearch text];
    [self presentViewController:objPlaceViewController animated:YES completion:nil];
}

- (IBAction)btnSettingTapped:(id)sender
{
    marrSettingItem = nil;
    if (objAppDelegate.ispaid_user) {
        marrSettingItem = [[NSMutableArray alloc] initWithObjects:@"My Profile",@"My Places",@"About US", nil];
    } else {
        marrSettingItem = [[NSMutableArray alloc] initWithObjects:@"About US", nil];
    }
    [(SettingViewController *)self.slidingViewController.underLeftViewController setMarrSetting:marrSettingItem];
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (IBAction)btnBackAboutUsTapped:(id)sender
{
    vwAboutUs.hidden = YES;
}

#pragma mark - Other Method
- (void)loadData
{
    objAppDelegate = [[UIApplication sharedApplication] delegate];
    objAppDelegate.marrCategory = [[NSMutableArray alloc] init];
    objAppDelegate.marrPlace = [[NSMutableArray alloc] init];
    if (objAppDelegate.ispaid_user) {
        marrSettingItem = [[NSMutableArray alloc] initWithObjects:@"My Profile",@"My Places", @"About US", nil];
    } else {
        marrSettingItem = [[NSMutableArray alloc] initWithObjects:@"About US", nil];
    }
}

- (void) snapToLeftCellAtIndex:(NSInteger)index withAnimation:(BOOL) animated collectionView:(UICollectionView *)collectionView
{
    NSIndexPath *IndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [collectionView scrollToItemAtIndexPath:IndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:animated];
}

- (void) snapToRightCellAtIndex:(NSInteger)index withAnimation:(BOOL) animated collectionView:(UICollectionView *)collectionView
{
    if (countCatagory >= objAppDelegate.marrCategory.count-1) {
        countCatagory = ([objAppDelegate.marrCategory count] - 1);
        return;
    }
    if (countPlace >= objAppDelegate.marrPlace.count-1) {
        countPlace = ([objAppDelegate.marrPlace count] - 1);
        return;
    }
    NSIndexPath *IndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [collectionView scrollToItemAtIndexPath:IndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:animated];
}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender isNoneSelect:(BOOL)isNone
{
    [self rel];
    if (isNone) {
        [btnChooseCategory setTitle:@"Choose Category" forState:UIControlStateNormal];
    }
    categoryID = sender.tag;
}

-(void)rel{
    dropDown = nil;
}

#pragma mark - Segue Method
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqual:@"SignUpbyMain"]) {
        SignupViewController *objSignupViewController = [segue destinationViewController];
        objSignupViewController.delegate = self;
    }
}

-(BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"SignUpbyMain"])
    {
        if (btnLogin.tag == 1)
        {
            btnLogin.tag = 0;
            [btnLogin setTitle:@"Login" forState:UIControlStateNormal];
            objAppDelegate.isLogin = NO;
            imgLogin.hidden = NO;
            marrSettingItem = nil;
            if (objAppDelegate.ispaid_user) {
                marrSettingItem = [[NSMutableArray alloc] initWithObjects:@"My Profile", @"My Places", @"About US", nil];
            } else {
                marrSettingItem = [[NSMutableArray alloc] initWithObjects:@"About US", nil];
            }
            [(SettingViewController *)self.slidingViewController.underLeftViewController setMarrSetting:marrSettingItem];
            [[FBSession activeSession] closeAndClearTokenInformation];
            return NO;
        }
    }
    return YES;
}

#pragma mark - MenuViewController Delegate
- (void)openViewBySetting:(NSInteger)settingID
{
    [self.slidingViewController resetTopView];
    if ([[marrSettingItem objectAtIndex:settingID] isEqualToString:@"About US"]) {
        vwAboutUs.hidden = NO;
    } else if ([[marrSettingItem objectAtIndex:settingID] isEqualToString:@"My Places"])
    {
        My_Places_ViewController *controller = [[My_Places_ViewController alloc] initWithNibName:@"My_Places_ViewController" bundle:nil];
        [self presentViewController:controller animated:YES completion:nil];
        
        
    } else if ([[marrSettingItem objectAtIndex:settingID] isEqualToString:@"My Profile"]) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ProfileViewController *objProfileViewController = [storyBoard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
        [self presentViewController:objProfileViewController animated:YES completion:nil];
    }
}

#pragma mark - Current Location
-(void)createLocationObject
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [locationManager requestWhenInUseAuthorization];
    }
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_6_0)
{
    CLLocation *newLocation = [locations objectAtIndex:0];
    lat = newLocation.coordinate.latitude;
    lon = newLocation.coordinate.longitude;
    [locationManager stopUpdatingLocation];
    [self getNearMe];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    [locationManager stopUpdatingLocation];
}

#pragma mark - API Call
-(void) getCatagory
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:@"http://www.opine.com.br/OpineAPI/api/category/list"]
       parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"getCatagory responseObject = %@", [NSString stringWithUTF8String:[responseObject bytes]]);
             NSDictionary *dictTemp = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
             NSArray *arrCategory = [dictTemp valueForKey:@"Category"];
             CategoryModel *obj = [[CategoryModel alloc] init];
             obj.categoryID = @"0";
             obj.categoryTitle = @"All";
             obj.categoryImage = @"";
             obj.categoryCID = @"";
             [objAppDelegate.marrCategory addObject:obj];
              for (int i=0; i<[arrCategory count]; i++) {
                  CategoryModel *objCategory = [[CategoryModel alloc] init];
                  objCategory.categoryID = [[arrCategory objectAtIndex:i] valueForKey:@"Cat_Id"];
                  objCategory.categoryTitle = [[arrCategory objectAtIndex:i] valueForKey:@"Cat_Title"];
                  objCategory.categoryImage = [[arrCategory objectAtIndex:i] valueForKey:@"Cat_Image"];
                  objCategory.categoryCID = [[arrCategory objectAtIndex:i] valueForKey:@"Cat_Cid"];
                  [objAppDelegate.marrCategory addObject:objCategory];
              }
             [cvCatagory reloadData];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if (error) {
                  NSLog(@"getCatagory error = %@", error);
              }
              [MBProgressHUD hideHUDForView:self.view animated:YES];
          }];
}

-(void) getNearMe
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%0.8f", lat], @"Lat", [NSString stringWithFormat:@"%0.8f", lon], @"Lon", nil];  //-23.5333333 longitude:-46.6166667 --> Brazil
    [manager POST:[NSString stringWithFormat:@"http://www.opine.com.br/OpineAPI/api/place/nearby"]
      parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [MBProgressHUD showHUDAddedTo:self.view animated:YES];
             NSLog(@"getNearMe responseObject = %@", [NSString stringWithUTF8String:[responseObject bytes]]);
             NSDictionary *dictTemp = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
             NSArray *arrPlace = [dictTemp valueForKey:@"Place"];
             objAppDelegate.marrPlace = [[NSMutableArray alloc] init];
             for (int i=0; i<[arrPlace count]; i++) {
                 PlaceModel *objPlace = [[PlaceModel alloc] init];
                 objPlace.placeID = [[arrPlace objectAtIndex:i] valueForKey:@"Pla_Id"];
                 objPlace.placeName = [[arrPlace objectAtIndex:i] valueForKey:@"Pla_Name"];
                 objPlace.placePhone = [[arrPlace objectAtIndex:i] valueForKey:@"Pla_Phone"];
                 objPlace.placeImage = [[arrPlace objectAtIndex:i] valueForKey:@"Pla_Image"];
                 objPlace.placeAddress = [[arrPlace objectAtIndex:i] valueForKey:@"Pla_Address"];
                 objPlace.placeZip = [[arrPlace objectAtIndex:i] valueForKey:@"Pla_Zip"];
                 objPlace.placeCity = [[arrPlace objectAtIndex:i] valueForKey:@"Pla_City"];
                 objPlace.placeState = [[arrPlace objectAtIndex:i] valueForKey:@"Pla_State"];
                 objPlace.placeQue1 = [[arrPlace objectAtIndex:i] valueForKey:@"Pla_Que1"];
                 objPlace.placeQue2 = [[arrPlace objectAtIndex:i] valueForKey:@"Pla_Que2"];
                 objPlace.placeLogo = [[arrPlace objectAtIndex:i] valueForKey:@"Pla_Logo"];
                 objPlace.placeMessage = [[arrPlace objectAtIndex:i] valueForKey:@"Pla_Message"];
                 objPlace.placeRating = [[[arrPlace objectAtIndex:i] valueForKey:@"Rating"] intValue];
                 [objAppDelegate.marrPlace addObject:objPlace];
             }
             [cvPlace reloadData];
             if (arrPlace.count == 0) {
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (error) {
                 NSLog(@"getNearMe error = %@", error);
             }
             [MBProgressHUD hideHUDForView:self.view animated:YES];
         }];
}

@end
