//
//  SignupViewController.h
//  Opine
//
//  Created by MoonRose Infotech on 07/11/14.
//  Copyright (c) 2014 MoonRose Infotech All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>

@protocol SignupViewControllerDelegate <NSObject>

- (void)setUserName:(NSString *)username;

@end

@interface SignupViewController : UIViewController
{
    AppDelegate *objAppDelegate;
}

@property (weak, nonatomic) IBOutlet UIButton *btnFBLogin;
@property (nonatomic, weak) id <SignupViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIScrollView *svMainView;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtPasswordSignUp;
@property (weak, nonatomic) IBOutlet UITextField *txtUserNameSignUp;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPassword;
@property (weak, nonatomic) IBOutlet UIView *vwLogin;

-(void)handleFBSessionStateChangeWithNotification:(NSNotification *)notification;

@end
