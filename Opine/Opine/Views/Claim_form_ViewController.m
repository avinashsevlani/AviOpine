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
#import <StoreKit/StoreKit.h>
#import "AFNetworking.h"
#import "MBProgressHUD.h"


#define productID @"com.opineYearSubscription.yearly"

@interface Claim_form_ViewController ()<SKProductsRequestDelegate,SKPaymentTransactionObserver>
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
    
    SKProductsRequest* productsRequest;
    NSArray* validProducts;
    NSString* uniqueID;
    
    IBOutlet UIScrollView *scro_view_details;

}

@end

@implementation Claim_form_ViewController
@synthesize user_login_detail;

///////////////// In app purchase implementation

-(void)fetchAvailableProducts{
    
    NSSet *productIdentifiers = [NSSet
                                 setWithObjects:productID,nil];
    productsRequest = [[SKProductsRequest alloc]
                       initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
}

- (BOOL)canMakePurchases
{
    return [SKPaymentQueue canMakePayments];
}

- (void)purchaseMyProduct:(SKProduct*)product{
    if ([self canMakePurchases]) {
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        //[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                  @"Purchases are disabled in your device" message:nil delegate:
                                  self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
    }
}


#pragma mark StoreKit Delegate


-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        UIAlertView * alertView;
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"Purchasing");
                break;
            case SKPaymentTransactionStatePurchased:
                if ([transaction.payment.productIdentifier
                     isEqualToString:productID]) {
                    NSLog(@"Purchased ");
                    [self registerPlace];
                   // [self addPurchaseBookToServer];
                    
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                               break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"Restored ");
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
//                HUD.hidden = YES;
//                HUD=nil;
                break;
            case SKPaymentTransactionStateFailed:
                NSLog(@"Purchase failed ");
                if (transaction.error.code != SKErrorPaymentCancelled)
                {
                    NSLog(@"Transaction Erro: %@", transaction.error.localizedDescription);
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
//                _dtlBuyNowBtn.enabled = YES;
//                HUD.hidden = YES;
//                HUD=nil;
                alertView = [[UIAlertView alloc]initWithTitle:
                             transaction.error.localizedDescription message:nil delegate:
                             self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alertView show];
                break;
            default:
                break;
        }
    }
    
}

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    SKProduct *validProduct = nil;
    NSUInteger count = [response.products count];
    if (count>0) {
        validProducts = response.products;
        validProduct = [response.products objectAtIndex:0];
        if ([validProduct.productIdentifier
             isEqualToString:productID]) {
            //            [_dtlBookName setText:[NSString stringWithFormat:
            //                                   @"%@",validProduct.localizedTitle]];
            //            [_dtlAuthor setText:[NSString stringWithFormat:
            //                                 @"%@",validProduct.localizedDescription]];
            //            [_dtlPrice setText:[NSString stringWithFormat:
            //                                @"%@",validProduct.price]];
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                      [NSString stringWithFormat:@"Do you want to purchase '%@' by '%@' for price %@",validProduct.localizedTitle,validProduct.localizedDescription,validProduct.price] message:nil delegate:
                                      self cancelButtonTitle:@"Cancelar" otherButtonTitles: @"Buy Now",nil];
            alertView.tag = 2222;
            [alertView show];
            
        }
    } else {
        UIAlertView *tmp = [[UIAlertView alloc]
                            initWithTitle:@"Not Available"
                            message:@"No products to purchase"
                            delegate:self
                            cancelButtonTitle:nil
                            otherButtonTitles:@"Ok", nil];
        [tmp show];
    }
//    [HUD setHidden:YES];
//    HUD = nil;
    
}

//
//- (IBAction)buyProduct:(id)sender {
//    SKPayment *payment = [SKPayment paymentWithProduct:_product];
//    [[SKPaymentQueue defaultQueue] addPayment:payment];
//}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"failed with error %@",error);
    
    UIAlertView *tmp = [[UIAlertView alloc]
                        initWithTitle:@"Message"
                        message:error.description
                        delegate:self
                        cancelButtonTitle:nil
                        otherButtonTitles:@"Ok", nil];
    [tmp show];
    
//    [HUD setHidden:YES];
//    HUD = nil;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    Obj_Appdelegate = [UIApplication sharedApplication].delegate;
    
    [self loadUserInfo];
    
    
    //DOTO: Set unique number
  //  txt_unique_no.text = [Utility_Class get_unique_Number];
   
}



- (void)initializeData
{
    uniqueID = [NSString stringWithFormat:@"%@_%.0f",_str_place_id,[[NSDate date] timeIntervalSince1970]];
    txt_unique_no.text = uniqueID;
    lbl_cliam_tittle.text = _str_place_name;
    
    if (user_login_detail.length>0)
    {
        [self hide_labels:YES];
        [self change_lbl_txt_frame_size];
    }
}

