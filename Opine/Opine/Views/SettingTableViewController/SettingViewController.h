//
//  SettingViewController.h
//  Opine
//
//  Created by MoonRose Infotech on 17/11/14.
//  Copyright (c) 2014 MoonRose Infotech All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingTableViewControllerDelegate

-(void)openViewBySetting:(NSInteger)settingID;

@end

@interface SettingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (nonatomic, weak) id <SettingTableViewControllerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *marrSetting;

@end
