//
//  SettingViewController.m
//  Opine
//
//  Created by MoonRose Infotech on 17/11/14.
//  Copyright (c) 2014 MoonRose Infotech All rights reserved.
//

#import "SettingViewController.h"
#import "ECSlidingViewController.h"

@interface SettingViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation SettingViewController

@synthesize tblView, marrSetting;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.slidingViewController setAnchorRightRevealAmount:280.0f];
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;
    self.tblView.separatorStyle = UITableViewCellSelectionStyleNone;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [tblView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [marrSetting count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.row % 2 == 0) {
        [cell.textLabel setBackgroundColor:[UIColor colorWithRed:140/255.0f green:221/255.0f blue:223/255.0f alpha:1]];
        [cell.contentView setBackgroundColor:[UIColor colorWithRed:140/255.0f green:221/255.0f blue:223/255.0f alpha:1]];
    } else {
        [cell.contentView setBackgroundColor:[UIColor colorWithRed:60/255.0f green:193/255.0f blue:200/255.0f alpha:1]];
        [cell.textLabel setBackgroundColor:[UIColor colorWithRed:60/255.0f green:193/255.0f blue:200/255.0f alpha:1]];
        [cell.textLabel setTextColor:[UIColor whiteColor]];
    }
    cell.textLabel.text = [marrSetting objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - Tableview Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate openViewBySetting:indexPath.row];
}

@end