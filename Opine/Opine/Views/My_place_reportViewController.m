//
//  My_place_reportViewController.m
//  Opine
//
//  Created by apple on 03/01/15.
//  Copyright (c) 2015 TheAppGururz. All rights reserved.
//

#import "My_place_reportViewController.h"
#import "AppDelegate.h"
#import "comment_count_Cell.h"

@interface My_place_reportViewController ()
{
    AppDelegate *objAppDelegate;
    NSMutableArray *array_comment,*array_tittle,*array_date;
    IBOutlet UISegmentedControl *segment_action;
    
    NSDictionary *dic_response;
    IBOutlet UIView *comment_view;
    IBOutlet UIView *graph_view;
     NSMutableArray *pointArr,*vArr,*hArr;
    LineChartView *lineChartView;
    IBOutlet UIWebView *webview_chart;
    IBOutlet UIImageView *img_chart;
    IBOutlet UIScrollView *scroll_crap;
    IBOutlet UIWebView *webview;
}
@end

@implementation My_place_reportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [segment_action addTarget:self
                         action:@selector(action:)
               forControlEvents:UIControlEventValueChanged];
    
    objAppDelegate = [UIApplication sharedApplication].delegate;
    
    [self performSelector:@selector(service_count:) withObject:@"None" afterDelay:0.2];
    [self performSelector:@selector(webservice_load_webview:) withObject:@"None" afterDelay:0.2];
    
    array_comment = [NSMutableArray new];
    array_date = [NSMutableArray new];
    array_tittle = [NSMutableArray new];
    
    dic_response = [NSDictionary new];
    
    isfrom_comment = YES;
    
    
    [tbl_comment setBackgroundColor:[UIColor colorWithRed:140/255.0f green:221/255.0f blue:223/255.0f alpha:1]];
    
    // webview.scalesPageToFit = NO;
    // [webview stringByEvaluatingJavaScriptFromString:@"document. body.style.zoom = 5.0;"];
}

- (IBAction)action:(id)sender
{
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    
    if (selectedSegment == 0)
    {
        comment_view.hidden = NO;
        graph_view.hidden = YES;
        isfrom_comment = YES;
    }
    else
    {
        isfrom_comment = NO;
        comment_view.hidden = YES;
        graph_view.hidden = NO;
    }
}
-(void) service_count : (NSString *) str_type
{
    NSDictionary *dic ;
    
    str_shorting_type = str_type;
    
    if ([str_type isEqualToString:@"Week"])
    {
        dic = @{ @"place_id" :[NSString stringWithFormat:@"%d",_str_placeid],
                 @"type"    : @"w",
                 };
    }
    else if ([str_type isEqualToString:@"Year"])
    {
        dic = @{ @"place_id" :[NSString stringWithFormat:@"%d",_str_placeid],
                 @"type"    : @"y",
                 };
    }
    else if ([str_type isEqualToString:@"Month"])
    {
        dic = @{ @"place_id" :[NSString stringWithFormat:@"%d",_str_placeid],
                 @"type"    : @"m",
                 };
    }
    else
    {
        dic = @{ @"place_id" :[NSString stringWithFormat:@"%d",_str_placeid]
                 };
    }
    
  /*  NSError *error;
    NSString *str_url = [NSString stringWithFormat:@"http://opine.com.br/OpineAPI/application/controllers/api/comment_view.php?place_id=%@&type=%@",[NSString stringWithFormat:@"%d",_str_placeid],str_type];
    NSURL *url = [NSURL URLWithString:[str_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]; //_str_place_id,txtfi_field1.text, txtfi_field2.text
   if (url!=nil)
   {
   NSData *Get_data = [NSData dataWithContentsOfURL:url options:kNilOptions error:&error];
   if (Get_data!= nil)
   {
   dic_response = [NSJSONSerialization JSONObjectWithData:Get_data options:0 error:NULL];
   }
   }*/
 
    NSString *str_url = @"http://opine.com.br/OpineAPI/api/myplace/commentreport?";
    // Post Service
    dic_response  = [Utility_Class Request_service_get_response_in_Post:dic :str_url];
    
    if ([[dic_response valueForKeyPath:@"Message"] isEqualToString:@"Success"])
    {
        lbl_comment_count.text = [NSString stringWithFormat:@"%d", [[[dic_response valueForKeyPath:@"Comments"] valueForKey:@"Com_Comment"] count]];
        lbl_rate_count.text = [NSString stringWithFormat:@"%d",  [[[dic_response valueForKeyPath:@"Comments"] valueForKey:@"Com_Comment"] count]];
    }
    else
    {
        UIAlertView *alertr = [[UIAlertView alloc]initWithTitle:@"Warning!" message:[dic_response valueForKeyPath:@"MessageInfo"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertr show];
    }
    
    [tbl_comment reloadData];
}
-(void) webservice_load_webview : (NSString *) str_type
{
    str_shorting_type = str_type;
    
    NSURL *url;
    if ([str_type isEqualToString:@"Week"])
    {
        str_type = @"Week";
    }
    else if ([str_type isEqualToString:@"Year"])
    {
        str_type = @"Year";
    }
    else if ([str_type isEqualToString:@"Month"])
    {
        str_type = @"Month";
    }
    else
    {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.opine.com.br/OpineAPI/api/graph/create?Pla_Id=%d&filter=%@",_str_placeid, str_type]];
        
        NSURLRequest *nsrequest=[NSURLRequest requestWithURL:url];
        webview.scalesPageToFit=YES;
        [webview loadRequest:nsrequest];
        
        return;
    }
    url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.opine.com.br/OpineAPI/api/graph/create?Pla_Id=%d&filter=%@",_str_placeid, str_type]];
    
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:url];
    webview.scalesPageToFit=YES;
    [webview loadRequest:nsrequest];
}

