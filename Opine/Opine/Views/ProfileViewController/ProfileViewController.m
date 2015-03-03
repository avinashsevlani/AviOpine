//
//  ProfileViewController.m
//  Opine
//
//  Created by MoonRose Infotech on 18/11/14.
//  Copyright (c) 2014 MoonRose Infotech All rights reserved.
//

#import "ProfileViewController.h"
#import "UserModel.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "OpineModel.h"

@interface ProfileViewController () <UITextFieldDelegate, UIActionSheetDelegate>

@end

@implementation ProfileViewController

@synthesize svScrollProfile;
@synthesize txtConfirmPassword, txtName, txtNewPassword, txtOldPassword;
@synthesize ivProfile;
@synthesize btnChangePassword, btnChangePhoto;

NSData *dataImage;

#pragma mark - ViewLifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    objAppDelegate = [[UIApplication sharedApplication] delegate];
    picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0.1];
}

- (void)viewDidLayoutSubviews
{
    [svScrollProfile setContentSize:CGSizeMake(svScrollProfile.frame.size.width, svScrollProfile.frame.size.height + 250)];
}

#pragma mark - UITextFieldDelegate Method
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIActionSheetDelegate Method
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    } else if (buttonIndex == 1) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            picker.sourceType=UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:nil];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Your device not Supported Camera, Please choose photo from Gallery" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate Method
-(void)imagePickerController:(UIImagePickerController *)picker1 didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    dataImage = UIImagePNGRepresentation(image);
    [ivProfile setImage:image];
    [picker1 dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - IBAction Method
- (IBAction)btnBackTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnSubmitTapped:(id)sender
{
    if (![txtNewPassword.text isEqualToString:[txtConfirmPassword text]]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Password & Confirm Password must be Same." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
        [txtConfirmPassword setText:@""];
        [txtConfirmPassword resignFirstResponder];
        [txtNewPassword resignFirstResponder];
        return;
    }
    [self dataUpdateForUser];
}

- (IBAction)btnChangePasswordTapped:(id)sender
{
    [svScrollProfile setScrollEnabled:YES];
    txtOldPassword.hidden = NO;
    txtNewPassword.hidden = NO;
    txtConfirmPassword.hidden = NO;
}

- (IBAction)ConfirmPasswordTapped:(id)sender
{
    if (![txtNewPassword.text isEqualToString:[txtConfirmPassword text]]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Password & Confirm Password must be Same." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
        [txtConfirmPassword setText:@""];
        [txtConfirmPassword resignFirstResponder];
        [txtNewPassword resignFirstResponder];
    }
}

- (IBAction)btnChangePhotoTapped:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Gallery", @"Camera", nil];
    [actionSheet showInView:self.view];
}

#pragma mark - Other Method
-(void) loadData
{
    if (![OpineModel checkIsEmpty:[[objAppDelegate.marrUserData objectAtIndex:0] valueForKey:@"_userPhoto"]]) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[objAppDelegate.marrUserData objectAtIndex:0] valueForKey:@"_userPhoto"]]];
        [ivProfile setImage:[UIImage imageWithData:data]];
    }
    if (objAppDelegate.mdictFBUserInfo == nil) {
        btnChangePassword.hidden = NO;
    } else {
        btnChangePassword.hidden = YES;
    }
    [txtName setText:[[objAppDelegate.marrUserData objectAtIndex:0] valueForKey:@"_userFirstName"]];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark - API Call
-(void)imageTest:(NSDictionary *)params image:(NSData *)imageData
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://server.url"]];
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    AFHTTPRequestOperation *op = [manager POST:@"http://www.opine.com.br/OpineAPI/api/user/profile"
                                    parameters:params
                     constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                         [formData appendPartWithFileData:imageData name:@"Usr_Photo" fileName:@"photo.png" mimeType:@"image/png"];
                     } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         NSLog(@"imageTest sucesssss : %@",operation.responseString);
                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         NSLog(@"imageTest fail : %@",[error localizedDescription]);
                     }];
    [op start];
}

-(void) dataUpdateForUser
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:objAppDelegate.userSessionID, @"Usr_SessionID", [txtName text], @"Usr_FirstName", @"", @"Usr_Password", nil];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://server.url"]];
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFHTTPRequestOperation *op = [manager POST:@"http://www.opine.com.br/OpineAPI/api/user/profile"
                                    parameters:params
                     constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                         if (dataImage)
                         {
                              [formData appendPartWithFileData:dataImage name:@"Usr_Photo" fileName:[NSString stringWithFormat:@"Photo_%@.png", [self getCurrentDate]] mimeType:@"image/png"];
                         }
                        
                     } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         NSLog(@"dataUpdateForUser responseObject = %@", [NSString stringWithUTF8String:[responseObject bytes]]);
                         NSDictionary *dictTemp = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                         NSString *data = [dictTemp valueForKey:@"Message"];
                         if ([data isEqual:@"Error"]) {
                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Username & Password is Invalid. There are no such user with it." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
                             [alert show];
                             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                             return;
                         }
                         objAppDelegate.marrUserData = [[NSMutableArray alloc] init];
                         UserModel *objUser = [[UserModel alloc] init];
                         objUser.userSessionID = objAppDelegate.userSessionID;
                         objUser.userFirstName = [dictTemp valueForKey:@"FirstName"];
                         objUser.userPhoto = [dictTemp valueForKey:@"Photo"];
                         [objAppDelegate.marrUserData addObject:objUser];
                         [self dismissViewControllerAnimated:YES completion:nil];
                         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         NSLog(@"dataUpdateForUser fail : %@",[error localizedDescription]);
                         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                     }];
    [op start];
}

-(NSString *) getCurrentDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"ddMMYYYY_hhmmss";
    NSDate *date = [[NSDate alloc] init];
    NSString *ret = [formatter stringFromDate:date];
    return ret;
}

@end