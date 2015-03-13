//
//  DetailViewController.m
//  Opine
//
//  Created by MoonRose Infotech on 06/11/14.
//  Copyright (c) 2014 MoonRose Infotech All rights reserved.
//

#import "DetailViewController.h"
#import "DYRateView.h"
#import "SignupViewController.h"
#import "PlaceViewController.h"
#import "CommentTableViewCell.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"
#import "PlaceDetailModel.h"
#import "UIImageView+WebCache.h"
#import "RateLabelTableViewCell.h"
#import "Claim_form_ViewController.h"

@interface DetailViewController () <DYRateViewDelegate, RateViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, SignupViewControllerDelegate>
{
    NSUInteger _numPages;
    NSUInteger _pageCount;
}

@end

@implementation DetailViewController

@synthesize imgPlacePhoto;
@synthesize svMain;
@synthesize vwHeader, vwReadMore, vwComment;
@synthesize lblPageNumber, lblPlaceAddress, lblPlaceName, lblRatingHeader, lblRepeat, lblCommentText, lblCommentTitle;
@synthesize btnRate, btnNo, btnYes, btnClaim, btnCommentSubmit, btnShareItOrNot;
@synthesize tblComment, tblRateLabel;
@synthesize txtCommentTextView, txtCommentTitle;
@synthesize delegate;
@synthesize pagingComment;
@synthesize placeID, tblHeightCon;

bool isRepeatYes = NO, isRepeatNo = NO, isRate = NO, isRatingStart = NO, isReloadTable = NO, isShareIt = NO;
NSMutableArray *marrRatingStore;

#pragma mark - ViewLifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    marrRatingStore = [[NSMutableArray alloc] init];
    [tblComment setSeparatorColor:[UIColor clearColor]];
    [tblRateLabel setSeparatorColor:[UIColor clearColor]];
    [self loadData];
}

- (void)viewDidLayoutSubviews
{
    [svMain setContentSize:CGSizeMake(svMain.frame.size.width, svMain.frame.size.height + 770)];
}

