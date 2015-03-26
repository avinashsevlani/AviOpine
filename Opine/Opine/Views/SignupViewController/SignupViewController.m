//
//  SignupViewController.m
//  Opine
//
//  Created by MoonRose Infotech on 07/11/14.
//  Copyright (c) 2014 MoonRose Infotech All rights reserved.
//

#import "SignupViewController.h"
#import "OpineModel.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"
#import "UserModel.h"

@interface SignupViewController () <UITextFieldDelegate, UIAlertViewDelegate, FBLoginViewDelegate>

@end

@implementation SignupViewController

@synthesize svMainView;
@synthesize vwLogin;
@synthesize btnSubmit, btnFBLogin;
@synthesize txtConfirmPassword, txtFirstName, txtPassword, txtPasswordSignUp, txtUserName, txtUserNameSignUp;
@synthesize delegate;

#pragma mark - ViewLifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    objAppDelegate = [[UIApplication sharedApplication] delegate];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleFBSessionStateChangeWithNotification:)
                                                 name:@"SessionStateChangeNotification"
                                               object:nil];
}

- (void)viewDidLayoutSubviews
{
    [svMainView setContentSize:CGSizeMake(svMainView.frame.size.width, svMainView.frame.size.height + 210)];
}

#pragma mark - UITextFieldDelegate Mehtod
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIAlertViewDelegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if (![OpineModel validateEmail:[[alertView textFieldAtIndex:0] text]]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erro" message:@"Seu email não é válido, favor checar." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        [self sendEmailForFogotPassword:[[alertView textFieldAtIndex:0] text]];
    }
}

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error
{
    NSString *alertMessage, *alertTitle;
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook Erro";
        alertMessage = [FBErrorUtility userMessageForError:error];
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Erro";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected Erro:%@", error);
    }
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle message:alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

