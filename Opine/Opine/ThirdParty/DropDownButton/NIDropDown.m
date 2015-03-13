//
//  NIDropDown.m
//  NIDropDown
//
//  Created by Bijesh N on 12/28/12.
//  Copyright (c) 2012 Nitor Infotech. All rights reserved.
//

#import "NIDropDown.h"
#import "QuartzCore/QuartzCore.h"
#import "AppDelegate.h"
#import "CategoryModel.h"

@interface NIDropDown ()
@property(nonatomic, strong) UITableView *table;
@property(nonatomic, strong) UIButton *btnSender;
@property(nonatomic, retain) NSArray *list;
@property(nonatomic, retain) NSArray *imageList;
@end

@implementation NIDropDown
@synthesize table;
@synthesize btnSender;
@synthesize list;
@synthesize imageList;
@synthesize delegate;
@synthesize animationDirection;
@synthesize nameTitle;

- (id)showDropDown:(UIButton *) b : (CGFloat *)height : (NSArray *)arr : (NSArray *)imgArr : (NSString *)direction {
    btnSender = b;
    animationDirection = direction;
    self.table = (UITableView *)[super init];
    
    AppDelegate *appdel = [UIApplication sharedApplication].delegate ;
    
    if (self) {
        // Initialization code
        CGRect btn = b.frame;
        self.list = [NSArray arrayWithArray:arr];
        self.imageList = [NSArray arrayWithArray:imgArr];
        if ([direction isEqualToString:@"up"]) {
            if (appdel.isstate_click)
            {
               self.frame = CGRectMake(btn.origin.x, btn.origin.y+120, btn.size.width, 0);
            }
            else
            {
               self.frame = CGRectMake(btn.origin.x, btn.origin.y, btn.size.width, *height);
            }
            self.layer.shadowOffset = CGSizeMake(-5, -5);
        }else if ([direction isEqualToString:@"down"]) {
            if (appdel.isstate_click)
            {
             self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height+120, btn.size.width, 0);
            }
            else
            {
                self.frame = CGRectMake(btn.origin.x, btn.origin.y, btn.size.width, *height);
            }
            self.layer.shadowOffset = CGSizeMake(-5, 5);
        }
        
        self.layer.masksToBounds = NO;
        self.layer.cornerRadius = 8;
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.5;
        
        table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, btn.size.width, 0)];
        table.delegate = self;
        table.dataSource = self;
        table.layer.cornerRadius = 5;
        table.backgroundColor = [UIColor colorWithRed:11 green:11 blue:11 alpha:1];
        table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        table.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
        table.separatorColor = [UIColor grayColor];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        if ([direction isEqualToString:@"up"]) {
            if (appdel.isstate_click)
            {
                self.frame = CGRectMake(btn.origin.x, btn.origin.y-*height+120, btn.size.width, *height);
            }
            else
                self.frame = CGRectMake(btn.origin.x, btn.origin.y-*height, btn.size.width, *height);
            
        }
        else if([direction isEqualToString:@"down"])
        {
            if (appdel.isstate_click)
            {
                self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height+120, btn.size.width, *height);
            }
            else
            {
                self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, *height);
            }
        }
        
        table.frame = CGRectMake(0, 0, btn.size.width, *height);
        [UIView commitAnimations];
        [b.superview addSubview:self];
        [self addSubview:table];
    }
    return self;
}

-(void)hideDropDown:(UIButton *)b {
    CGRect btn = b.frame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    if ([animationDirection isEqualToString:@"up"]) {
        self.frame = CGRectMake(btn.origin.x, btn.origin.y, btn.size.width, 0);
    }else if ([animationDirection isEqualToString:@"down"]) {
        self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, 0);
    }
    table.frame = CGRectMake(0, 0, btn.size.width, 0);
    [UIView commitAnimations];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.list count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    AppDelegate *objAppDelegate = [[UIApplication sharedApplication] delegate];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
//        cell.textLabel.textAlignment = UITextAlignmentCenter;
    }
    if ([self.imageList count] == [self.list count]) {
        cell.textLabel.text =[list objectAtIndex:indexPath.row];
        cell.imageView.image = [imageList objectAtIndex:indexPath.row];
    } else if ([self.imageList count] > [self.list count]) {
        cell.textLabel.text =[list objectAtIndex:indexPath.row];
        if (indexPath.row < [imageList count]) {
            cell.imageView.image = [imageList objectAtIndex:indexPath.row];
        }
    } else if ([self.imageList count] < [self.list count]) {
        if (objAppDelegate.isSorting) {
            cell.textLabel.text = [list objectAtIndex:indexPath.row];
        } else {
            cell.textLabel.text = [[list objectAtIndex:indexPath.row] valueForKey:@"_categoryTitle"];
        }
        if (indexPath.row < [imageList count]) {
            cell.imageView.image = [imageList objectAtIndex:indexPath.row];
        }
    }
    if (!objAppDelegate.isSorting) {
        cell.tag = [[[list objectAtIndex:indexPath.row] valueForKey:@"_categoryID"] integerValue];
    }
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"imgBGSearchArea.png"]];
    [iv setFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height)];
    
    cell.textLabel.textColor = [UIColor blackColor];
    cell.backgroundView = iv;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hideDropDown:btnSender];
    
    AppDelegate *objAppDelegate = [[UIApplication sharedApplication] delegate];
    UITableViewCell *c = [tableView cellForRowAtIndexPath:indexPath];
    [btnSender setTitle:c.textLabel.text forState:UIControlStateNormal];
    nameTitle = c.textLabel.text;
    if (!objAppDelegate.isSorting) {
        self.tag = c.tag;
    }
//    for (UIView *subview in btnSender.subviews) {
//        if ([subview isKindOfClass:[UIImageView class]]) {
//            [subview removeFromSuperview];
//        }
//    }
//    imgView.image = c.imageView.image;
//    imgView = [[UIImageView alloc] initWithImage:c.imageView.image];
//    imgView.frame = CGRectMake(5, 5, 25, 25);
//    [btnSender addSubview:imgView];
    if ([c.textLabel.text isEqual:@"All"] || [c.textLabel.text isEqual:@"Nenhum"]) {
        [self myDelegate:YES];
    } else {        
        [self myDelegate:NO];
    }
}

- (void) myDelegate: (BOOL)isDone {
    [self.delegate niDropDownDelegateMethod:self isNoneSelect:isDone];
}

-(void)dealloc {
//    [super dealloc];
//    [table release];
//    [self release];
}

@end
