//
//  AppDelegate.h
//  Opine
//
//  Created by MoonRose Infotech on 06/11/14.
//  Copyright (c) 2014 MoonRose Infotech All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic) NSString *UserName;
@property (nonatomic) BOOL isLogin, isSorting, ispaid_user, isstate_click;
@property (nonatomic) NSMutableArray *marrPlace;
@property (nonatomic) NSMutableArray *marrPlaceDetail;
@property (nonatomic) NSMutableArray *marrCategory;
@property (nonatomic) NSString *userSessionID;
@property (nonatomic) NSMutableDictionary *mdictFBUserInfo;
@property (nonatomic) NSMutableArray *marrUserData;

@property (nonatomic, retain) NSString *str_user_id;

-(void)openActiveSessionWithPermissions:(NSArray *)permissions allowLoginUI:(BOOL)allowLoginUI;

@end