#pragma mark - IBAction Method
- (IBAction)btnBackTapped:(id)sender
{
    if (vwLogin.hidden) {
        vwLogin.hidden = NO;
        btnSubmit.hidden = YES;
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)btnSubmitTapped:(id)sender
{
    if ([txtUserNameSignUp.text isEqual:@""] || [txtPasswordSignUp.text isEqual:@""] || [txtConfirmPassword.text isEqual:@""] || [txtFirstName.text isEqual:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erro" message:@"Favor completar todos os dados para completar o cadastro." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if (![OpineModel validateEmail:txtUserNameSignUp.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erro" message:@"Seu email não é válido, favor checar." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [txtUserNameSignUp setText:@""];
        return;
    }
    [self saveSignUpData];
}

- (IBAction)btnSignUpHereTapped:(id)sender
{
    vwLogin.hidden = YES;
    btnSubmit.hidden = NO;
}

- (IBAction)btnFBLoginTapped:(id)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [txtConfirmPassword resignFirstResponder];
    [txtConfirmPassword resignFirstResponder];
    [txtFirstName resignFirstResponder];
    [txtPassword resignFirstResponder];
    [txtPasswordSignUp resignFirstResponder];
    [txtUserName resignFirstResponder];
    [txtUserNameSignUp resignFirstResponder];
    [[FBSession activeSession] closeAndClearTokenInformation];
    if ([FBSession activeSession].state != FBSessionStateOpen &&
        [FBSession activeSession].state != FBSessionStateOpenTokenExtended) {
        [objAppDelegate openActiveSessionWithPermissions:@[@"public_profile", @"email"] allowLoginUI:YES];
    }
    else{
        [[FBSession activeSession] closeAndClearTokenInformation];
    }
}

- (IBAction)btnLoginTapped:(id)sender
{
    if ([txtUserName.text isEqual:@""] || [txtPassword.text isEqual:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erro" message:@"Por favor, introduza-mail e senha" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if (![OpineModel validateEmail:txtUserName.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erro" message:@"Seu email não é válido, favor checar." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [txtUserName setText:@""];
        return;
    }
    [self checkNormalLogin];
}

- (IBAction) checkConfirmPassword:(id)sender
{
    if (![txtPasswordSignUp.text isEqualToString:[txtConfirmPassword text]]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erro" message:@"Senha e Confirmação de Sneha devem ser iguais." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [txtConfirmPassword setText:@""];
    }
}

- (IBAction)checkEmailAddress:(id)sender
{
//    UITextField *txt = sender;
//    if (![OpineModel validateEmail:txt.text]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your email is not Valid, Please check." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
//        [alert show];
//        [txt setText:@""];
//    }
}

- (IBAction)btnForgoPasswordTapped:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email" message:@"Enviaremos senha ao email cadastrado" delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:@"OK", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

#pragma mark - Other Method
-(void)handleFBSessionStateChangeWithNotification:(NSNotification *)notification
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    objAppDelegate.mdictFBUserInfo = [[NSMutableDictionary alloc] init];
    objAppDelegate.mdictFBUserInfo = (NSMutableDictionary *)[notification userInfo];
    FBSessionState sessionState = [[objAppDelegate.mdictFBUserInfo objectForKey:@"state"] integerValue];
    NSError *error = [objAppDelegate.mdictFBUserInfo objectForKey:@"error"];
    if (!error) {
       if (sessionState == FBSessionStateOpen) {
           [FBRequestConnection startWithGraphPath:@"me"
                                         parameters:@{@"fields": @"first_name, last_name, picture.type(normal), email"}
                                         HTTPMethod:@"GET"
                                  completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                      if (!error) {
                                          NSURL *pictureURL = [NSURL URLWithString:[[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]];
                                          objAppDelegate.mdictFBUserInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[result objectForKey:@"first_name"], @"FBUserFirstName", [result objectForKey:@"id"], @"FBUserID", pictureURL, @"FBUserPicture", nil];
                                          NSLog(@"data : %@", objAppDelegate.mdictFBUserInfo);
                                          [self checkFBloginOrSignUp];
                                      }
                                      else{
                                          NSLog(@"%@", [error localizedDescription]);
                                      }
                                  }];
       }
    }
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

#pragma mark - API Call
-(void) checkFBloginOrSignUp
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[objAppDelegate.mdictFBUserInfo valueForKey:@"FBUserID"] , @"Usr_UserName", @"", @"Usr_Password", [objAppDelegate.mdictFBUserInfo valueForKey:@"FBUserFirstName"], @"Usr_FirstName", [objAppDelegate.mdictFBUserInfo valueForKey:@"FBUserPicture"], @"Usr_Photo", @"Facebook", @"Usr_LoginType", nil];
    [manager POST:[NSString stringWithFormat:@"http://www.opine.com.br/OpineAPI/api/user/register"]
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"checkFBloginOrSignUp responseObject = %@", [NSString stringWithUTF8String:[responseObject bytes]]);
              NSDictionary *dictTemp = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
              objAppDelegate.marrUserData = [[NSMutableArray alloc] init];
              UserModel *objUser = [[UserModel alloc] init];
              objUser.userSessionID = [dictTemp valueForKey:@"Usr_SessionID"];
              objUser.userFirstName = [dictTemp valueForKey:@"FirstName"];
              objUser.userPhoto = [dictTemp valueForKey:@"Photo"];
              [objAppDelegate.marrUserData addObject:objUser];
              objAppDelegate.userSessionID = [dictTemp valueForKey:@"Usr_SessionID"];
              objAppDelegate.isLogin = YES;
              objAppDelegate.UserName = [txtUserName text];
              [self.delegate setUserName:[txtUserName text]];
              [self dismissViewControllerAnimated:YES completion:nil];
              [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if (error) {
                  NSLog(@"checkFBloginOrSignUp Erro = %@", error);
                  [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
              }
          }];
}

