//
//  Claim_form_ViewController.m
//  Opine
//
//  Created by apple on 30/12/14.
//  Copyright (c) 2014 TheAppGururz. All rights reserved.
//

#import "Claim_form_ViewController.h"
#import "Utility_Class.h"
#import "PlaceDetailModel.h"
#import "AppDelegate.h"

@interface Claim_form_ViewController ()
{
    
    IBOutlet UILabel *lbl_cliam_tittle;
    
    IBOutlet UITextField *txt_user_mail;
    IBOutlet UITextField *txt_password;
    IBOutlet UITextField *txt_conf_password;
    IBOutlet UITextField *txt_name;
    IBOutlet UITextField *txt_cnpj_no;
    IBOutlet UITextField *txt_mobi_no;
    IBOutlet UITextField *txt_unique_no;
    
    PlaceDetailModel *obj_place_detail;
    
    //Allocating Label
    IBOutlet UILabel *lbl_label;
    IBOutlet UILabel *lbl_passowrd;
    IBOutlet UILabel *lbl_conf_password;
    IBOutlet UILabel *lbl_name;
    IBOutlet UILabel *lbl_cnpj;
    IBOutlet UILabel *lbl_mobile_no;
    IBOutlet UILabel *lbl_unique_no;
    
    AppDelegate *Obj_Appdelegate;
    
    
    IBOutlet UIScrollView *scro_view_details;

}

@end

@implementation Claim_form_ViewController
@synthesize user_login_detail;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    Obj_Appdelegate = [UIApplication sharedApplication].delegate;
    
    //DOTO: Set unique number
    txt_unique_no.text = [Utility_Class get_unique_Number];
    lbl_cliam_tittle.text = _str_place_name;
    
    if (user_login_detail.length>0)
    {
        [self hide_labels:YES];
        [self change_lbl_txt_frame_size];
    }
}

#pragma hide views
-(void) hide_labels : (BOOL) value;
{
    txt_user_mail.hidden = value;
    txt_password.hidden = value;
    txt_conf_password.hidden = value;
    txt_name.hidden = value;
    
    
    lbl_label.hidden = value;
    lbl_passowrd.hidden = value;
    lbl_conf_password.hidden = value;
    lbl_name.hidden = value;
}

-(void) change_lbl_txt_frame_size
{
    txt_cnpj_no.frame = [self set_txt_fame_size:txt_cnpj_no];
    txt_mobi_no.frame =[self set_txt_fame_size:txt_mobi_no];
    txt_unique_no.frame = [self set_txt_fame_size:txt_unique_no];
    
    lbl_cnpj.frame = [self set_lbl_fame_size:lbl_cnpj];
    lbl_mobile_no.frame =[self set_lbl_fame_size:lbl_mobile_no];
    lbl_unique_no.frame = [self set_lbl_fame_size:lbl_unique_no];
}

-(CGRect) set_txt_fame_size : (UITextField *) textfield
{
    CGRect frame = CGRectMake(textfield.frame.origin.x, textfield.frame.origin.y-200, textfield.frame.size.width, textfield.frame.size.height);
    return frame;
}

