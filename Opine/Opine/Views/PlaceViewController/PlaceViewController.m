//
//  PlaceViewController.m
//  Opine
//
//  Created by MoonRose Infotech on 12/11/14.
//  Copyright (c) 2014 MoonRose Infotech All rights reserved.
//

#import "PlaceViewController.h"
#import "PlaceTableViewCell.h"
#import "DetailViewController.h"
#import "Pin.h"
#import "PageView.h"
#import "DYRateView.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"
#import "PlaceModel.h"
#import "KeystoneMapAnnotation.h"
#import "OpineModel.h"
#import "Claim_form_ViewController.h"
#import "ClaimMyPlaceViewController.h"
#import "UIImageView+WebCache.h"

@interface PlaceViewController () <UITableViewDataSource, UITableViewDelegate, DYRateViewDelegate, UITextFieldDelegate, MKMapViewDelegate>
{
    NSUInteger _numPages;
    NSUInteger _pageCount;
}

@end

@implementation PlaceViewController


@synthesize tblPlace;
@synthesize mapView;
@synthesize vwMap;
@synthesize pagingTable;
@synthesize lblPageNumber;
@synthesize btnSortingPlace;
@synthesize txtSearch;

CLLocation *currentLocation;
bool isViewDidLoad = NO;

#pragma mark - ViewLifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    isViewDidLoad = YES;
    [tblPlace setSeparatorColor:[UIColor clearColor]];
}


-(void)viewWillAppear:(BOOL)animated
{
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0.1];
}

#pragma mark - UITextFieldDelegate  Method
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - MapView Method
-(void)addLocaationPin
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mapView.showsUserLocation = NO;
    [mapView removeAnnotations:mapView.annotations];
    for (int i = 0; i < [objAppDelegate.marrPlace count]; i++) {
        PlaceModel *objPlace = [objAppDelegate.marrPlace objectAtIndex:i];
        CLLocationCoordinate2D l;
        l.latitude = [objPlace.placeLatitude doubleValue];
        l.longitude = [objPlace.placeLongitude doubleValue];
        KeystoneMapAnnotation *annotation = [[KeystoneMapAnnotation alloc] initWithCoordinate:l];
        annotation.yTag = [objPlace.placeID integerValue];
        [annotation setTitle:objPlace.placeName];
        [annotation setSubtitle:[NSString stringWithFormat:@"(Contact : %@, %@)(Rate : %d)", objPlace.placePhone, objPlace.placeCity, objPlace.placeRating]];
        [self.mapView addAnnotation:annotation];
//        [OpineModel zoomToFitMapAnnotations:self.mapView];
        annotation = nil;
    }
}

-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
{
    mapView.showsUserLocation = YES;
    MKAnnotationView *annotationView = nil;
    if(annotation != mapView.userLocation) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@""];
        annotationView.image = [UIImage imageNamed:@"LocationPin.png"];
        KeystoneMapAnnotation *kannotation = (KeystoneMapAnnotation *)annotation;
        annotationView.tag = kannotation.yTag;
        annotationView.canShowCallout = YES;
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailViewController *objDetailViewController = [storyBoard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    objDetailViewController.placeID = view.tag;
    [self presentViewController:objDetailViewController animated:YES completion:nil];
}

