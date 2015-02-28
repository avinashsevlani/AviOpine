//
//  ClaimMyPlaceViewController.h
//  Opine
//
//  Created by EverestIndia on 20/01/15.
//  Copyright (c) 2015 TheAppGururz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "PlaceDetailModel.h"
#import "RateCommentModel.h"

@protocol ClaimMyPlaceViewControllerDelegate <NSObject>

-(void) setLoginEnable;

@end

@interface ClaimMyPlaceViewController : UIViewController<UITextFieldDelegate>
{
    AppDelegate *objAppDelegate;
    NSMutableArray *marrCommentData;
    RateCommentModel *objRateCommentModel;
    PlaceDetailModel *objPlaceDetail;
    NSMutableDictionary *dictComments;
    
    NSMutableArray *array_comment_reply;
}
@property (nonatomic, weak) id <ClaimMyPlaceViewControllerDelegate> delegate;

@property (nonatomic) NSInteger placeID;
@end
