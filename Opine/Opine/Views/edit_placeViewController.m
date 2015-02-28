//
//  edit_placeViewController.m
//  Opine
//
//  Created by apple on 06/01/15.
//  Copyright (c) 2015 TheAppGururz. All rights reserved.
//

#import "edit_placeViewController.h"
#import "Utility_Class.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"

@interface edit_placeViewController ()
{
    
    IBOutlet UIImageView *img_profile;

    
    NSMutableArray *arr_table_values;
    
    // PLace Details View
    IBOutlet UIView *view_place_detail;
    IBOutlet UIImageView *img_place;
    IBOutlet UILabel *lbl_place_address;
    IBOutlet UILabel *lbl_place_description;
    IBOutlet UILabel *lbl_place_frate;
    
    
    //Editing Places
    IBOutlet UIView *view_edit_places;
    
    //Place user Details
    IBOutlet UITextField *txt_place_name;
    IBOutlet UITextField *txt_address;
    IBOutlet UITextField *txt_zip;
    IBOutlet UITextField *txt_city;
    IBOutlet UITextField *txt_state;

    IBOutlet UITextField *txt_polling1;
    IBOutlet UITextField *txt_polling2;
    
    IBOutlet UITextView *txtv_add_message;
    
    int textfield_tag;
    IBOutlet UIScrollView *scro_view;
    
    IBOutlet UIButton *btn_state;
    NSDictionary *dic_state,*dic_details;
    
    NSMutableArray *arry_key,*arry_value;
    NSData *dataImage;
}
@end

@implementation edit_placeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self performSelectorInBackground:@selector(show_image) withObject:nil];
    [self set_values];
    
    [img_profile layer].cornerRadius = img_profile.frame.size.width/2;
    img_profile.clipsToBounds = YES;
    
    controller = [UIImagePickerController new];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resign_keyboard)];
    [scro_view addGestureRecognizer:tap];
    [tap setCancelsTouchesInView:NO];
    

    objAppDelegate = [[UIApplication sharedApplication] delegate];
    
    // fetch commetns details // http://opine.com.br/OpineAPI/api/myplace/detail?user_id=mrp7vnqhe92bacu3d6z8k&place_id=13
    
  //  [self performSelector:@selector(get_data_from_service) withObject:nil afterDelay:0.2];
    
    [self performSelector:@selector(get_state_service) withObject:nil afterDelay:0.2];
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch
{
    if([touch.view class] == tbl_state_list.class)
    {
        return NO; //YES/NO
    }
    
    return YES; //YES/NO
    
}

-(void) get_state_service
{
    arry_key = [NSMutableArray new];
    arry_value = [NSMutableArray new];
    
    NSDictionary * dic_data = @{ @"place_id" :[NSString stringWithFormat:@"%d",_str_place_id],
                           };
    NSString *str_url = @"http://opine.com.br/OpineAPI/api/place/states?"; //
    // Post Service
    dic_state  = [Utility_Class Request_service_get_response_in_Post:dic_data :str_url];
    if (dic_state)
    {
        if ([[NSString stringWithFormat:@"%@", [dic_state valueForKeyPath:@"Message"]] isEqualToString:@"Success"])
        {
            dic_state = [dic_state valueForKeyPath:@"State"];
            
            NSLog(@"%@", [dic_state allKeys]);
            
            for (int i=0; i<[dic_state allKeys].count; i++)
            {
                [arry_value addObject:[dic_state valueForKey:[dic_state allKeys][i]]];
                [arry_key addObject:[dic_state allKeys][i]];
            }
            
            [btn_state setTitle:[arry_key objectAtIndex:0] forState:UIControlStateNormal];
            str_state = arry_value[0];
        }
        
        [tbl_state_list reloadData];
    }
}
-(void) resign_keyboard
{
    [txtv_add_message resignFirstResponder];
}
-(void) textview_change_border : (UITextView *) textview
{
    textview.clipsToBounds = YES;
    [textview layer].cornerRadius = 4.0f;
}
- (IBAction)btn_back_action:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSString *) get_my_proper_string : (id) my_str
{
    NSString *string;
    string = [NSString stringWithFormat:@"%@", my_str];
    
    return string;
}
-(void) show_image
{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [_dic_response objectForKey:@"Pla_Image"]]]];
    if (data)
    {
        img_place.image = [UIImage imageWithData:data];
        
        img_profile.image = [UIImage imageWithData:data];
    }
    else
    {
        img_place.image = [UIImage imageNamed:@"imgProfile.jpg"];
        img_profile.image = [UIImage imageNamed:@"imgProfile.jpg"];
    }
}