- (void)mapView:(MKMapView *)mapViewTemp didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (isViewDidLoad) {
        MKCoordinateRegion region;
        MKCoordinateSpan span;
        double scalingFactor = ABS( (cos(2 * M_PI * userLocation.coordinate.latitude / 360.0) ));
        float miles = [[[NSUserDefaults standardUserDefaults] valueForKey:@"MapSize"] floatValue];
        span.latitudeDelta = miles/69.0;
        span.longitudeDelta = miles/(scalingFactor * 69.0);
        CLLocationCoordinate2D location;
        location.latitude = userLocation.coordinate.latitude;
        location.longitude = userLocation.coordinate.longitude;
        region.span = span;
        region.center = location;
        [mapViewTemp setRegion:region animated:YES];
        isViewDidLoad = NO;
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[dictPlaces objectForKey:[NSString stringWithFormat:@"%d", tableView.tag]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlaceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.tag = [[[[dictPlaces objectForKey:[NSString stringWithFormat:@"%d", tableView.tag]] objectAtIndex:indexPath.row] valueForKey:@"_placeID"] integerValue];
    cell.lblPlaceTitleCell.text = [[[dictPlaces objectForKey:[NSString stringWithFormat:@"%d", tableView.tag]] objectAtIndex:indexPath.row] valueForKey:@"_placeName"];
    NSString *strAddress = [NSString stringWithFormat:@"%@, %@, %@, %@", [[[dictPlaces objectForKey:[NSString stringWithFormat:@"%d", tableView.tag]] objectAtIndex:indexPath.row] valueForKey:@"_placeAddress"], [[[dictPlaces objectForKey:[NSString stringWithFormat:@"%d", tableView.tag]] objectAtIndex:indexPath.row] valueForKey:@"_placeCity"], [[[dictPlaces objectForKey:[NSString stringWithFormat:@"%d", tableView.tag]] objectAtIndex:indexPath.row] valueForKey:@"_placeZip"], [[[dictPlaces objectForKey:[NSString stringWithFormat:@"%d", tableView.tag]] objectAtIndex:indexPath.row] valueForKey:@"_placeState"]];
    cell.lblPlaceAddressCell.text = strAddress;
    if (![[[[dictPlaces objectForKey:[NSString stringWithFormat:@"%d", tableView.tag]] objectAtIndex:indexPath.row] valueForKey:@"_placeImage"]  isEqual: @""]) {
        [cell.imgPlace setImageWithURL:[NSURL URLWithString:[[[dictPlaces objectForKey:[NSString stringWithFormat:@"%d", tableView.tag]] objectAtIndex:indexPath.row] valueForKey:@"_placeImage"]] placeholderImage:[UIImage imageNamed:@"imagenotfound.png"]];
    }
    DYRateView *rateView = [[DYRateView alloc] initWithFrame:CGRectMake(75, 62, 200, 30)];
    rateView.rate = [[[[dictPlaces objectForKey:[NSString stringWithFormat:@"%d", tableView.tag]] objectAtIndex:indexPath.row] valueForKey:@"_placeRating"] doubleValue];
//    rateView.alignment = RateViewAlignmentLeft;
//    [cell addSubview:rateView];
    [cell.lblPlaceRatingCell setText:[NSString stringWithFormat:@"%0.2f", rateView.rate]];
    if (indexPath.row % 2 == 0) {
        [cell.contentView setBackgroundColor:[UIColor colorWithRed:60/255.0f green:193/255.0f blue:200/255.0f alpha:1]];
        [cell.lblPlaceTitleCell setTextColor:[UIColor whiteColor]];
        [cell.lblPalceRatingLabelCell setTextColor:[UIColor whiteColor]];
        [cell.lblPlaceAddressCell setTextColor:[UIColor whiteColor]];
    } else {
        [cell.contentView setBackgroundColor:[UIColor colorWithRed:140/255.0f green:221/255.0f blue:223/255.0f alpha:1]];
        [cell.lblPlaceTitleCell setTextColor:[UIColor blackColor]];
        [cell.lblPalceRatingLabelCell setTextColor:[UIColor blackColor]];
        [cell.lblPlaceAddressCell setTextColor:[UIColor blackColor]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    DetailViewController *objDetailViewController = [storyBoard instantiateViewControllerWithIdentifier:@"DetailViewController"];
//    objDetailViewController.placeID = [tableView cellForRowAtIndexPath:indexPath].tag;
//    [self presentViewController:objDetailViewController animated:YES completion:nil];
    
    ClaimMyPlaceViewController *vc =[[ClaimMyPlaceViewController alloc] initWithNibName:@"ClaimMyPlaceViewController" bundle:nil];
    vc.placeID = [tableView cellForRowAtIndexPath:indexPath].tag;
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}

#pragma mark - IBAction Method
- (IBAction)btnCancelTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)segmentChange:(id)sender
{
    UISegmentedControl *segment = sender;
    if (segment.selectedSegmentIndex == 1) {
        vwMap.hidden = NO;
    } else {
        vwMap.hidden = YES;
    }
}

- (IBAction)btnSearchPlace:(id)sender
{
    [self getPlaceByCategoryAndSearch:self.categoryID searchText:[txtSearch text]];
}

- (IBAction)btnIncrementPage:(id)sender
{
    if (_pageCount == _numPages) {
        return;
    }
    _pageCount++;
    [self.tblPlace setTag:_pageCount];
    [self.tblPlace reloadData];
    [lblPageNumber setText:[NSString stringWithFormat:@"Página : %lu", (unsigned long)_pageCount]];
    pagingTable.currentPage = _pageCount-1;
}

- (IBAction)btnDecrementPage:(id)sender
{
    if (_pageCount == 1) {
        return;
    }
    _pageCount--;
    [self.tblPlace setTag:_pageCount];
    [self.tblPlace reloadData];
    [lblPageNumber setText:[NSString stringWithFormat:@"Página : %lu", (unsigned long)_pageCount]];
    pagingTable.currentPage = _pageCount-1;
}

- (IBAction)btnSortingPlaceTapeed:(id)sender
{
    objAppDelegate.isSorting = YES;
    if(dropDown == nil) {
        CGFloat f = 160;
        dropDown = [[NIDropDown alloc] showDropDown:sender :&f :marrSortingThing :nil :@"down"];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
    }
}

#pragma mark - Other Method
- (void)loadData
{
    objAppDelegate = [[UIApplication sharedApplication] delegate];
    if (_isCategory) {
        [self getPlaceByCategoryAndSearch:self.categoryID searchText:@""];
    } else {
        [self getPlaceByCategoryAndSearch:0 searchText:self.searchWord];
    }
    marrSortingThing = [[NSMutableArray alloc] initWithObjects:@"Nenhum", @"Nota", @"Crescente", @"Decrescente", nil];
}

-(void) fillData
{
    int num = 6, count = 1;
    _pageCount = 1;
    while (num < objAppDelegate.marrPlace.count) {
        num += 6;
        count++;
    }
    _numPages = count;
    int k = 6, pagenumber = 1;
    dictPlaces = [[NSMutableDictionary alloc] init];
    NSMutableArray *marr = [[NSMutableArray alloc] init];
    for (int i=0; i<objAppDelegate.marrPlace.count; i++) {
        k--;
        [marr addObject:[objAppDelegate.marrPlace objectAtIndex:i]];
        if (k == 0) {
            [dictPlaces setValue:marr forKey:[NSString stringWithFormat:@"%d", pagenumber]];
            k = 6;
            pagenumber++;
            marr = nil;
            marr = [[NSMutableArray alloc] init];
        }
    }
    [dictPlaces setValue:marr forKey:[NSString stringWithFormat:@"%d", pagenumber]];
    self.pagingTable.currentPage = _pageCount-1;
    self.pagingTable.numberOfPages = _numPages;
    [self.tblPlace setTag:1];
    [self.tblPlace reloadData];
    if (_numPages > 1) {
        pagingTable.hidden = NO;
    } else {
        pagingTable.hidden = YES;
    }
}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender isNoneSelect:(BOOL)isNone
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self rel];
    if (isNone) {
        [btnSortingPlace setTitle:@"Ordenar" forState:UIControlStateNormal];
    }
    [self performSelector:@selector(sortTable:) withObject:sender afterDelay:0.1];
}