-(void) checkNormalLogin
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:txtUserName.text, @"Usr_UserName", txtPassword.text, @"Usr_Password", nil];
    [manager POST:[NSString stringWithFormat:@"http://www.opine.com.br/OpineAPI/api/user/login"]
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"checkNormalLogin responseObject = %@", [NSString stringWithUTF8String:[responseObject bytes]]);
              NSDictionary *dictTemp = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
              NSString *data = [dictTemp valueForKey:@"Message"];
              if ([data isEqual:@"Error"]) {
                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erro" message:@"ome de usuário e/ou senha inválida. Não encontramos este usuário." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                  [alert show];
                  [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                  return;
              }
              else if ([dictTemp valueForKey:@"MessageInfo"])
              {
                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[dictTemp valueForKey:@"MessageInfo"]delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                  [alert show];
              }
              objAppDelegate.marrUserData = [[NSMutableArray alloc] init];
              UserModel *objUser = [[UserModel alloc] init];
              objUser.userSessionID = [dictTemp valueForKey:@"Usr_SessionID"];
              objUser.userFirstName = [dictTemp valueForKey:@"FirstName"];
              objUser.userPhoto = [dictTemp valueForKey:@"Photo"];
              [objAppDelegate.marrUserData addObject:objUser];
              objAppDelegate.userSessionID = [dictTemp valueForKey:@"Usr_SessionID"];
              objAppDelegate.isLogin = YES;
              if ([[dictTemp valueForKey:@"Usr_PaymentStatus"] isEqualToString:@"Paid"])
              {
                  objAppDelegate.ispaid_user = YES;
              }
              else
              {
                  objAppDelegate.ispaid_user = NO;
              }
              
              objAppDelegate.UserName = [txtUserName text];
              objAppDelegate.mdictFBUserInfo = nil;
              [self.delegate setUserName:[txtUserName text]];
              [self dismissViewControllerAnimated:YES completion:nil];
              [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if (error) {
                  NSLog(@"checkNormalLogin Erro = %@", error);
              }
              [MBProgressHUD hideHUDForView:self.view animated:YES];
          }];
}

-(void) saveSignUpData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[txtUserNameSignUp text], @"Usr_UserName", [txtPasswordSignUp text], @"Usr_Password", [txtFirstName text], @"Usr_FirstName", @"", @"Usr_Photo", @"Normal", @"Usr_LoginType", nil];
    [manager POST:[NSString stringWithFormat:@"http://www.opine.com.br/OpineAPI/api/user/register"]
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"saveSignUpData responseObject = %@", [NSString stringWithUTF8String:[responseObject bytes]]);
              NSDictionary *dictTemp = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
              if ([[dictTemp valueForKey:@"Message"] isEqualToString:@"Success"]) {
                  vwLogin.hidden = NO;
                  btnSubmit.hidden = YES;
                  if ([dictTemp valueForKey:@"MessageInfo"])
                  {
                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[dictTemp valueForKey:@"MessageInfo"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                      [alert show];

                  }
                } else {
                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erro" message:@"Please choose another Email. This email already Register." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                  [alert show];
              }
              [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if (error) {
                  NSLog(@"saveSignUpData Erro = %@", error);
                  [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
              }
          }];
}

-(void) sendEmailForFogotPassword:(NSString *)emailAddress
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:emailAddress, @"Usr_UserName", nil];
    [manager POST:[NSString stringWithFormat:@"http://www.opine.com.br/OpineAPI/api/user/forgot_password"]
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"sendEmailForFogotPassword responseObject = %@", [NSString stringWithUTF8String:[responseObject bytes]]);
              NSDictionary *dictTemp = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
              if ([[dictTemp valueForKey:@"Message"] isEqualToString:@"Success"]) {
                  
                  if ([dictTemp valueForKey:@"MessageInfo"])
                  {
                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Obrigado" message:[dictTemp valueForKey:@"MessageInfo"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                      [alert show];
                  }
                  else
                  {
                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Obrigado" message:@"Verifique se o seu e-mail de senha." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                      [alert show];;
                      
                  }

                  
                 
              } else {
                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erro" message:@"Por favor, tente novamente com o endereço cadastrado." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                  [alert show];
              }
              [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if (error) {
                  NSLog(@"sendEmailForFogotPassword error = %@", error);
                  [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
              }
          }];
}

@end
