//
//  InitialSlidingViewController.m
//  Opine
//
//  Created by MoonRose Infotech on 17/11/14.
//  Copyright (c) 2014 MoonRose Infotech All rights reserved.
//

#import "InitialSlidingViewController.h"

@interface InitialSlidingViewController ()
@end


@implementation InitialSlidingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
}

@end