#pragma mark - UITextFieldDelegate Method
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
    }
    return YES;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 5001)
    {
        return [objPlaceDetail.placeCommentRatingArray count]-1;
    } else {
        NSLog(@"%d, %d", [[dictComments valueForKey:[NSString stringWithFormat:@"%d", tableView.tag]] count], tableView.tag);
        return [[dictComments valueForKey:[NSString stringWithFormat:@"%d", tableView.tag]] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 5001) {
        if (isRatingStart) {
            isReloadTable = YES;
            RateLabelTableViewCell *cellRateLabel = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
            DYRateView *rv = [[DYRateView alloc] initWithFrame:CGRectMake(84, 15, 260, 30)];
            rv.rate = 0;
            rv.delegate = self;
            rv.alignment = RateViewAlignmentLeft;
            rv.editable = YES;
            [cellRateLabel addSubview:rv];
            cellRateLabel.lblRateLabelName.text = [[objPlaceDetail.placeCommentRatingArray objectAtIndex:indexPath.row] valueForKey:@"Name"];
            cellRateLabel.lblRateLabelRating.text = @"0.0";
            cellRateLabel.tag = [[[objPlaceDetail.placeCommentRatingArray objectAtIndex:indexPath.row] valueForKey:@"Id"] integerValue];
            rv.tag = [[[objPlaceDetail.placeCommentRatingArray objectAtIndex:indexPath.row] valueForKey:@"Id"] integerValue];
            return cellRateLabel;
        } else {
            isReloadTable = NO;
            RateLabelTableViewCell *cellRateLabel = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
            DYRateView *rv2 = [[DYRateView alloc] initWithFrame:CGRectMake(84, 15, 260, 30)];
            if (objPlaceDetail.placeCommentRatingArray.count == 0) {
                rv2.rate = 0;
            } else {
                rv2.rate = [[[objPlaceDetail.placeCommentRatingArray objectAtIndex:indexPath.row] valueForKey:@"Rate"] doubleValue];
            }
            rv2.alignment = RateViewAlignmentLeft;
            rv2.delegate = nil;
            [cellRateLabel addSubview:rv2];
            cellRateLabel.lblRateLabelName.text = [[objPlaceDetail.placeCommentRatingArray objectAtIndex:indexPath.row] valueForKey:@"Name"];
            cellRateLabel.lblRateLabelRating.text = [[objPlaceDetail.placeCommentRatingArray objectAtIndex:indexPath.row] valueForKey:@"Rate"];
            cellRateLabel.tag = [[[objPlaceDetail.placeCommentRatingArray objectAtIndex:indexPath.row] valueForKey:@"Id"] integerValue];
            return cellRateLabel;
        }
    }
    else
    {
        CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.layer.shouldRasterize = YES;
        cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
        if (![[[[dictComments valueForKey:[NSString stringWithFormat:@"%d", tableView.tag]] objectAtIndex:indexPath.row] valueForKey:@"Com_Name_Image"]  isEqual: @""]) {
            NSURL *url = [NSURL URLWithString:[[[[dictComments valueForKey:[NSString stringWithFormat:@"%d", tableView.tag]] objectAtIndex:indexPath.row] valueForKey:@"Com_Name_Image"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
            [cell.imgCommenter setImageWithURL:url placeholderImage:[UIImage imageNamed:@"imagenotfound.png"]];
        }
        DYRateView *rateView = [[DYRateView alloc] initWithFrame:CGRectMake(8, 38, 200, 30)];
        rateView.rate = [[[[dictComments valueForKey:[NSString stringWithFormat:@"%d", tableView.tag]] objectAtIndex:indexPath.row] valueForKey:@"Rate"] doubleValue];
        rateView.alignment = RateViewAlignmentLeft;
        [cell addSubview:rateView];
        cell.lblCommenterName.text = [[[dictComments valueForKey:[NSString stringWithFormat:@"%d", tableView.tag]] objectAtIndex:indexPath.row] valueForKey:@"Com_Name"];
        cell.lblCommentTitle.text = [[[dictComments valueForKey:[NSString stringWithFormat:@"%d", tableView.tag]] objectAtIndex:indexPath.row] valueForKey:@"Com_Title"];
        cell.lblCommentDate.text = [[[dictComments valueForKey:[NSString stringWithFormat:@"%d", tableView.tag]] objectAtIndex:indexPath.row] valueForKey:@"Com_Date"];
        cell.lblComment.text = [[[dictComments valueForKey:[NSString stringWithFormat:@"%d", tableView.tag]] objectAtIndex:indexPath.row] valueForKey:@"Com_Comment"];
        NSLog(@"%@", cell.lblComment.text);
        if (cell.lblComment.text.length > 35) {
            cell.btnCommentReadMore.hidden = NO;
            cell.userInteractionEnabled = YES;
            [cell.lblComment setHidden:YES];
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(8, 89, 200, 17)];
            [lbl setFont:[UIFont fontWithName:@"Arial" size:13]];
            [lbl setText:cell.lblComment.text];
            [cell addSubview:lbl];
        }
        else
        {
            cell.btnCommentReadMore.hidden = YES;
            cell.userInteractionEnabled = NO;
        }
        if (_isfrom_myplace)
        {
            UIButton *btn_rate = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btn_rate.frame = CGRectMake(100, 05, 110, 25);
            [btn_rate setBackgroundImage:[UIImage imageNamed:@"imgButtonBack.png"] forState:UIControlStateNormal];
            [btn_rate setTitle:@"Responder" forState:UIControlStateNormal];
            [btn_rate.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:10.0]];
            [btn_rate addTarget:self action:@selector(replay_action) forControlEvents:UIControlEventTouchUpInside];
            [btn_rate setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [cell addSubview:btn_rate];
        }
        return cell;
    }
}
-(void) replay_action
{
    reply_view.hidden = NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 5001) {
        
    } else {
        vwReadMore.hidden = NO;
        CommentTableViewCell *cell = (CommentTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        [lblCommentTitle setText:cell.lblCommentTitle.text];
        [lblCommentText setText:cell.lblComment.text];
        svMain.scrollEnabled = NO;
    }
}

#pragma mark - DYRateViewDelegate
- (void)rateView:(DYRateView *)rateView changedToNewRate:(NSNumber *)rate
{
    if(isRatingStart) {
        RateLabelTableViewCell *cellRateLabel = (RateLabelTableViewCell *)[tblRateLabel viewWithTag:rateView.tag];
        cellRateLabel.lblRateLabelRating.text = [NSString stringWithFormat:@"%@", rate];
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"Nota%d:%@", rateView.tag, rate], @"rate", nil];
        [marrRatingStore addObject:dict];
    }
}