-(void) set_values
{
    lbl_place_address.text = [NSString stringWithFormat:@"%@",[self get_my_proper_string1:[_dic_response objectForKey:@"Pla_Name"]]];
    lbl_place_description.text = [NSString stringWithFormat:@"%@",[self get_my_proper_string1:[_dic_response objectForKey:@"Pla_Address"]]];
    lbl_place_frate.text = [NSString stringWithFormat:@"%@",[self get_my_proper_string1:[_dic_response objectForKey:@"Rating"]]];
    lbl_place_frate.text = [NSString stringWithFormat:@"%.2f", [lbl_place_frate.text floatValue]];
    
    txt_place_name.text =  [self get_my_proper_string1:[_dic_response objectForKey:@"Pla_Name"]];
    txt_address.text = [self get_my_proper_string1:[_dic_response objectForKey:@"Pla_Address"]];
    txt_zip.text =  [self get_my_proper_string1:[_dic_response objectForKey:@"Pla_Zip"]];
    txt_city.text = [self get_my_proper_string1:[_dic_response objectForKey:@"Pla_City"]];
    //txt_state.text = [self get_my_proper_string1:[_dic_response objectForKey:@"State"]];
}

-(NSString *) get_my_proper_string1 : (NSString *) str_value
{
    if ([str_value isEqual:[NSNull null]] || str_value == nil)
    {
        str_value = @"";
    }
    return str_value;
}

-(NSString *) getCurrentDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"ddMMYYYY_hhmmss";
    NSDate *date = [[NSDate alloc] init];
    NSString *ret = [formatter stringFromDate:date];
    return ret;
}