-(NSMutableArray *) arry_chaning : (NSMutableArray *) array
{
    NSMutableArray *array_temp = [NSMutableArray new];
    for (NSMutableArray *arr in array)
    {
        [array_temp addObjectsFromArray:arr];
    }
    return array_temp;
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[dic_response valueForKeyPath:@"Comments"] valueForKey:@"Com_Comment"] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    comment_count_Cell *cell =(comment_count_Cell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    if (cell == nil)
    {
        cell=(comment_count_Cell *)[[[NSBundle mainBundle] loadNibNamed:@"comment_count_Cell" owner:self options:nil]objectAtIndex:0];
    }
    cell.backgroundColor = [UIColor colorWithRed:120/255.0f green:214/255.0f blue:216/255.0f alpha:1.0f];
    if (indexPath.row % 2 == 0)
    {
        [cell.contentView setBackgroundColor:[UIColor colorWithRed:60/255.0f green:193/255.0f blue:200/255.0f alpha:1]];
        [cell.textLabel setBackgroundColor:[UIColor colorWithRed:60/255.0f green:193/255.0f blue:200/255.0f alpha:1]];
        [cell.textLabel setTextColor:[UIColor whiteColor]];
        
        cell.lbl_place_tittle.textColor = [UIColor whiteColor];
        cell.lbl_place_date.textColor = [UIColor whiteColor];
        cell.lbl_place_comment.textColor = [UIColor whiteColor];
    }
    else
    {
        [cell.textLabel setBackgroundColor:[UIColor colorWithRed:140/255.0f green:221/255.0f blue:223/255.0f alpha:1]];
        [cell.contentView setBackgroundColor:[UIColor colorWithRed:140/255.0f green:221/255.0f blue:223/255.0f alpha:1]];
        
        
        cell.lbl_place_tittle.textColor = [UIColor blackColor];
        cell.lbl_place_date.textColor = [UIColor blackColor];
        cell.lbl_place_comment.textColor = [UIColor blackColor];
    }

    
    cell.lbl_place_tittle.text = [NSString stringWithFormat:@"%@",[[dic_response valueForKeyPath:@"Comments"] valueForKey:@"Com_Title"] [indexPath.row]];
    cell.lbl_place_comment.text =  [NSString stringWithFormat:@"%@",[[dic_response valueForKeyPath:@"Comments"] valueForKey:@"Com_Comment"] [indexPath.row]];
    cell.lbl_place_date.text =  [NSString stringWithFormat:@"%@",[[dic_response valueForKeyPath:@"Comments"] valueForKey:@"Com_Date"] [indexPath.row]];
    
    return cell;
}

- (IBAction)btn_back_action:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void) niDropDownDelegateMethod: (NIDropDown *) sender isNoneSelect:(BOOL)isNone
{
    [self rel];
    [self performSelector:@selector(service_count:) withObject:sender.nameTitle afterDelay:0.1];
    [self performSelector:@selector(webservice_load_webview:) withObject:sender.nameTitle afterDelay:0.2];
}

- (IBAction)btn_drop_down_action:(id)sender
{
    objAppDelegate.isSorting = YES;
    NSMutableArray *array = [[NSMutableArray alloc]initWithObjects:@"None",@"Week",@"Month",@"Year",nil];
    
    if(dropDown == nil)
    {
        CGFloat f = 160;
        dropDown = [[NIDropDown alloc] showDropDown:sender :&f :array :nil :@"down"];
        dropDown.delegate = self;
    }
    else
    {
        [dropDown hideDropDown:sender];
        [self rel];
    }
}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender :(NSString *)getSelectedName
{
    
    [self rel];
}

