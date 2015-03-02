//
//  My_Places_ViewController.m
//  Opine
//
//  Created by apple on 02/01/15.
//  Copyright (c) 2015 TheAppGururz. All rights reserved.
//

#import "My_Places_ViewController.h"
#import "SettingViewController.h"
#import "ECSlidingViewController.h"
#import "PlaceTableViewCell.h"
#import "My_Places_Cell.h"
#import "DetailViewController.h"
#import "LineChartView.h"
#import "UIImageView+WebCache.h"
#import "Utility_Class.h"

@interface My_Places_ViewController ()<SettingTableViewControllerDelegate>
{
    IBOutlet UITableView *tbl_places;
    NSMutableArray *marrSettingItem;
    
    NSMutableArray *address_array,*place_array,*comment_array,*comment_name_arr,*arr_avg_rating, *arr_image;
    
    IBOutlet UIButton *btn_report;
    
    
    IBOutlet UIButton *btn_shorting;
    NSDictionary *dic;
    
    IBOutlet UIActivityIndicatorView *activity_indicator;
    
}
@end

@implementation My_Places_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    objAppDelegate = [[UIApplication sharedApplication] delegate];
    // Do any additional setup after loading the view from its nib.
    [self loadData];
    
    dic_catch = [NSMutableDictionary new];
    tbl_places.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tbl_places.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

