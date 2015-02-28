//
//  DetailViewController.h
//  Opine
//
//  Created by MoonRose Infotech on 06/11/14.
//  Copyright (c) 2014 MoonRose Infotech All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RateView.h"
#import "AppDelegate.h"
#import "PlaceDetailModel.h"
#import "RateCommentModel.h"

@protocol DetailViewControllerDelegate <NSObject>

-(void) setLoginEnable;

@end

@interface DetailViewController : UIViewController
{
    AppDelegate *objAppDelegate;
    PlaceDetailModel *objPlaceDetail;
    RateCommentModel *objRateCommentModel;
    NSMutableArray *marrCommentData;
    NSMutableDictionary *dictComments;
    
    IBOutlet UIView *reply_view;
    IBOutlet UIButton *btn_edit_place;
    
}

@property (nonatomic) BOOL isfrom_myplace;
@property (weak, nonatomic) IBOutlet UIButton *btnShareItOrNot;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tblHeightCon;
@property (weak, nonatomic) IBOutlet UITableView *tblRateLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnCommentSubmit;
@property (weak, nonatomic) IBOutlet UILabel *lblRepeat;
@property (weak, nonatomic) IBOutlet UILabel *lblRatingHeader;
@property (weak, nonatomic) IBOutlet UITextView *lblPlaceAddress;
@property (weak, nonatomic) IBOutlet UITextView *lblPlaceName;
@property (nonatomic) NSInteger placeID;
@property (weak, nonatomic) IBOutlet UIButton *btnClaim;
@property (weak, nonatomic) IBOutlet UILabel *lblPageNumber;
@property (weak, nonatomic) IBOutlet UIPageControl *pagingComment;
@property (nonatomic, weak) id <DetailViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *txtCommentTitle;
@property (weak, nonatomic) IBOutlet UITextView *txtCommentTextView;
@property (weak, nonatomic) IBOutlet UIView *vwComment;
@property (weak, nonatomic) IBOutlet UIButton *btnNo;
@property (weak, nonatomic) IBOutlet UIButton *btnYes;
@property (weak, nonatomic) IBOutlet UITableView *tblComment;
@property (weak, nonatomic) IBOutlet UIImageView *imgPlacePhoto;
@property (weak, nonatomic) IBOutlet UIScrollView *svMain;
@property (weak, nonatomic) IBOutlet UIView *vwHeader;
@property (weak, nonatomic) IBOutlet UIButton *btnRate;
@property (weak, nonatomic) IBOutlet UIView *vwReadMore;
@property (weak, nonatomic) IBOutlet UILabel *lblCommentTitle;
@property (weak, nonatomic) IBOutlet UITextView *lblCommentText;

@end