-(void)rel
{
    dropDown = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - share button action

- (IBAction)btn_share_action:(id)sender
{
    NSLog(@"%hhd %@", isfrom_comment, str_shorting_type);
    
    [self performSelectorInBackground:@selector(share_webservice) withObject:nil];
   // [self shareData];
}
-(void) share_webservice
{
    NSString *str_url = @"http://opine.com.br/OpineAPI/api/myplace/commentreportshare?Pla_Id={place_id}&Usr_SessionID={User Session Id}";
    
    NSDictionary *dic;
    if (isfrom_comment)
    {
        str_url = @"http://opine.com.br/OpineAPI/api/myplace/commentreportshare?";
        if ([str_shorting_type isEqualToString:@"None"])
        {
            dic = @{ @"Pla_Id" :[NSString stringWithFormat:@"%d",_str_placeid],
                     @"Usr_SessionID"    : objAppDelegate.userSessionID
                     };
        }
        else if ([str_shorting_type isEqualToString:@"Week"])
        {
            dic = @{ @"Pla_Id" :[NSString stringWithFormat:@"%d",_str_placeid],
                     @"Usr_SessionID"    : objAppDelegate.userSessionID,
                     @"type" : @"w"
                     };
        }
        else if ([str_shorting_type isEqualToString:@"Month"])
        {
            dic = @{ @"Pla_Id" :[NSString stringWithFormat:@"%d",_str_placeid],
                     @"Usr_SessionID"    : objAppDelegate.userSessionID,
                     @"type" : @"m"
                     };
        }
        else if ([str_shorting_type isEqualToString:@"Year"])
        {
            dic = @{ @"Pla_Id" :[NSString stringWithFormat:@"%d",_str_placeid],
                     @"Usr_SessionID"    : objAppDelegate.userSessionID,
                     @"type" : @"y"
                     };
        }
    }
    else
    {
        str_url = @"http://opine.com.br/OpineAPI/api/graph/share?";
        if ([str_shorting_type isEqualToString:@"None"])
        {
            dic = @{ @"Pla_Id" :[NSString stringWithFormat:@"%d",_str_placeid],
                     @"Usr_SessionID"    : objAppDelegate.userSessionID
                     };
        }
        else if ([str_shorting_type isEqualToString:@"Week"])
        {
            dic = @{ @"Pla_Id" :[NSString stringWithFormat:@"%d",_str_placeid],
                     @"Usr_SessionID"    : objAppDelegate.userSessionID,
                     @"type" : @"w"
                     };
        }
        else if ([str_shorting_type isEqualToString:@"Month"])
        {
            dic = @{ @"Pla_Id" :[NSString stringWithFormat:@"%d",_str_placeid],
                     @"Usr_SessionID"    : objAppDelegate.userSessionID,
                     @"type" : @"m"
                     };
        }
        else if ([str_shorting_type isEqualToString:@"Year"])
        {
            dic = @{ @"Pla_Id" :[NSString stringWithFormat:@"%d",_str_placeid],
                     @"Usr_SessionID"    : objAppDelegate.userSessionID,
                     @"type" : @"y"
                     };
        }
    }
    
    // Post Service
    NSDictionary * dic_res  = [Utility_Class Request_service_get_response_in_Post:dic :str_url];
    if ([[dic_res valueForKeyPath:@"Success"] isEqualToString:@"0"])
    {
        [[[UIAlertView alloc]initWithTitle:@"Warning!" message:[dic_res valueForKeyPath:@"MessageInfo"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
    }
    else
    {
        [[[UIAlertView alloc]initWithTitle:@"Success!" message:[dic_res valueForKeyPath:@"MessageInfo"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
    }
}
-(void) shareData
{
    UIImage *imagetoshare;
    if (![objPlaceDetail.placeImage isEqual: @""]) {
        NSURL *url = [[NSURL alloc] initWithString:@"http://www.opine.com.br/betasite/admintool/upload/place/13_PL_1417011213_hospital-samaritano-convenios.jpg"];
        NSData *imgData = [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:nil];
        imagetoshare = [UIImage imageWithData:imgData];
    }
    NSString *placeName = [[dic_response valueForKeyPath:@"Comments"] valueForKey:@"Com_Title"] [0];
    NSString *strAddress = [NSString stringWithFormat:@"%@, %@", [[dic_response valueForKeyPath:@"Comments"] valueForKey:@"Com_Comment"] [0], [[dic_response valueForKeyPath:@"Comments"] valueForKey:@"Com_Date"] [0]];
    NSString *placeAddress = strAddress;
    NSString *placeRating = [NSString stringWithFormat:@"Total Rating : %@", [[dic_response valueForKeyPath:@"Comments"] valueForKey:@"Com_Date"] [0]];
    NSString *textToShare;
   
    textToShare = @"Hey Friends, I am here at Awseome place...";

    NSURL *myWebsite = [NSURL URLWithString:@"http://www.opine.com.br"];
    NSArray *objectsToShare = @[textToShare, placeName, placeAddress, placeRating, myWebsite, imagetoshare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo];
    activityVC.excludedActivityTypes = excludeActivities;
    [self presentViewController:activityVC animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