-(void) sortTable:(NIDropDown *)sender
{
    NSArray *sortedArray;
    if ([sender.nameTitle isEqual:@"Crescente"]) {
        NSSortDescriptor *sortDescriptor;
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_placeName"
                                                     ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        sortedArray = [objAppDelegate.marrPlace sortedArrayUsingDescriptors:sortDescriptors];
    } else if ([sender.nameTitle isEqual:@"Decrescente"]) {
        NSSortDescriptor *sortDescriptor;
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_placeName"
                                                     ascending:NO];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        sortedArray = [objAppDelegate.marrPlace sortedArrayUsingDescriptors:sortDescriptors];
    } else if ([sender.nameTitle isEqual:@"Nota"]) {
        NSSortDescriptor *sortDescriptor;
        
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_placeRating"
                                                     ascending:NO];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        sortedArray = [objAppDelegate.marrPlace sortedArrayUsingDescriptors:sortDescriptors];
    } else {
        [self fillData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        return;
    }
    NSMutableArray *marrSort = [[NSMutableArray alloc] initWithArray:sortedArray];
    int num = 6, count = 1;
    _pageCount = 1;
    while (num < marrSort.count) {
        num += 6;
        count++;
    }
    _numPages = count;
    int k = 6, pagenumber = 1;
    dictPlaces = [[NSMutableDictionary alloc] init];
    NSMutableArray *marr = [[NSMutableArray alloc] init];
    for (int i=0; i<marrSort.count; i++) {
        k--;
        [marr addObject:[marrSort objectAtIndex:i]];
        if (k == 0) {
            [dictPlaces setValue:marr forKey:[NSString stringWithFormat:@"%d", pagenumber]];
            k = 6;
            pagenumber++;
            marr = nil;
            marr = [[NSMutableArray alloc] init];
        }
    }
    [lblPageNumber setText:@"Página : 1"];
    [dictPlaces setValue:marr forKey:[NSString stringWithFormat:@"%d", pagenumber]];
    self.pagingTable.currentPage = _pageCount-1;
    self.pagingTable.numberOfPages = _numPages;
    [self.tblPlace setTag:1];
    [self.tblPlace reloadData];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void)rel {
    dropDown = nil;
}