-(NSDictionary *) webservice_to_save_claim : (NSString *) str_url : (NSString *) str_type
{
    address_array = [NSMutableArray new];
    place_array = [NSMutableArray new];
    comment_array = [NSMutableArray new];
    comment_name_arr = [NSMutableArray new];
    arr_avg_rating = [NSMutableArray new];
    arr_image = [NSMutableArray new];
    NSError *error;
    NSURL *url;
    if (str_type.length == 0)
    {
        url = [NSURL URLWithString:[NSString stringWithFormat:str_url, objAppDelegate.userSessionID]];
    }
    else
    {
        url = [NSURL URLWithString:[NSString stringWithFormat:str_url, objAppDelegate.userSessionID, str_type]];
    }
    
    NSDictionary *Get_Response ;
    if (url!=nil)
    {
        NSData *Get_data = [NSData dataWithContentsOfURL:url options:kNilOptions error:&error];
        if (Get_data!= nil)
        {
            Get_Response = [NSJSONSerialization JSONObjectWithData:Get_data options:0 error:NULL];
        }
    }
    return Get_Response;
}
-(void) fecthing_places
{
    // dic1 =  [self webservice_to_save_claim : @"http://opine.com.br/OpineAPI/application/controllers/api/placeid.php?user_id=%@&type=1" : nil];
    
//    http://opine.com.br/OpineAPI/api/myplace/list?user_id=8gabmws4yki7h613x9fru
    
    dic = @{@"user_id": objAppDelegate.userSessionID,
            };
    dic = [Utility_Class Request_service_get_response_in_Post:dic :@"http://opine.com.br/OpineAPI/api/myplace/list?"];
    NSString *str =[NSString stringWithFormat:@"%@", [dic valueForKeyPath:@"Success"]];
    if ([str isEqualToString:@"1"])
    {
        address_array = [dic valueForKeyPath:@"MyPlaces.Pla_Address"];
        NSLog(@"%@", address_array);
        place_array = [dic valueForKeyPath:@"MyPlaces.Pla_Name"];
        arr_avg_rating = [dic valueForKeyPath:@"MyPlaces.Rating"];
    }
    else
    {
        [[[UIAlertView alloc]initWithTitle:@"Warning!" message:@"No Places Available!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [tbl_places reloadData];
}
-(void) viewWillAppear:(BOOL)animated
{
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelector:@selector(fecthing_places) withObject:nil afterDelay:0.2];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData
{
    objAppDelegate = [[UIApplication sharedApplication] delegate];
    objAppDelegate.marrCategory = [[NSMutableArray alloc] init];
    objAppDelegate.marrPlace = [[NSMutableArray alloc] init];
    if (objAppDelegate.isLogin)
    {
        if (objAppDelegate.ispaid_user) {
            marrSettingItem = [[NSMutableArray alloc] initWithObjects:@"My Profile",@"My Places", @"About US", nil];
        } else {
            marrSettingItem = [[NSMutableArray alloc] initWithObjects:@"My Profile",@"About US", nil];
        }
        
    }
    else
    {
        marrSettingItem = [[NSMutableArray alloc] initWithObjects:@"About US", nil];
    }
}

- (IBAction)btn_meanu_click:(id)sender
{
    if (is_places_selcted)
    {
        is_places_selcted = NO;
        btn_report.hidden = YES;
        [tbl_places reloadData];
    }
    else
        [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btn_report_action:(id)sender
{
    My_place_reportViewController *controller = [[My_place_reportViewController alloc] initWithNibName:@"My_place_reportViewController" bundle:nil];
    controller.str_placeid = [[dic valueForKeyPath:@"response.Message.Id"] [0] intValue];
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - drop down delegates

- (IBAction)btn_sorting_place:(id)sender
{
    objAppDelegate.isSorting = YES;
    NSMutableArray *array = [[NSMutableArray alloc]initWithObjects:@"None",@"Rating",@"Ascending",@"Descending",nil];
    
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

- (void) niDropDownDelegateMethod: (NIDropDown *) sender isNoneSelect:(BOOL)isNone
{
    [self rel];
    if (isNone)
    {
        [btn_shorting setTitle:@"Sorting Place" forState:UIControlStateNormal];
    }
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self performSelector:@selector(shorting:) withObject:sender afterDelay:0.2];
}
-(void) shorting : (NIDropDown *) sender
{
    if ([sender.nameTitle isEqual:@"Ascending"])
    {
        [btn_shorting setTitle:@"Ascending" forState:UIControlStateNormal];
        dic =  [self webservice_to_save_claim : @"http://opine.com.br/OpineAPI/application/controllers/api/placeid.php?user_id=%@&type=1" : nil];
    }
    else if ([sender.nameTitle isEqual:@"Descending"])
    {
        [btn_shorting setTitle:@"Descending" forState:UIControlStateNormal];
        dic =  [self webservice_to_save_claim : @"http://opine.com.br/OpineAPI/application/controllers/api/placeid.php?user_id=%@&type=2" : nil];
    }
    else if ([sender.nameTitle isEqual:@"Rating"])
    {
        [btn_shorting setTitle:@"Rating" forState:UIControlStateNormal];
         dic =  [self webservice_to_save_claim : @"http://opine.com.br/OpineAPI/application/controllers/api/placeid.php?user_id=%@&type=4" : nil];
    }
    else if ([sender.nameTitle isEqual:@"None"])
    {
        dic =  [self webservice_to_save_claim : @"http://opine.com.br/OpineAPI/application/controllers/api/placeid.php?user_id=%@" : nil];
    }
    
    NSString *str =[NSString stringWithFormat:@"%@", [dic valueForKeyPath:@"response.Success"]];
    if ([str isEqualToString:@"1"])
    {
        address_array = [dic valueForKeyPath:@"response.Message.Address"];
        NSLog(@"%@", address_array);
        place_array = [dic valueForKeyPath:@"response.Message.Place_name"];
        arr_avg_rating = [dic valueForKeyPath:@"response.Message.Avg_Rating"];
    }
    else
    {
        [[[UIAlertView alloc]initWithTitle:@"Warning!" message:@"No Places Available!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [tbl_places reloadData];
}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender :(NSString *)getSelectedName
{
    [self rel];
}

-(void)rel
{
    dropDown = nil;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (is_places_selcted)
    {
        return [comment_array count];
    }
    return [address_array count];//[marrSetting count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;//selectedIndex ? height+100 : height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    My_Places_Cell *cell =(My_Places_Cell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    if (cell == nil)
    {
        cell=(My_Places_Cell *)[[[NSBundle mainBundle] loadNibNamed:@"My_Places_Cell" owner:self options:nil]objectAtIndex:0];
    }
    cell.backgroundColor = [UIColor colorWithRed:120/255.0f green:214/255.0f blue:216/255.0f alpha:1.0f];
    
    if (indexPath.row % 2 == 0)
    {
        [cell.contentView setBackgroundColor:[UIColor colorWithRed:60/255.0f green:193/255.0f blue:200/255.0f alpha:1]];
        [cell.textLabel setBackgroundColor:[UIColor colorWithRed:60/255.0f green:193/255.0f blue:200/255.0f alpha:1]];
        [cell.textLabel setTextColor:[UIColor whiteColor]];
        
        cell.lbl_place_tittle.textColor = [UIColor whiteColor];
        cell.lbl_place_address.textColor = [UIColor whiteColor];
        cell.lbl_rating.textColor = [UIColor whiteColor];
    }
    else
    {
        [cell.textLabel setBackgroundColor:[UIColor colorWithRed:140/255.0f green:221/255.0f blue:223/255.0f alpha:1]];
        [cell.contentView setBackgroundColor:[UIColor colorWithRed:140/255.0f green:221/255.0f blue:223/255.0f alpha:1]];
        
      
        cell.lbl_place_tittle.textColor = [UIColor blackColor];
        cell.lbl_place_address.textColor = [UIColor blackColor];
        cell.lbl_rating.textColor = [UIColor blackColor];
    }
    
     [cell.img_user setImageWithURL:[NSURL URLWithString:[self get_my_proper_string:[NSString stringWithFormat:@"%@",[dic valueForKeyPath:@"MyPlaces.Pla_Image"][indexPath.row]]]] placeholderImage:[UIImage imageNamed:@"imagenotfound.png"]];
    
    
    cell.btn_place_edit.tag = indexPath.row;
    [cell.btn_place_edit addTarget:self action:@selector(btn_edit_action:) forControlEvents:UIControlEventTouchUpInside];
    cell.lbl_place_tittle.text =[self get_my_proper_string:place_array [indexPath.row]];
    cell.lbl_place_address.text = [self get_my_proper_string:address_array[indexPath.row]];
    cell.lbl_place_rating.text =[self get_my_proper_string:[NSString stringWithFormat:@"%.2f",[arr_avg_rating[indexPath.row] floatValue]]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(NSString *) get_my_proper_string : (NSString *) str_value
{
    if ([str_value isEqual:[NSNull null]] || str_value == nil)
    {
        str_value = @"";
    }
    return str_value;
}
-(void) btn_edit_action : (UIButton *) button
{
    NSLog(@"model: %@", [[UIDevice currentDevice] model]);
    edit_placeViewController *controller;
    
    controller = [[edit_placeViewController alloc] initWithNibName:@"edit_placeViewController" bundle:nil];
    NSDictionary *dic11 = [[dic valueForKeyPath:@"MyPlaces"] objectAtIndex:button.tag];
    controller.dic_response = dic11;
    controller.str_place_id =[[self get_my_proper_string:[dic valueForKeyPath:@"MyPlaces.Pla_Id"] [button.tag]] intValue];
    [self presentViewController:controller animated:YES completion:nil];
}


#pragma mark - Tableview Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [self.delegate openViewBySetting:indexPath.row];
   /* is_places_selcted = YES;
    
    btn_report.hidden = NO;
    
    comment_array = [dic valueForKeyPath:@"response.Message.Comment.Comment"] [indexPath.row];
    comment_name_arr = [dic valueForKeyPath:@"response.Message.Comment.Username"] [indexPath.row];
    NSLog(@"%@ %@", comment_array, comment_name_arr);
    [tbl_places reloadData];*/
    
   // NSDictionary *dic11 = [[dic1 valueForKeyPath:@"response.Message"] objectAtIndex:indexPath.row];
    
    place_detail_view *controller;
    controller = [[place_detail_view alloc] initWithNibName:@"place_detail_view" bundle:nil];
  //  controller.dic_details = dic11;
     controller.str_place_id =[self get_my_proper_string:[dic valueForKeyPath:@"MyPlaces.Pla_Id"] [indexPath.row]];
    [self presentViewController:controller animated:YES completion:nil];
    
   /* UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailViewController *objDetailViewController = [storyBoard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    objDetailViewController.placeID = [[dic valueForKeyPath:@"response.Message.Id"] [indexPath.row] intValue];//[tableView cellForRowAtIndexPath:indexPath].tag;
    objDetailViewController.isfrom_myplace = YES;
    [self presentViewController:objDetailViewController animated:YES completion:nil];*/
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