- (void)loadUserInfo
{
  //  http://www.opine.com.br/OpineAPI/api/user/info?Usr_SessionID={UserSessionID}
    
    AppDelegate *objAppDelegate = [[UIApplication sharedApplication] delegate];
    if (!objAppDelegate.userSessionID.length)
    {
        [self initializeData];
        return;
        
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //http://www.opine.com.br/OpineAPI/api/user/info?Usr_SessionID={UserSessionID}
    
    
  //  NSDictionary *dic_value;
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:objAppDelegate.userSessionID, @"Usr_SessionID", nil];
    
    
    [manager POST:[NSString stringWithFormat:@"http://www.opine.com.br/OpineAPI/api/user/info"]
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"getCatagory responseObject = %@", [NSString stringWithUTF8String:[responseObject bytes]]);
              NSDictionary *dictTemp = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
              
              if ([dictTemp valueForKey:@"Info"])
              {
                  NSDictionary* userInfo = [dictTemp valueForKey:@"Info"];
                /*
                   "Usr_Cnpj" = 35678;
                   "Usr_Id" = 1;
                   "Usr_No" = 5786899;
                   */
                  
                  if ([userInfo valueForKey:@"Usr_Cnpj"])
                  {
                      txt_cnpj_no.text = [userInfo valueForKey:@"Usr_Cnpj"];
                  }
                  if ([userInfo valueForKey:@"Usr_No"])
                  {
                      txt_mobi_no.text = [userInfo valueForKey:@"Usr_No"];
                  }

                  
                  
              }
              [self initializeData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if (error) {
                  NSLog(@"getCatagory error = %@", error);
              }
              [self initializeData];
              [MBProgressHUD hideHUDForView:self.view animated:YES];
          }];
 
    
    
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
    if (alertView.tag == 2222)
    {
        if (buttonIndex == 1)
        {
            [self purchaseMyProduct:[validProducts firstObject]];
        }
    }
    else if (alertView.tag == 3333)
    {
        if (buttonIndex == 0)
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    else
    {
        if ([alertView.title isEqualToString:@"Success"])
        {
            //[self dismissViewControllerAnimated:YES completion:nil];
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
            AppDelegate *objAppDelegate = [[UIApplication sharedApplication] delegate];
            NSDictionary *dic_value;
            
            if (user_login_detail.length>0)
            {
                dic_value = @{@"unique_no" : uniqueID,
                              @"phone" : txt_mobi_no.text,
                              @"cnpj": txt_cnpj_no.text,
                              @"user_id" : Obj_Appdelegate.userSessionID,
                              @"place_id" : _str_place_id};
            }
            else
            {
                dic_value = @{@"unique_no" : uniqueID,
                              @"phone" : txt_mobi_no.text,
                              @"cnpj": txt_cnpj_no.text,
                              @"user_id" : Obj_Appdelegate.userSessionID,
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
        if (txt_name.text.length == 0 || txt_password.text.length == 0 || txt_conf_password.text.length == 0 || uniqueID.length == 0 || txt_mobi_no.text.length == 0 || txt_cnpj_no.text.length == 0 || txt_user_mail.text.length == 0)
        {
            [[[UIAlertView alloc]initWithTitle:@"Failed" message:@"Please fill all above fields" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        }
        else
        {
            NSDictionary *dic_value;
            
            if (user_login_detail.length>0)
            {
                dic_value = @{@"unique_no" : uniqueID,
                              @"phone" : txt_mobi_no.text,
                              @"cnpj": txt_cnpj_no.text,
                              @"user_id" : Obj_Appdelegate.userSessionID,
                              @"place_id" : _str_place_id};
                
            }
            else
            {
                dic_value = @{@"unique_no" : uniqueID,
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
     AppDelegate *objAppDelegate = [[UIApplication sharedApplication] delegate];
    if (objAppDelegate.ispaid_user)
    {
        [self registerPlace];
    }
    else
    {
        //[self registerPlace];
        [self fetchAvailableProducts];
    }
  //  [[[UIAlertView alloc]initWithTitle:@"Warning!" message:@"In_App_puchased_Not_Successed" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
   
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


- (void)registerPlace
{
   // opine.com.br/OpineAPI/api/claim/paid?status=success&unique_key={unique_key which is generated in form}
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
     NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: @"success", @"status", uniqueID, @"unique_key", nil];
    
    [manager POST:[NSString stringWithFormat:@"http://opine.com.br/OpineAPI/api/claim/paid"]
      parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"getCatagory responseObject = %@", [NSString stringWithUTF8String:[responseObject bytes]]);
             NSDictionary *dictTemp = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
             
             if ([dictTemp valueForKey:@"MessageInfo"])
             {
               UIAlertView* alertView =  [[UIAlertView alloc]initWithTitle:@"Success" message:[dictTemp valueForKeyPath:@"MessageInfo"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 alertView.tag = 3333;
                 [alertView show];
                                          
                                          
             }
             if ([[dictTemp valueForKey:@"Message"] isEqualToString:@"Success"]
                 )
             {
                 
             }
             [MBProgressHUD hideHUDForView:self.view animated:YES];
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (error) {
                 NSLog(@"getCatagory error = %@", error);
             }
             [MBProgressHUD hideHUDForView:self.view animated:YES];
         }];

    
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