#pragma mark - MHPagingScrollViewDelegate
- (NSUInteger)numberOfPagesInPagingScrollView:(MHPagingScrollView *)pagingScrollView
{
    return _numPages;
}

- (UIView *)pagingScrollView:(MHPagingScrollView *)thePagingScrollView pageForIndex:(NSUInteger)index
{
    PageView *pageView = (PageView *)[thePagingScrollView dequeueReusablePage];
    if (pageView == nil)
        pageView = [[PageView alloc] init];
    
    [pageView setPageIndex:index];
    return pageView;
}

- (void)rateView:(DYRateView *)rateView changedToNewRate:(NSNumber *)rate
{
    
}
#pragma mark - API Call
-(void) getPlaceByCategoryAndSearch:(NSInteger)categoryID searchText:(NSString *)text
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld", (long)categoryID], @"Cat_Id", text, @"KeyWord", nil];
    [manager POST:[NSString stringWithFormat:@"http://www.opine.com.br/OpineAPI/api/place/record"]
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"getPlaceByCategory responseObject = %@", [NSString stringWithUTF8String:[responseObject bytes]]);
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
                  objPlace.placeRating = [[[arrPlace objectAtIndex:i] valueForKey:@"Rating"] doubleValue];
                  objPlace.placeLatitude = [[arrPlace objectAtIndex:i] valueForKey:@"Pla_Lat"];
                  objPlace.placeLongitude = [[arrPlace objectAtIndex:i] valueForKey:@"Pla_Lon"];
                  [objAppDelegate.marrPlace addObject:objPlace];
              }
              [self fillData];
              [self addLocaationPin];
              [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if (error) {
                  NSLog(@"getPlaceByCategory error = %@", error);
              }
              [MBProgressHUD hideHUDForView:self.view animated:YES];
          }];
}

@end