//New Code
- (IBAction)btn_save_action:(id)sender
{
    if (txt_place_name.text.length == 0 || txt_address.text.length == 0 || txt_zip.text.length == 0 || txt_city.text.length == 0 || btn_state.titleLabel.text.length == 0)
    {
        [[[UIAlertView alloc]initWithTitle:@"Warning!" message:@"Please fill all fields!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
    else
    {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSDictionary *params = @{ @"place_id" :[NSString stringWithFormat:@"%d",_str_place_id],
                               @"que1"    : txt_polling1.text,
                               @"que2"        :txt_polling2.text,
                               @"zipcode"        :txt_zip.text,
                               @"message"        :txtv_add_message.text,
                               @"state"        : str_state,
                               @"city"        :txt_city.text,
                               @"address"        :txt_address.text,
                               @"title"        :txt_place_name.text,
                               };

        
//        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:objAppDelegate.userSessionID, @"Usr_SessionID", [txtName text], @"Usr_FirstName", @"", @"Usr_Password", nil];
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://server.url"]];
        [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        AFHTTPRequestOperation *op = [manager POST:@"http://www.opine.com.br/OpineAPI/api/place/edit"
                                        parameters:params
                         constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                             if (dataImage)
                             {
                                 [formData appendPartWithFileData:dataImage name:@"logo" fileName:[NSString stringWithFormat:@"Photo_%@.png", [self getCurrentDate]] mimeType:@"image/png"];
                             }
                             
                         } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                             NSLog(@"dataUpdateForUser responseObject = %@", [NSString stringWithUTF8String:[responseObject bytes]]);
                             NSDictionary *dictTemp = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                             
                            
                             if([@"1" isEqualToString:[dictTemp valueForKeyPath:@"Success"]])
                             {
                                 [[[UIAlertView alloc]initWithTitle:@"Success" message:[dictTemp valueForKeyPath:@"MessageInfo"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
                             }
                             else
                             {
                                 [[[UIAlertView alloc]initWithTitle:@"Failed" message:[dictTemp valueForKeyPath:@"MessageInfo"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
                             }

                             
                
                             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                             
                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                             NSLog(@"dataUpdateForUser fail : %@",[error localizedDescription]);
                             [[[UIAlertView alloc]initWithTitle:@"Failed" message:[error localizedDescription] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];

                             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                         }];
        [op start];

        
        
//        //[self updating_detail_service];
//        NSDictionary *dic = @{ @"place_id" :[NSString stringWithFormat:@"%d",_str_place_id],
//                               @"que1"    : txt_polling1.text,
//                               @"que2"        :txt_polling2.text,
//                               @"zipcode"        :txt_zip.text,
//                               @"message"        :txtv_add_message.text,
//                               @"state"        : str_state,
//                               @"city"        :txt_city.text,
//                               @"address"        :txt_address.text,
//                               @"title"        :txt_place_name.text,
//                                           };
//        NSString *str_url = @"http://www.opine.com.br/OpineAPI/api/place/edit?";
//        // Post Service
//       dic  = [Utility_Class Request_service_get_response_in_Post:dic :str_url];
//       if([@"1" isEqualToString:[dic valueForKeyPath:@"Success"]])
//       {
//           [[[UIAlertView alloc]initWithTitle:@"Success" message:[dic valueForKeyPath:@"MessageInfo"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
//       }
//       else
//       {
//          [[[UIAlertView alloc]initWithTitle:@"Failed" message:[dic valueForKeyPath:@"MessageInfo"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
//       }
    }
    
}
-(void) updating_detail_service
{
    txt_state.text = @"2";
    NSError *error;
    NSString *str_url = [NSString stringWithFormat:@"http://opine.com.br/OpineAPI/application/controllers/api/editplace.php?place_id=%d&title=%@&address=%@&offer=%@&zipcode=%@&city=%@&state=%@&logo=&message=%@",_str_place_id,txt_place_name.text,txt_address.text,txtv_add_message.text,txt_zip.text,txt_city.text,str_state,txtv_add_message.text];
    NSURL *url = [NSURL URLWithString:[str_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]; //_str_place_id,txtfi_field1.text, txtfi_field2.text
    NSDictionary *Get_Response ;
    if (url!=nil)
    {
        NSData *Get_data = [NSData dataWithContentsOfURL:url options:kNilOptions error:&error];
        if (Get_data!= nil)
        {
            Get_Response = [NSJSONSerialization JSONObjectWithData:Get_data options:0 error:NULL];
        }
    }
}
#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arry_key count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell =(UITableViewCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier];
    }
    cell.backgroundColor = [UIColor colorWithRed:15/255.0f green:187/255.0f blue:193/255.0f alpha:1.0f];
    cell.textLabel.text = [arry_key objectAtIndex:indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    tbl_state_list.hidden = YES;
    isstate_btn_click = NO;
    str_state = arry_value[indexPath.row];
    [btn_state setTitle:[arry_key objectAtIndex:indexPath.row] forState:UIControlStateNormal];
}

#pragma mark - textfield delegate
-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == txt_state)
    {
      
    }
    return YES;
}

- (IBAction)btn_state_action:(UIButton *)sender
{
    objAppDelegate.isSorting = YES;
    objAppDelegate.isstate_click = YES;
    
    if(dropDown == nil)
    {
        CGFloat f = [arry_key count]*40;
        dropDown = [[NIDropDown alloc] showDropDown:sender :&f :arry_key :nil :@"down"];
        dropDown.delegate = self;
    }
    else
    {
        [dropDown hideDropDown:sender];
        [self rel];
    }
    
    [scro_view  addSubview:dropDown];
    
    /*if (isstate_btn_click)
    {
        tbl_state_list.hidden = YES;
       isstate_btn_click = NO;
    }
    else
    {
        tbl_state_list.hidden = NO;
        isstate_btn_click = YES;
    }        
    
    [tbl_state_list reloadData];*/
    
}
- (void) niDropDownDelegateMethod: (NIDropDown *) sender isNoneSelect:(BOOL)isNone
{
    [self rel];
    if (isNone)
    {
        [btn_state setTitle:sender.nameTitle forState:UIControlStateNormal];
    }
    objAppDelegate.isstate_click = NO;
}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender :(NSString *)getSelectedName
{
    [self rel];
}

-(void)rel
{
    dropDown = nil;
}

-(BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if (textView == txtv_add_message)
    {
        CGPoint scrollPoint = CGPointMake(0.0,txtv_add_message.frame.origin.y+300);
        [scro_view setContentOffset:scrollPoint animated:YES];
    }
    
    return YES;
}

-(BOOL) textViewShouldEndEditing:(UITextView *)textView
{
    if (textView == txtv_add_message)
    {
        CGPoint scrollPoint = CGPointMake(0.0,txtv_add_message.frame.origin.y-300);
        [scro_view setContentOffset:scrollPoint animated:YES];
    }
    
    return YES;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btn_photo_action:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary])
    {
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        controller.allowsEditing = NO;
        controller.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        controller.delegate = self;
        if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
        {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                [self presentViewController:controller animated:NO completion:nil];
            }];
            
        }
        else{
            
            [controller presentViewController:controller animated:NO completion:nil];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Warning!" message:@"This Device Does not have Camera" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    dataImage = UIImagePNGRepresentation(originalImage);
    img_profile.image = originalImage;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
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