- (IBAction)btnCloseCommentTapped:(id)sender
{
    svMain.scrollEnabled = YES;
    vwReadMore.hidden = YES;
}

- (IBAction)btn_edit_place_action:(id)sender
{
    
}


#pragma mark - SignUpViewControllerDelegate Method
- (void)setUserName:(NSString *)username
{
    if (objAppDelegate.isLogin) {
        [btnRate setImage:[UIImage imageNamed:@"imgButtonRate.png"] forState:UIControlStateNormal];
        btnRate.hidden = YES;
//        btnClaim.hidden = YES;
        vwComment.hidden = NO;
    } else {
        [btnRate setImage:[UIImage imageNamed:@"imgRateComment.png"] forState:UIControlStateNormal];
        vwComment.hidden = YES;
//        btnClaim.hidden = NO;
        btnRate.hidden = NO;
    }
    [btnRate setImage:[UIImage imageNamed:@"imgRateNow.png"] forState:UIControlStateNormal];
    isRate = YES;
    isRatingStart = YES;
    [self deleteAllCell];
    [lblRepeat setText:@"0%"];
    btnRate.hidden = YES;
//    btnClaim.hidden = YES;
    vwComment.hidden = NO;
    [self ratingUserInterfaceEnable:YES];
//    [self.tblComment reloadData];
}

#pragma mark - IBAction Method
- (IBAction)btnBackTapped:(id)sender
{
    [self.delegate setLoginEnable];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnClaimTapped:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Confirme os dados" message:@"Essa propriedade é sua?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alertView show];
}
#pragma mark - alertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==0)
    {
        
    }
    else
    {
        NSLog(@"%@", objPlaceDetail.placeID);
        
        Claim_form_ViewController *controller = [[Claim_form_ViewController alloc] initWithNibName:@"Claim_form_ViewController" bundle:nil];
        if (objAppDelegate.isLogin)
        {
            controller.user_login_detail = @"Login";
        }
        
        controller.str_place_id = objPlaceDetail.placeID;
        controller.str_place_name = lblPlaceName.text;
        [self presentViewController:controller animated:YES completion:nil];
    }
}

