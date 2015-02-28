//
//  ProfileViewController.h
//  Opine
//
//  Created by MoonRose Infotech on 18/11/14.
//  Copyright (c) 2014 MoonRose Infotech All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ProfileViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIImagePickerController *picker;
    AppDelegate *objAppDelegate;
}

@property (weak, nonatomic) IBOutlet UIButton *btnChangePhoto;
@property (weak, nonatomic) IBOutlet UIButton *btnChangePassword;
@property (weak, nonatomic) IBOutlet UIImageView *ivProfile;
@property (weak, nonatomic) IBOutlet UIScrollView *svScrollProfile;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtOldPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtNewPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPassword;

@end