-(CGRect) set_lbl_fame_size : (UILabel *) textfield
{
    CGRect frame = CGRectMake(textfield.frame.origin.x, textfield.frame.origin.y-200, textfield.frame.size.width, textfield.frame.size.height);
    return frame;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btn_cancel_action:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - alertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqualToString:@"Success"])
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if ([alertView.message isEqualToString:@"In_App_puchased_Not_Successed"])
    {
        NSDictionary * dic_value = @{@"status" : @"success",
                                     @"unique_key" : txt_mobi_no.text,
                                     };
        NSDictionary *dic =  [Utility_Class  Request_service_get_response_in_Post:dic_value :@"http://opine.com.br/OpineAPI/api/claim/paid?"];
        if ([[dic valueForKeyPath:@"Success"] isEqualToString:@"1"])
        {
            [[[UIAlertView alloc]initWithTitle:@"Success" message:[dic valueForKeyPath:@"MessageInfo"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        }
        else
        {
            [[[UIAlertView alloc]initWithTitle:@"Failed" message:[dic valueForKeyPath:@"MessageInfo"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        }
    }
    else
    {
        if (buttonIndex ==0 )
        {
            
        }
        else
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }

    }
    
}

#pragma mark - textfield delegate

-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    if (user_login_detail.length>0)
    {
        
    }
    else
    {
        if (textField == txt_cnpj_no)
        {
            [scro_view_details setContentOffset:CGPointMake(0,80) animated:YES];
        }
        else if (textField == txt_mobi_no)
        {
            [scro_view_details setContentOffset:CGPointMake(0,135) animated:YES];
        }
        else if (textField == txt_name)
        {
            [scro_view_details setContentOffset:CGPointMake(0,60) animated:YES];
        }
    }
    return YES;
}
- (IBAction)btn_continue_action:(id)sender
{
    if (user_login_detail.length>0)
    {
        if (txt_unique_no.text.length == 0 || txt_mobi_no.text.length == 0 || txt_cnpj_no.text.length == 0)
        {
            [[[UIAlertView alloc]initWithTitle:@"Failed" message:@"Please fill all above fields" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        }
        else
        {
            NSDictionary *dic_value;
            
            if (user_login_detail.length>0)
            {
                dic_value = @{@"unique_no" : txt_unique_no.text,
                              @"phone" : txt_mobi_no.text,
                              @"cnpj": txt_cnpj_no.text,
                              @"user_id" : Obj_Appdelegate.userSessionID,
                              @"place_id" : _str_place_id};
            }
            else
            {
                dic_value = @{@"unique_no" : txt_unique_no.text,
                              @"phone" : txt_mobi_no.text,
                              @"cnpj": txt_cnpj_no.text,
                              @"user_id" : txt_user_mail.text,
                              @"place_id" : _str_place_id,
                              @"email" : txt_user_mail.text,
                              @"password" : txt_password.text,
                              @"confirm_password" : txt_conf_password.text,
                              @"name" : txt_name.text
                              };
            }
            
            NSDictionary *dic =  [Utility_Class  Request_service_get_response_in_Post:dic_value :@"http://opine.com.br/OpineAPI/api/claim/add?"]; //[self webservice_to_save_claim];
            NSString *str =[NSString stringWithFormat:@"%@", [dic valueForKeyPath:@"Success"]];
            if ([str isEqualToString:@"1"])
            {
                [[[UIAlertView alloc]initWithTitle:@"Success" message:[dic valueForKeyPath:@"MessageInfo"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
                
                [self performSelectorInBackground:@selector(Inapp_purchase_service) withObject:nil];
            }
            else
            {
                [[[UIAlertView alloc]initWithTitle:@"Failed" message:[dic valueForKeyPath:@"MessageInfo"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
            }
        }
    }
    else
    {
        if (txt_name.text.length == 0 || txt_password.text.length == 0 || txt_conf_password.text.length == 0 || txt_unique_no.text.length == 0 || txt_mobi_no.text.length == 0 || txt_cnpj_no.text.length == 0 || txt_user_mail.text.length == 0)
        {
            [[[UIAlertView alloc]initWithTitle:@"Failed" message:@"Please fill all above fields" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        }
        else
        {
            NSDictionary *dic_value;
            
            if (user_login_detail.length>0)
            {
                dic_value = @{@"unique_no" : txt_unique_no.text,
                              @"phone" : txt_mobi_no.text,
                              @"cnpj": txt_cnpj_no.text,
                              @"user_id" : Obj_Appdelegate.userSessionID,
                              @"place_id" : _str_place_id};
                
            }
            else
            {
                dic_value = @{@"unique_no" : txt_unique_no.text,
                              @"phone" : txt_mobi_no.text,
                              @"cnpj": txt_cnpj_no.text,
                              @"user_id" : txt_user_mail.text,
                              @"place_id" : _str_place_id,
                              @"email" : txt_user_mail.text,
                              @"password" : txt_password.text,
                              @"confirm_password" : txt_conf_password.text,
                              @"name" : txt_name.text
                              };
            }
            
            
            NSDictionary *dic =  [Utility_Class  Request_service_get_response_in_Post:dic_value :@"http://opine.com.br/OpineAPI/api/claim/add?"]; //[self webservice_to_save_claim];
            NSString *str =[NSString stringWithFormat:@"%@", [dic valueForKeyPath:@"Success"]];
            if ([str isEqualToString:@"1"])
            {
                [[[UIAlertView alloc]initWithTitle:@"Success" message:[dic valueForKeyPath:@"MessageInfo"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
                
                [self performSelectorInBackground:@selector(Inapp_purchase_service) withObject:nil];
            }
            else
            {
                [[[UIAlertView alloc]initWithTitle:@"Failed" message:[dic valueForKeyPath:@"MessageInfo"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
            }
        }
    }
}
-(void) Inapp_purchase_service
{
   // http://opine.com.br/OpineAPI/api/claim/paid?status={success or failed}&unique_key={unique number which shows in unique while storing claim data.}
    
    [[[UIAlertView alloc]initWithTitle:@"Warning!" message:@"In_App_puchased_Not_Successed" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
   
}

-(NSDictionary *) webservice_to_save_claim
{
    NSLog(@"%@", Obj_Appdelegate.userSessionID);
    NSError *error;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://opine.com.br/OpineAPI/application/controllers/api/placesave.php?user_id=%@&place_id=%d", Obj_Appdelegate.userSessionID, [_str_place_id intValue]]];
    NSDictionary *Get_Response ;
    if (url!=nil)
    {
        NSData *Get_data = [NSData dataWithContentsOfURL:url options:kNilOptions error:&error];
        if (Get_data!= nil)
        {
            Get_Response = [NSJSONSerialization JSONObjectWithData:Get_data
                                                           options:0
                                                             error:NULL];
        }
    }
    return Get_Response;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [scro_view_details setContentOffset:CGPointMake(0,0) animated:YES];

    return YES;
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