- (IBAction)btnShareItOrNotTapped:(id)sender
{
    if (isShareIt) {
        isShareIt = NO;
        [btnShareItOrNot setImage:[UIImage imageNamed:@"imgUnChecked.png"] forState:UIControlStateNormal];
    } else {
        isShareIt = YES;
        [btnShareItOrNot setImage:[UIImage imageNamed:@"imgChecked.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)btnSubmitNowTapped:(id)sender
{
    isRatingStart = NO;
    objRateCommentModel.commentUserSessionID = objAppDelegate.userSessionID;
    objRateCommentModel.commentTitle = [txtCommentTitle text];
    objRateCommentModel.commentText = [txtCommentTextView text];
    objRateCommentModel.commentPlaceID = [NSString stringWithFormat:@"%d", placeID];
    for (int i=marrRatingStore.count-1; i>=0; i--) {
        for (int j=i-1; j>=0; j--) {
            NSString *f = [[marrRatingStore objectAtIndex:i] valueForKey:@"rate"];
            NSString *first = [f substringToIndex:5];
            NSString *s = [[marrRatingStore objectAtIndex:j] valueForKey:@"rate"];
            NSString *sec = [s substringToIndex:5];
            if ([first isEqual:sec]) {
                [marrRatingStore removeObjectAtIndex:j];
                break;
            }
        }
    }
    [self storeRateAndComment];
    [btnRate setImage:[UIImage imageNamed:@"imgRateComment.png"] forState:UIControlStateNormal];
    vwComment.hidden = YES;
    btnRate.hidden = NO;
//    btnClaim.hidden = NO;
    isRate = NO;
    [self getPlaceDetailByPlaceID:placeID];
    [btnYes setBackgroundImage:[UIImage imageNamed:@"imgYesDisable.png"] forState:UIControlStateNormal];
    [btnNo setBackgroundImage:[UIImage imageNamed:@"imgNoDisable.png"] forState:UIControlStateNormal];
    if (isShareIt) {
        [self shareData];
    }
}

- (IBAction)btnRateTapped:(id)sender
{
    if (!objAppDelegate.isLogin) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SignupViewController *objSignupViewController = [storyBoard instantiateViewControllerWithIdentifier:@"SignupViewController"];
        objSignupViewController.delegate = self;
        [self presentViewController:objSignupViewController animated:YES completion:nil];
        return;
    }
    if (!isRate) {
        [btnRate setImage:[UIImage imageNamed:@"imgRateNow.png"] forState:UIControlStateNormal];
        isRate = YES;
        isRatingStart = YES;
        [self deleteAllCell];
        [lblRepeat setText:@"0%"];
        btnRate.hidden = YES;
//        btnClaim.hidden = YES;
        vwComment.hidden = NO;
        [self ratingUserInterfaceEnable:YES];
    } else {
        [btnRate setImage:[UIImage imageNamed:@"imgButtonRate.png"] forState:UIControlStateNormal];
        isRate = NO;
        isRatingStart = NO;
        [self deleteAllCell];
        [lblRepeat setText:[NSString stringWithFormat:@"%@%%", [[objPlaceDetail.placeCommentRatingArray objectAtIndex:objPlaceDetail.placeCommentRatingArray.count-1] valueForKey:@"Repeat"]]];
        [btnYes setBackgroundImage:[UIImage imageNamed:@"imgYesDisable.png"] forState:UIControlStateNormal];
        [btnNo setBackgroundImage:[UIImage imageNamed:@"imgNoDisable.png"] forState:UIControlStateNormal];
        vwComment.hidden = YES;
        btnRate.hidden = NO;
//        btnClaim.hidden = NO;
        [self ratingUserInterfaceEnable:NO];
    }
}

- (IBAction)btnYesTapped:(id)sender
{
    if (isRepeatNo) {
        [btnNo setBackgroundImage:[UIImage imageNamed:@"imgNoDisable.png"] forState:UIControlStateNormal];
    }
    [btnYes setBackgroundImage:[UIImage imageNamed:@"imgYesEnable.png"] forState:UIControlStateNormal];
    isRepeatYes = YES;
    objRateCommentModel.commentRepeat = @"1";
}

- (IBAction)btnNoTapped:(id)sender
{
    if (isRepeatYes) {
        [btnYes setBackgroundImage:[UIImage imageNamed:@"imgYesDisable.png"] forState:UIControlStateNormal];
    }
    [btnNo setBackgroundImage:[UIImage imageNamed:@"imgNoEnable.png"] forState:UIControlStateNormal];
    isRepeatNo = YES;
    objRateCommentModel.commentRepeat = @"0";
}

- (IBAction)btnResignKeyBoard:(id)sender
{
    [txtCommentTitle resignFirstResponder];
    [txtCommentTextView resignFirstResponder];
}

- (IBAction)btnIncrementPageTapped:(id)sender
{
    if (_pageCount == _numPages) {
        return;
    }
    _pageCount++;
    [self.tblComment setTag:_pageCount];
    [self.tblComment reloadData];
    [lblPageNumber setText:[NSString stringWithFormat:@"Página : %lu", (unsigned long)_pageCount]];
    pagingComment.currentPage = _pageCount-1;
}

- (IBAction)btnDecrementPage:(id)sender
{
    if (_pageCount == 1) {
        return;
    }
    _pageCount--;
    [self.tblComment setTag:_pageCount];
    [self.tblComment reloadData];
    [lblPageNumber setText:[NSString stringWithFormat:@"Página : %lu", (unsigned long)_pageCount]];
    pagingComment.currentPage = _pageCount-1;
}

- (IBAction)btnShareTapped:(id)sender
{
    [self shareData];
}

-(void) shareData
{
    UIImage *imagetoshare;
    if (![objPlaceDetail.placeImage isEqual: @""]) {
        NSURL *url = [[NSURL alloc] initWithString:objPlaceDetail.placeImage];
        NSData *imgData = [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:nil];
        imagetoshare = [UIImage imageWithData:imgData];
    }
    NSString *placeName = objPlaceDetail.placeName;
    NSString *strAddress = [NSString stringWithFormat:@"%@, %@, %@, %@", objPlaceDetail.placeAddress, objPlaceDetail.placeCity, objPlaceDetail.placeZip, objPlaceDetail.placeState];
    NSString *placeAddress = strAddress;
    NSString *placeRating = [NSString stringWithFormat:@"Total Rating : %@", objPlaceDetail.placeRating];
    NSString *textToShare;
    if (!isShareIt) {
        textToShare = @"Look at this awesome place for visit & give rating !";
    } else {
        textToShare = @"Hey Friends, I am here at Awseome place...";
    }
    NSURL *myWebsite = [NSURL URLWithString:@"http://www.opine.com.br"];
    NSArray *objectsToShare = @[textToShare, placeName, placeAddress, placeRating, myWebsite, imagetoshare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo];
    activityVC.excludedActivityTypes = excludeActivities;
    [self presentViewController:activityVC animated:YES completion:nil];
}

#pragma mark - Other Mehthod
- (void)loadData
{
    objRateCommentModel = [[RateCommentModel alloc] init];
    objAppDelegate = [[UIApplication sharedApplication] delegate];
    marrCommentData = [[NSMutableArray alloc] init];
    [self getPlaceDetailByPlaceID:placeID];
}

-(void) fillData
{
    if (objPlaceDetail == nil) {
        return;
    }
    [lblPlaceName setText:objPlaceDetail.placeName];
    NSString *strAddress = [NSString stringWithFormat:@"%@, %@, %@, %@", objPlaceDetail.placeAddress, objPlaceDetail.placeCity, objPlaceDetail.placeZip, objPlaceDetail.placeState];
    [lblPlaceAddress setText:strAddress];
    if (![objPlaceDetail.placeImage isEqual: @""]) {
        NSURL *url = [[NSURL alloc] initWithString:objPlaceDetail.placeImage];
        NSData *imgData = [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:nil];
        imgPlacePhoto.image = [UIImage imageWithData:imgData];
    }
    [self loadStarControlInHeader];
    [self ratingUserInterfaceEnable:NO];
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Com_Id"
                                                 ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray = [objPlaceDetail.placeCommentArray sortedArrayUsingDescriptors:sortDescriptors];
    objPlaceDetail.placeCommentArray = nil;
    objPlaceDetail.placeCommentArray = [[NSMutableArray alloc] initWithArray:sortedArray];
    int num = 4, count = 1;
    _pageCount = 1;
    while (num < objPlaceDetail.placeCommentArray.count) {
        num += 4;
        count++;
    }
    _numPages = count;
    int k = 4, pagenumber = 1;
    dictComments = [[NSMutableDictionary alloc] init];
    NSMutableArray *marr = [[NSMutableArray alloc] init];
    for (int i=0; i<objPlaceDetail.placeCommentArray.count; i++) {
        k--;
        [marr addObject:[objPlaceDetail.placeCommentArray objectAtIndex:i]];
        if (k == 0) {
            [dictComments setValue:marr forKey:[NSString stringWithFormat:@"%d", pagenumber]];
            k = 4;
            pagenumber++;
            marr = nil;
            marr = [[NSMutableArray alloc] init];
        }
    }
    [dictComments setValue:marr forKey:[NSString stringWithFormat:@"%d", pagenumber]];
    self.pagingComment.currentPage = _pageCount-1;
    self.pagingComment.numberOfPages = _numPages;
    if (objAppDelegate.isLogin) {
        [btnRate setImage:[UIImage imageNamed:@"imgButtonRate.png"] forState:UIControlStateNormal];
//        btnClaim.hidden = NO;
    } else {
        [btnRate setImage:[UIImage imageNamed:@"imgRateComment.png"] forState:UIControlStateNormal];
//        btnClaim.hidden = YES;
    }
    if (_numPages > 1) {
        pagingComment.hidden = NO;
    } else {
        pagingComment.hidden = YES;
    }
    [lblRepeat setText:[NSString stringWithFormat:@"%@%%", [[objPlaceDetail.placeCommentRatingArray objectAtIndex:objPlaceDetail.placeCommentRatingArray.count-1] valueForKey:@"Repeat"]]];
    [self.tblComment setTag:1];
    [self.tblComment reloadData];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

-(void) ratingUserInterfaceEnable:(BOOL)isEnable
{
    btnNo.userInteractionEnabled = isEnable;
    btnYes.userInteractionEnabled = isEnable;
}

- (void)loadStarControlInHeader
{
    lblRatingHeader.text = [NSString stringWithFormat:@"Nota : %0.1f", [objPlaceDetail.placeRating doubleValue]];
}

- (void)loadEditableRateControl: (RateView *) rateView tagForControl:(int)tag rate:(float)rate
{
    rateView.notSelectedImage = [UIImage imageNamed:@"kermit_empty.png"];
    rateView.halfSelectedImage = [UIImage imageNamed:@"kermit_half.png"];
    rateView.fullSelectedImage = [UIImage imageNamed:@"kermit_full.png"];
    rateView.rating = rate;
    rateView.editable = YES;
    rateView.maxRating = 10;
    rateView.delegate = self;
    rateView.tag = tag;
}

#pragma mark - API Call
-(void) getPlaceDetailByPlaceID:(NSInteger)IplaceID
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d", IplaceID], @"Pla_Id", nil];
    [manager POST:[NSString stringWithFormat:@"http://www.opine.com.br/OpineAPI/api/place/get"]
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"getPlaceDetailByPlaceID responseObject = %@", [NSString stringWithUTF8String:[responseObject bytes]]);
              NSDictionary *dictTemp = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
              NSArray *arrPlaceData = [dictTemp valueForKey:@"Place"];
              objAppDelegate.marrPlaceDetail = [[NSMutableArray alloc] init];
              for (int i=0; i<[arrPlaceData count]; i++) {
                  objPlaceDetail = [[PlaceDetailModel alloc] init];
                  objPlaceDetail.placeID = [[arrPlaceData objectAtIndex:i] valueForKey:@"Pla_Id"];
                  objPlaceDetail.placeName = [[arrPlaceData objectAtIndex:i] valueForKey:@"Pla_Name"];
                  objPlaceDetail.placePhone = [[arrPlaceData objectAtIndex:i] valueForKey:@"Pla_Phone"];
                  objPlaceDetail.placeImage = [[arrPlaceData objectAtIndex:i] valueForKey:@"Pla_Image"];
                  objPlaceDetail.placeAddress = [[arrPlaceData objectAtIndex:i] valueForKey:@"Pla_Address"];
                  objPlaceDetail.placeZip = [[arrPlaceData objectAtIndex:i] valueForKey:@"Pla_Zip"];
                  objPlaceDetail.placeCity = [[arrPlaceData objectAtIndex:i] valueForKey:@"Pla_City"];
                  objPlaceDetail.placeState = [[arrPlaceData objectAtIndex:i] valueForKey:@"Pla_State"];
                  objPlaceDetail.placeQue1 = [[arrPlaceData objectAtIndex:i] valueForKey:@"Pla_Que1"];
                  objPlaceDetail.placeQue2 = [[arrPlaceData objectAtIndex:i] valueForKey:@"Pla_Que2"];
                  objPlaceDetail.placeLogo = [[arrPlaceData objectAtIndex:i] valueForKey:@"Pla_Logo"];
                  objPlaceDetail.placeMessage = [[arrPlaceData objectAtIndex:i] valueForKey:@"Pla_Message"];
                  objPlaceDetail.placeRating = [[arrPlaceData objectAtIndex:i] valueForKey:@"Rating"];
                  objPlaceDetail.placeCommentRatingArray = [[arrPlaceData objectAtIndex:i] valueForKey:@"CommentRating"];
                  objPlaceDetail.placeCommentArray = [[arrPlaceData objectAtIndex:i] valueForKey:@"Comment"];
                  [objAppDelegate.marrPlaceDetail addObject:objPlaceDetail];
              }
              if (objPlaceDetail.placeCommentRatingArray.count > 0) {
                  tblHeightCon.constant = (objPlaceDetail.placeCommentRatingArray.count-1) * 45;
              }
              isRatingStart = NO;
              [self deleteAllCell];
              [self fillData];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if (error)
              {
                  NSLog(@"getPlaceDetailByPlaceID error = %@", error);
              }
              [MBProgressHUD hideHUDForView:self.view animated:YES];
          }];
}

-(void) storeRateAndComment
{
    NSMutableString *mstrRating = [[NSMutableString alloc] initWithString:@""];
    for (int i=0; i<marrRatingStore.count; i++) {
        if (i == marrRatingStore.count-1) {
            [mstrRating appendString:[NSString stringWithFormat:@"%@", [[marrRatingStore objectAtIndex:i] valueForKey:@"rate"]]];
        } else {
            [mstrRating appendString:[NSString stringWithFormat:@"%@,", [[marrRatingStore objectAtIndex:i] valueForKey:@"rate"]]];
        }
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:objRateCommentModel.commentUserSessionID, @"Com_SessionID", objRateCommentModel.commentTitle, @"Com_Title", objRateCommentModel.commentText, @"Com_Comment", [NSString stringWithFormat:@"%d", placeID], @"Com_PlaceID", objRateCommentModel.commentRepeat, @"Com_Repeat", mstrRating, @"Com_Rating", nil];
    [manager POST:[NSString stringWithFormat:@"http://www.opine.com.br/OpineAPI/api/comment/add"]
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"storeRateAndComment responseObject = %@", [NSString stringWithUTF8String:[responseObject bytes]]);
              NSDictionary *dictTemp = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
              if ([[dictTemp valueForKey:@"Message"] isEqualToString:@"Success"]) {
                  [self getPlaceDetailByPlaceID:placeID];
                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Obrigado" message:@"Voto e Comentário Enviado." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                  [alert show];
              } else {
                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erro" message:@"Seu voto não foi enviado. Tente novamente." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                  [alert show];
              }
              [MBProgressHUD hideHUDForView:self.view animated:YES];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if (error) {
                  NSLog(@"storeRateAndComment error = %@", error);
              }
              [MBProgressHUD hideHUDForView:self.view animated:YES];
          }];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void) deleteAllCell
{
    if (isRatingStart) {
        for (int i=0; i<objPlaceDetail.placeCommentRatingArray.count-1; i++) {
            [tblRateLabel reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
    if (isReloadTable) {
        for (int i=0; i<objPlaceDetail.placeCommentRatingArray.count-1; i++) {
            [tblRateLabel reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
    [tblRateLabel reloadData];
}

@end
