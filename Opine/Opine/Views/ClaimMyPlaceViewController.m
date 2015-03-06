//
//  ClaimMyPlaceViewController.m
//  Opine
//
//  Created by EverestIndia on 20/01/15.
//  Copyright (c) 2015 TheAppGururz. All rights reserved.
//

#import "ClaimMyPlaceViewController.h"
#import "RatingListTableViewCell.h"
#import "CommantTableViewCell.h"

#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"
#import "Claim_form_ViewController.h"
#import "UIImageView+WebCache.h"
#import "SignupViewController.h"




@interface ClaimMyPlaceViewController ()<DYRateViewDelegate,SignupViewControllerDelegate,UITextViewDelegate>
{
    NSUInteger _numPages;
    NSUInteger _pageCount;
    NSMutableArray *marrRatingStore;

}
@property (strong, nonatomic) IBOutlet UITableView *ratingTabelView;
@property (strong, nonatomic) IBOutlet UILabel *txt_Message;
@property (strong, nonatomic) IBOutlet UIView *view_repeat;
@property (strong, nonatomic) IBOutlet UIScrollView *scroll_commands;
- (IBAction)btn_Claim_Action:(UIButton *)sender;
- (IBAction)btn_rate_Commant_Action:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIView *view_ClaimCommant;
@property (strong, nonatomic) IBOutlet UITableView *tbl_CommandsList;
@property (strong, nonatomic) IBOutlet UIPageControl *page_controller;

- (IBAction)btn_back_Action:(UIButton *)sender;
- (IBAction)btn_share_action:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIImageView *img_property;
@property (strong, nonatomic) IBOutlet UITextView *txtview_lbl_title;
@property (strong, nonatomic) IBOutlet UITextView *txtview_address;
@property (strong, nonatomic) IBOutlet UILabel *lbl_rate;
@property (strong, nonatomic) IBOutlet UIButton *btn_yes;
@property (strong, nonatomic) IBOutlet UIButton *btn_no;
@property (strong, nonatomic) IBOutlet UILabel *lbl_repeat_Percent;
@property (strong, nonatomic) IBOutlet UIButton *btn_claim;
@property (strong, nonatomic) IBOutlet UIButton *btn_rate_Commant;
- (IBAction)btn_previous_Action:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *btn_previous;
- (IBAction)btn_next_Action:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *btn_next;
@property (strong, nonatomic) IBOutlet UILabel *lbl_page;
@property (strong, nonatomic) IBOutlet UIView *view_readMore;
@property (strong, nonatomic) IBOutlet UIButton *btn_close;
@property (strong, nonatomic) IBOutlet UILabel *lbl_commant;
@property (strong, nonatomic) IBOutlet UITextView *txt_commentDetails;
- (IBAction)btn_close_comment:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UITextView *txt_comment_title;
@property (strong, nonatomic) IBOutlet UIView *view_reply;
@property (strong, nonatomic) IBOutlet UITextView *txt_reply;
- (IBAction)btn_reply_Cancel:(UIButton *)sender;
- (IBAction)bnt_save_action:(UIButton *)sender;
@property (strong, nonatomic) NSString *commandp_id;


//Rate and commad.
@property (strong, nonatomic) IBOutlet UIScrollView *scrollview_rateandcommand;
@property (strong, nonatomic) IBOutlet UITableView *tbl_ratings;
@property (strong, nonatomic) IBOutlet UITextField *txt_command_title;
@property (strong, nonatomic) IBOutlet UITextView *txt_commentDescription;
@property (strong, nonatomic) IBOutlet UIButton *btn_close_rateandCommentview;
@property (strong, nonatomic) IBOutlet UIView *view_claim;
@property (strong, nonatomic) IBOutlet UIButton *btn_cliam_rateandCommant;
@property (strong, nonatomic) IBOutlet UIView *view_repeate_rateandCommand;
@property (strong, nonatomic) IBOutlet UILabel *lbl_repeat;
@property (strong, nonatomic) IBOutlet UILabel *lbl_percentage;
@property (strong, nonatomic) IBOutlet UIButton *btn_yes_rateandCommant;
@property (strong, nonatomic) IBOutlet UIButton *btn_no_rateandCommant;
@property (strong, nonatomic) IBOutlet UIView *view_closeSaveSahre;
@property (strong, nonatomic) IBOutlet UIButton *btn_sharethis;
- (IBAction)btn_Sharethis_Action:(UIButton *)sender;
- (IBAction)btn_close_Action:(UIButton *)sender;
- (IBAction)btn_submit_action:(UIButton *)sender;
- (IBAction)_bnt_yest_rateandCommentAction:(UIButton *)sender;
- (IBAction)btn_no_rate_Aomment_Action:(UIButton *)sender;






@end

@implementation ClaimMyPlaceViewController
@synthesize placeID;
bool isShareIts = NO,iisRepeatNo = NO,iisRepeatYes = NO;


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];

    // Do any additional setup after loading the view from its nib.
}
-(void)setUpUI
{
    //-----------Rateview TabelView Works---------
    UINib *nib = [UINib nibWithNibName:@"RatingListTableViewCell" bundle:nil];
    [[self ratingTabelView] registerNib:nib forCellReuseIdentifier:@"RatingListTableViewCellRUI"];
    [self ratingTabelView].scrollEnabled=false;
    [self ratingTabelView].separatorStyle= UITableViewCellSeparatorStyleNone;
    [self ratingTabelView].backgroundColor=[UIColor clearColor];
    
    [[self tbl_ratings] registerNib:nib forCellReuseIdentifier:@"RatingListTableViewCellRUI"];
    [self tbl_ratings].scrollEnabled=false;
    [self tbl_ratings].separatorStyle= UITableViewCellSeparatorStyleNone;
    [self tbl_ratings].backgroundColor=[UIColor clearColor];

    
    //-----------Commant tabelview Works------------
    nib = [UINib nibWithNibName:@"CommantTableViewCell" bundle:nil];
    [[self tbl_CommandsList] registerNib:nib forCellReuseIdentifier:@"CommantTableViewCellRUI"];
    [self tbl_CommandsList].scrollEnabled=false;
    [self tbl_CommandsList].separatorStyle= UITableViewCellSeparatorStyleNone;
    [self tbl_CommandsList].backgroundColor=[UIColor clearColor];
    
    objRateCommentModel = [[RateCommentModel alloc] init];
    objAppDelegate = [[UIApplication sharedApplication] delegate];
    marrCommentData = [[NSMutableArray alloc] init];

    
    //Read More
    _view_readMore.layer.borderColor = [UIColor whiteColor].CGColor;
    _view_readMore.layer.borderWidth = 3;
    [self closeCommentView];
    [self getPlaceDetails:placeID];
    
    
    [self hideReply];
    
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    [keyboardDoneButtonView sizeToFit];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleBordered target:self
                                                                  action:@selector(doneClicked:)];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
    _txt_reply.inputAccessoryView = keyboardDoneButtonView;
    _txt_commentDescription.inputAccessoryView = keyboardDoneButtonView;
    [_btn_sharethis setImage:[UIImage imageNamed:@"imgUnChecked.png"] forState:UIControlStateNormal];

    marrRatingStore = [[NSMutableArray alloc] init];
    array_comment_reply = [NSMutableArray new];

    [self hiderateAndCommantView];

}
-(void)doneClicked:(id)sender
{
    NSLog(@"Done Clicked.");
    [self.view endEditing:YES];
}
-(void)getPlaceDetails:(NSInteger)IplaceID
{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d", IplaceID], @"Pla_Id", nil];
    [manager POST:[NSString stringWithFormat:@"http://www.opine.com.br/OpineAPI/api/place/get"]
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              //Code for processing the service.
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
              
              
              [self fillData];
              
              [MBProgressHUD hideHUDForView:self.view animated:YES];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if (error)
              {
                  NSLog(@"getPlaceDetailByPlaceID error = %@", error);
              }
              [MBProgressHUD hideHUDForView:self.view animated:YES];
          }];

}
-(void)fillData
{
    //Update the ui
    if (objPlaceDetail == nil) {
        return;
    }

    [_txtview_lbl_title setText:objPlaceDetail.placeName];

    _txt_Message.text= objPlaceDetail.placeMessage;
    
    NSString *strAddress = [NSString stringWithFormat:@"%@, %@, %@, %@", objPlaceDetail.placeAddress, objPlaceDetail.placeCity, objPlaceDetail.placeZip, objPlaceDetail.placeState];
    [_txtview_address setText:strAddress];

    if (![objPlaceDetail.placeImage isEqual: @""]) {
        NSURL *url = [[NSURL alloc] initWithString:objPlaceDetail.placeImage];
        NSData *imgData = [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:nil];
        _img_property.image = [UIImage imageWithData:imgData];
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
    for (int i=0; i<objPlaceDetail.placeCommentArray.count; i++)
    {
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
     _page_controller.currentPage = _pageCount-1;
     _page_controller.numberOfPages = _numPages;

    [_lbl_page setText:[NSString stringWithFormat:@"Page : %lu",(unsigned long)_pageCount]];

    if (objAppDelegate.isLogin) {
        [_btn_rate_Commant setBackgroundImage:[UIImage imageNamed:@"imgButtonRate.png"] forState:UIControlStateNormal];
        _btn_rate_Commant.frame = CGRectMake(_btn_rate_Commant.frame.origin.x+30, _btn_rate_Commant.frame.origin.y, _btn_rate_Commant.frame.size.width, _btn_rate_Commant.frame.size.height);
        [_btn_rate_Commant setTitle:@"" forState:UIControlStateNormal];
        
    } else {
        [_btn_rate_Commant setImage:[UIImage imageNamed:@"imgRateComment.png"] forState:UIControlStateNormal];
        [_btn_rate_Commant setTitle:@"Rate & commant" forState:UIControlStateNormal];
        _btn_rate_Commant.frame = CGRectMake(_btn_rate_Commant.frame.origin.x, _btn_rate_Commant.frame.origin.y, _btn_rate_Commant.frame.size.width, _btn_rate_Commant.frame.size.height);
    }
    if (_numPages > 1) {
        _page_controller.hidden = NO;
    } else {
        _page_controller.hidden = YES;
    }

    [_lbl_repeat_Percent setText:[NSString stringWithFormat:@"%@%%", [[objPlaceDetail.placeCommentRatingArray objectAtIndex:objPlaceDetail.placeCommentRatingArray.count-1] valueForKey:@"Repeat"]]];

    
    [self updateTabel1Height:40*(objPlaceDetail.placeCommentRatingArray.count-1) Tabel2Height:180*4 isEnableMessage:YES];
    [self updateTableViewCommant: 40*(objPlaceDetail.placeCommentRatingArray.count-1)];

    [_tbl_CommandsList reloadData];
    [_ratingTabelView reloadData];
    [_tbl_ratings reloadData];

}
- (void)loadStarControlInHeader
{
    _lbl_rate.text = [NSString stringWithFormat:@"Rating : %0.1f", [objPlaceDetail.placeRating doubleValue]];
}
-(void) ratingUserInterfaceEnable:(BOOL)isEnable
{
    _btn_no.userInteractionEnabled = isEnable;
    _btn_yes.userInteractionEnabled = isEnable;
}
//---------For updateing the table view ---------------
-(void)updateTableViewCommant:(int)height
{
    /*
      UIScrollView *scrollview_rateandcommand;
      UITableView *tbl_ratings;
      UITextField *txt_command_title;
      UITextView *txt_commentDescription;
      UIButton *btn_close_rateandCommentview;
      UIView *view_claim;
      UIButton *btn_cliam_rateandCommant;
      UIView *view_repeate_rateandCommand;
      UILabel *lbl_repeat;
      UILabel *lbl_percentage;
      UIButton *btn_yes_rateandCommant;
      UIButton *btn_no_rateandCommant;
     UIView *view_closeSaveSahre
     */
    
    CGRect tabelViewFrame = [self tbl_ratings].layer.frame;
    //Update message tabelview y position based on the Messageview enabled.
    tabelViewFrame.size.height= height;
    [self tbl_ratings].layer.frame=tabelViewFrame;
    

    tabelViewFrame = _view_repeate_rateandCommand.layer.frame;
    tabelViewFrame.origin.y = 10 +[self tbl_ratings].layer.frame.origin.y + [self tbl_ratings].layer.frame.size.height;
    _view_repeate_rateandCommand.layer.frame = tabelViewFrame;

    
    
    tabelViewFrame = _txt_command_title.layer.frame;
    tabelViewFrame.origin.y = 10 +[self view_repeate_rateandCommand].layer.frame.origin.y + [self view_repeate_rateandCommand].layer.frame.size.height;;
    _txt_command_title.layer.frame = tabelViewFrame;
    
    
    tabelViewFrame = _txt_commentDescription.layer.frame;
    tabelViewFrame.origin.y = 10 + _txt_command_title.layer.frame.origin.y + _txt_command_title.layer.frame.size.height;
    _txt_commentDescription.layer.frame = tabelViewFrame;
    
    tabelViewFrame = _view_claim.layer.frame;
    tabelViewFrame.origin.y = 10 + _txt_commentDescription.layer.frame.origin.y + _txt_commentDescription.layer.frame.size.height;
    _view_claim.layer.frame = tabelViewFrame;
    
    tabelViewFrame = _view_closeSaveSahre.layer.frame;
    tabelViewFrame.origin.y =  _txt_commentDescription.layer.frame.origin.y + _txt_commentDescription.layer.frame.size.height;
    _view_closeSaveSahre.layer.frame = tabelViewFrame;
    
    
    
    //For Update Scrollview Scrolling insects.
    _scrollview_rateandcommand.contentSize = CGSizeMake(_scrollview_rateandcommand.frame.size.width,tabelViewFrame.origin.y + tabelViewFrame.size.height +200);
    
}
//Update the UI Based on the MEssage and the Height of the TabelVeiw Cell
-(void)updateTabel1Height:(int)height Tabel2Height:(int)height2 isEnableMessage:(BOOL)isEnable
{
    //Update message textview.
    _txt_Message.hidden=!isEnable;

    
    //TextView Message
    [_txt_Message sizeToFit];
    
//    _txt_Message.adjustsFontSizeToFitWidth  = YES;
//    _txt_Message.minimumFontSize      =  0.5;

    CGRect tabelViewFrame = [self ratingTabelView].layer.frame;
    //Update message tabelview y position based on the Messageview enabled.
    tabelViewFrame.origin.y= isEnable?_txt_Message.layer.frame.origin.y + _txt_Message.layer.frame.size.height +10 :_txt_Message.layer.frame.origin.y;
    tabelViewFrame.size.height= height;
    [self ratingTabelView].layer.frame=tabelViewFrame;
    
    //For update repeate view
    tabelViewFrame= _view_repeat.layer.frame;
    tabelViewFrame.origin.y = _ratingTabelView.layer.frame.origin.y+ _ratingTabelView.layer.frame.size.height + 8;
    _view_repeat.frame= tabelViewFrame;
    
    //For update the Claim button views
    tabelViewFrame =_view_ClaimCommant.layer.frame;
    tabelViewFrame.origin.y = _view_repeat.layer.frame.origin.y+ _view_repeat.layer.frame.size.height + 8;
    _view_ClaimCommant.frame= tabelViewFrame;
    
    //for update commant tabelview Height
     tabelViewFrame = [self tbl_CommandsList].layer.frame;
    //Update command tabelview y position based on the Messageview enabled.
    //tabelViewFrame.origin.y= isEnable?_view_ClaimCommant.layer.frame.origin.y + _view_ClaimCommant.layer.frame.size.height +10 :_view_ClaimCommant.layer.frame.origin.y + 10;
    tabelViewFrame.origin.y=_view_ClaimCommant.layer.frame.origin.y + _view_ClaimCommant.layer.frame.size.height +10;
    
    tabelViewFrame.size.height= height2;
    [self tbl_CommandsList].layer.frame=tabelViewFrame;
  
    //----------Page controll upate-------------
    tabelViewFrame= _page_controller.layer.frame;
    tabelViewFrame.origin.y = _tbl_CommandsList.layer.frame.origin.y+ _tbl_CommandsList.layer.frame.size.height + 8;
    _page_controller.frame= tabelViewFrame;

   

    
    //For Update Scrollview Scrolling insects.
    _scroll_commands.contentSize = CGSizeMake(_scroll_commands.frame.size.width,tabelViewFrame.origin.y + tabelViewFrame.size.height +200);
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ((tableView == _ratingTabelView) || (tableView == _tbl_ratings) )?40:180;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
    int commandcount=0;
    if (_pageCount > _numPages) {
        _pageCount = _numPages ;
        commandcount = [[dictComments objectForKey:[NSString stringWithFormat:@"%d",_pageCount]] count];
    }
    else if(_pageCount <= 0)
    {
        _pageCount = (_numPages>0)?1:0;
        commandcount = [[dictComments objectForKey:[NSString stringWithFormat:@"%d",_pageCount]] count];
    }
    else
    {
        commandcount = [[dictComments objectForKey:[NSString stringWithFormat:@"%d",_pageCount]] count];
    }
    
    if(tableView == _ratingTabelView)
        return objPlaceDetail.placeCommentRatingArray.count-1;
    else if(tableView == _tbl_ratings)
    {
        int o =objPlaceDetail.placeCommentRatingArray.count-1;
        NSLog(@"%d",o);

        return o;
    }
    else
        return commandcount;
//    return ((tableView == _ratingTabelView) || (tableView == _tbl_ratings) ) ?objPlaceDetail.placeCommentRatingArray.count-1:commandcount;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _tbl_ratings)
    {
        RatingListTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"RatingListTableViewCellRUI"];
        if (cell == nil) {
            // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"RatingListTableViewCell" owner:nil options:nil];
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.layer.borderColor=[UIColor whiteColor].CGColor;
        cell.layer.borderWidth=1;
        cell.backgroundColor=[UIColor clearColor];
        
        if ((objPlaceDetail.placeCommentRatingArray.count == 0) || (tableView == _tbl_ratings)) {
            cell.view_rating.rate = 0;
        }
        cell.view_rating.alignment = RateViewAlignmentLeft;
        cell.view_rating.delegate = self;
        cell.view_rating.editable = YES;

        cell.lbl_commandtitle.text = [[objPlaceDetail.placeCommentRatingArray objectAtIndex:indexPath.row] valueForKey:@"Name"];
        cell.lbl_percentage.text = [[objPlaceDetail.placeCommentRatingArray objectAtIndex:indexPath.row] valueForKey:@"Rate"];
        
        if(tableView == _tbl_ratings)
        {
            cell.lbl_percentage.text = @"0";
        }
        NSLog(@"%@", objPlaceDetail.placeCommentRatingArray);
        cell.lbl_percentage.tag = [[[objPlaceDetail.placeCommentRatingArray objectAtIndex:indexPath.row] valueForKey:@"Id"] integerValue];
        cell.view_rating.tag = [[[objPlaceDetail.placeCommentRatingArray objectAtIndex:indexPath.row] valueForKey:@"Id"] integerValue];
        cell.tag = [[[objPlaceDetail.placeCommentRatingArray objectAtIndex:indexPath.row] valueForKey:@"Id"] integerValue];
        return cell;
    }
    else if (tableView == _ratingTabelView)
    {
        RatingListTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"RatingListTableViewCellRUI"];
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"RatingListTableViewCell" owner:self options:nil];
            cell = [topLevelObjects objectAtIndex:0];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.layer.borderColor=[UIColor whiteColor].CGColor;
        cell.layer.borderWidth=1;
        cell.backgroundColor=[UIColor clearColor];
        
        if ((objPlaceDetail.placeCommentRatingArray.count == 0) || (tableView == _tbl_ratings)) {
            cell.view_rating.rate = 0;
        }
        else
        {
            cell.view_rating.rate = [[[objPlaceDetail.placeCommentRatingArray objectAtIndex:indexPath.row] valueForKey:@"Rate"] doubleValue];
        }
        cell.view_rating.alignment = RateViewAlignmentLeft;

//        if (tableView == _tbl_ratings)
//            cell.view_rating.delegate = self;
//        else
        
        cell.view_rating.delegate = nil;
        cell.lbl_commandtitle.text = [[objPlaceDetail.placeCommentRatingArray objectAtIndex:indexPath.row] valueForKey:@"Name"];
        cell.lbl_percentage.text = [[objPlaceDetail.placeCommentRatingArray objectAtIndex:indexPath.row] valueForKey:@"Rate"];
        
//       if(tableView == _tbl_ratings)
//       {
//            cell.lbl_percentage.text = @"0";
//       }
//        cell.lbl_percentage.tag = [[[objPlaceDetail.placeCommentRatingArray objectAtIndex:indexPath.row] valueForKey:@"Id"] integerValue];
//        cell.view_rating.tag = [[[objPlaceDetail.placeCommentRatingArray objectAtIndex:indexPath.row] valueForKey:@"Id"] integerValue];

        return cell;
    }
    else
    {
        CommantTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"CommantTableViewCellRUI"];
        if (cell == nil) {
            // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CommantTableViewCell" owner:nil options:nil];
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.layer.borderColor=[UIColor whiteColor].CGColor;
        cell.layer.borderWidth=1;
        cell.backgroundColor=[UIColor clearColor];
        
        NSDictionary *element=[[dictComments objectForKey:[NSString stringWithFormat:@"%d",_pageCount]] objectAtIndex:indexPath.row];
        
        if (objPlaceDetail.placeCommentRatingArray.count == 0) {
            cell.view_rate.rate = 0;
        } else {
            cell.view_rate.rate = [[element valueForKey:@"Rate"] doubleValue];
        }
        cell.view_rate.alignment = RateViewAlignmentLeft;
        cell.view_rate.delegate = nil;

        cell.lbl_username.text = [element valueForKey:@"Com_Name"];
        cell.lbl_date.text = [element valueForKey:@"Com_Date"];
        cell.lbl_commandTitle.text = [element valueForKey:@"Com_Title"];
        cell.lbl_Command.text = [element valueForKey:@"Com_Comment"]; //@"dstgew weht ehwit hwtesytywetyweutyouw ytuy wuty wyuyewu yeuwytuy uweytuy ";//

        NSURL *url = [NSURL URLWithString:[[element valueForKey:@"Com_Name_Image"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
        [cell.img_userphoto setImageWithURL:url placeholderImage:[UIImage imageNamed:@"imagenotfound.png"]];
        
        
        cell.btn_readmore.hidden=([[element valueForKey:@"Com_Comment"] length]<35);
        cell.btn_readmore.tag=indexPath.row;
        [cell.btn_readmore addTarget:self action:@selector(readmoreAction:) forControlEvents:UIControlEventTouchUpInside];
        
       

        
        
        cell.btn_reply.tag=indexPath.row;
        [cell.btn_reply addTarget:self action:@selector(replyAction:) forControlEvents:UIControlEventTouchUpInside];
        
        NSString* replyText = [NSString stringWithFormat:@"%@",element[@"Com_Reply"]];
        if (replyText.length > 0)
        {
            cell.btn_reply.hidden = NO;
        }
        else
        {
            cell.btn_reply.hidden = YES;
        }
        return cell;
    }
}
#pragma mark - DYRateViewDelegate
- (void)rateView:(DYRateView *)rateView changedToNewRate:(NSNumber *)rate
{
    RatingListTableViewCell *cellRateLabel = (RatingListTableViewCell *)[_tbl_ratings viewWithTag:rateView.tag];
    cellRateLabel.lbl_percentage.text = [NSString stringWithFormat:@"%@", rate];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"rate%d:%@", rateView.tag, rate], @"rate", nil];
    [marrRatingStore addObject:dict];
}

-(void)readmoreAction:(UIButton *)sender
{
    NSDictionary *element=[[dictComments objectForKey:[NSString stringWithFormat:@"%d",_pageCount]] objectAtIndex:sender.tag];
     _txt_commentDetails.text = [element valueForKey:@"Com_Comment"];
    _txt_comment_title.text = [element valueForKey:@"Com_Title"];

    [self openCommentView];
}


-(void)replyAction:(UIButton *)sender
{
    NSDictionary *element=[[dictComments objectForKey:[NSString stringWithFormat:@"%d",_pageCount]] objectAtIndex:sender.tag];

    _commandp_id =[NSString stringWithFormat:@"%@",element[@"Com_Id"]];
    _txt_reply.text =[NSString stringWithFormat:@"%@",element[@"Com_Reply"]];
    [self showReply];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btn_Claim_Action:(UIButton *)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Check Data" message:@"Is this property belongs to you?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
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
        controller.str_place_name = _txtview_lbl_title.text;
        [self presentViewController:controller animated:YES completion:nil];
    }
}
#pragma  mark -
#pragma  mark Rate and comment action
-(void)showRateAndcommantView
{
    _scrollview_rateandcommand.hidden=NO;
}
-(void)hiderateAndCommantView
{
    _txt_command_title.text=@"";
    _txt_commentDescription.textColor = [UIColor lightGrayColor];
    _txt_commentDescription.text=@"Comment";
    _scrollview_rateandcommand.hidden=YES;
}


- (IBAction)btn_back_Action:(UIButton *)sender
{
    [self.delegate setLoginEnable];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)btn_share_action:(UIButton *)sender
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
    if (!isShareIts) {
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

- (IBAction)bnt_clim_Action:(UIButton *)sender
{
    
}

- (IBAction)btn_previous_Action:(UIButton *)sender
{
    _pageCount--;
    if (_pageCount > _numPages) {
        _pageCount = _numPages ;
    }
    else if(_pageCount <= 0)
    {
        _pageCount = (_numPages>0)?1:0;
    }
    [_lbl_page setText:[NSString stringWithFormat:@"Page : %lu",(unsigned long)_pageCount]];
    _page_controller.currentPage = _pageCount-1;
    [_tbl_CommandsList reloadData];
}

- (IBAction)btn_next_Action:(UIButton *)sender
{
    _pageCount++;
    if (_pageCount > _numPages) {
        _pageCount = _numPages ;
    }
    else if(_pageCount <= 0)
    {
        _pageCount = (_numPages>0)?1:0;
    }
    [_lbl_page setText:[NSString stringWithFormat:@"Page : %lu",(unsigned long)_pageCount]];
    _page_controller.currentPage = _pageCount-1;
    [_tbl_CommandsList reloadData];
}
#pragma mark -
#pragma mark read more Button view actions.
- (IBAction)btn_close_comment:(UIButton *)sender
{
    [self closeCommentView];
}
-(void)closeCommentView
{
    _view_readMore.hidden=YES;
}
-(void)openCommentView
{
    _view_readMore.hidden =NO;
}


#pragma mark -
#pragma mark Reply Button view actions.
-(void)showReply
{
//    if (objAppDelegate.isLogin)
//    {
//        
//    }
//    else
//    {
//       [[[UIAlertView alloc] initWithTitle:@"Opine" message:@"Not logged in. Please login and try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
//    }
    
    _view_reply.hidden=NO;
    
    
}

-(void)hideReply
{
    _view_reply.hidden=YES;
}
- (IBAction)btn_reply_Cancel:(UIButton *)sender
{
    _txt_reply.text =@"";
    [self hideReply];
}

- (IBAction)bnt_save_action:(UIButton *)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *s=[[NSString stringWithFormat:@"http://opine.com.br/OpineAPI/application/controllers/api/reply.php?comment_id=%@&reply=%@",_commandp_id,_txt_reply.text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url=[NSURL URLWithString:s];
    
    NSError *error = nil;
    
     NSData *data=[NSData dataWithContentsOfURL:url options:kNilOptions error:&error];
    
    if (error) {
        [[[UIAlertView alloc] initWithTitle:@"Opine" message:@"Error in connection." delegate:nil cancelButtonTitle:@"Ok"otherButtonTitles: nil] show];
    }
    else
    {
        NSDictionary *json=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        
        NSLog(@"%@",json);
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    //TODO service call for save that.
    _txt_reply.text =@"";
    [self hideReply];

}
- (IBAction)btn_Sharethis_Action:(UIButton *)sender
{
    if (isShareIts) {
        isShareIts = NO;
        [_btn_sharethis setImage:[UIImage imageNamed:@"imgUnChecked.png"] forState:UIControlStateNormal];
    } else {
        isShareIts = YES;
        [_btn_sharethis setImage:[UIImage imageNamed:@"imgChecked.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)btn_close_Action:(UIButton *)sender
{
    [self hiderateAndCommantView];
}

- (IBAction)btn_submit_action:(UIButton *)sender
{
    objRateCommentModel.commentUserSessionID = objAppDelegate.userSessionID;
    objRateCommentModel.commentTitle = [_txt_command_title text];
    objRateCommentModel.commentText = [_txt_commentDescription text];
    objRateCommentModel.commentPlaceID = [NSString stringWithFormat:@"%d", placeID];
    
    
    NSMutableArray * tempArray = [[NSMutableArray alloc]initWithArray:marrRatingStore];
    [marrRatingStore removeAllObjects];
    
    for (int i=tempArray.count-1; i>=0; i--)
    {
        BOOL ispresent = NO;
        for (int j=marrRatingStore.count-1; j>=0; j--)
        {
            NSString *f = [[tempArray objectAtIndex:i] valueForKey:@"rate"];
            NSString *first = [[f componentsSeparatedByString:@":"] objectAtIndex:0];
            NSString *s = [[marrRatingStore objectAtIndex:j] valueForKey:@"rate"];
            NSString *sec = [[s componentsSeparatedByString:@":"] objectAtIndex:0];
            if ([first isEqual:sec])
            {
                ispresent = YES;
                break;
            }
        }
        if (!ispresent)
        {
            [marrRatingStore addObject:[tempArray objectAtIndex:i]];
        }
    }
    [self storeRateAndComment];
    [_btn_rate_Commant setImage:[UIImage imageNamed:@"imgRateComment.png"] forState:UIControlStateNormal];
    _btn_rate_Commant.hidden = NO;
    //    btnClaim.hidden = NO;

    [self getPlaceDetails:placeID];
    [_btn_yes_rateandCommant setBackgroundImage:[UIImage imageNamed:@"imgYesDisable.png"] forState:UIControlStateNormal];
    [_btn_no_rateandCommant setBackgroundImage:[UIImage imageNamed:@"imgNoDisable.png"] forState:UIControlStateNormal];
    if (isShareIts) {
        [self shareData];
    }

    isShareIts = NO;

        [self hiderateAndCommantView];
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
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:objRateCommentModel.commentUserSessionID, @"Com_SessionID", objRateCommentModel.commentTitle, @"Com_Title", objRateCommentModel.commentText, @"Com_Comment", [NSString stringWithFormat:@"%d", placeID], @"Com_PlaceID",mstrRating, @"Com_Rating", objRateCommentModel.commentRepeat, @"Com_Repeat", nil];
    [manager POST:[NSString stringWithFormat:@"http://www.opine.com.br/OpineAPI/api/comment/add"]
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"storeRateAndComment responseObject = %@", [NSString stringWithUTF8String:[responseObject bytes]]);
              NSDictionary *dictTemp = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
              if ([[dictTemp valueForKey:@"Message"] isEqualToString:@"Success"]) {
                  [self getPlaceDetails:placeID];
                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thank You" message:@"Your Rate & Comment is Submitted." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
                  [alert show];
              } else {
                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your Rate & Comment not Submitted, Please give it again." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
                  [alert show];
              }
              [MBProgressHUD hideHUDForView:self.view animated:YES];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
              {
              if (error) {
                  NSLog(@"storeRateAndComment error = %@", error);
              }
              [MBProgressHUD hideHUDForView:self.view animated:YES];
          }];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (IBAction)_bnt_yest_rateandCommentAction:(UIButton *)sender
{
    if (iisRepeatNo) {
        [_btn_no_rateandCommant setBackgroundImage:[UIImage imageNamed:@"imgNoDisable.png"] forState:UIControlStateNormal];
    }
    [_btn_yes_rateandCommant setBackgroundImage:[UIImage imageNamed:@"imgYesEnable.png"] forState:UIControlStateNormal];
    iisRepeatYes = YES;
    objRateCommentModel.commentRepeat = @"1";


}

- (IBAction)btn_rate_Commant_Action:(UIButton *)sender
{
    
    if (!objAppDelegate.isLogin) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SignupViewController *objSignupViewController = [storyBoard instantiateViewControllerWithIdentifier:@"SignupViewController"];
        objSignupViewController.delegate = self;
        [self presentViewController:objSignupViewController animated:YES completion:nil];
        return;
    }
//    if (!isRate) {
//        [_btn_rate_Commant setImage:[UIImage imageNamed:@"imgRateNow.png"] forState:UIControlStateNormal];
//        isShareIts = NO;
//        iisRepeatNo = NO;
//        iisRepeatYes = NO;
//
//        [self deleteAllCell];
//        [lblRepeat setText:@"0%"];
//        btnRate.hidden = YES;
//        //        btnClaim.hidden = YES;
//        vwComment.hidden = NO;
//        [self ratingUserInterfaceEnable:YES];
//    } else {
//        [btnRate setImage:[UIImage imageNamed:@"imgButtonRate.png"] forState:UIControlStateNormal];
//        isRate = NO;
//        isRatingStart = NO;
//        [self deleteAllCell];
//        [lblRepeat setText:[NSString stringWithFormat:@"%@%%", [[objPlaceDetail.placeCommentRatingArray objectAtIndex:objPlaceDetail.placeCommentRatingArray.count-1] valueForKey:@"Repeat"]]];
//        [btnYes setBackgroundImage:[UIImage imageNamed:@"imgYesDisable.png"] forState:UIControlStateNormal];
//        [btnNo setBackgroundImage:[UIImage imageNamed:@"imgNoDisable.png"] forState:UIControlStateNormal];
//        vwComment.hidden = YES;
//        btnRate.hidden = NO;
//        //        btnClaim.hidden = NO;
//        [self ratingUserInterfaceEnable:NO];
//    }
    
    [self showRateAndcommantView];
}

#pragma mark - SignUpViewControllerDelegate Method
- (void)setUserName:(NSString *)username
{
    if (objAppDelegate.isLogin) {
        [_btn_rate_Commant setImage:[UIImage imageNamed:@"imgButtonRate.png"] forState:UIControlStateNormal];
        _btn_rate_Commant.hidden = YES;
        //        btnClaim.hidden = YES;
        [self showRateAndcommantView];
    } else {
        [_btn_rate_Commant setImage:[UIImage imageNamed:@"imgRateComment.png"] forState:UIControlStateNormal];
//        vwComment.hidden = YES;
        [self hiderateAndCommantView];
        //        btnClaim.hidden = NO;
        _btn_rate_Commant.hidden = NO;
    }
    [_btn_rate_Commant setImage:[UIImage imageNamed:@"imgRateNow.png"] forState:UIControlStateNormal];
    isShareIts = NO;
    iisRepeatNo = NO;
    iisRepeatYes = NO;
    [_lbl_repeat setText:@"0%"];
    _btn_rate_Commant.hidden = YES;
    //    btnClaim.hidden = YES;
    [self showRateAndcommantView];
//    [self ratingUserInterfaceEnable:YES];
    //    [self.tblComment reloadData];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Comment"])
    {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    return  YES;
}


- (IBAction)btn_no_rate_Aomment_Action:(UIButton *)sender
{
    if (iisRepeatYes) {
        [_btn_yes_rateandCommant setBackgroundImage:[UIImage imageNamed:@"imgYesDisable.png"] forState:UIControlStateNormal];
    }
    [_btn_no_rateandCommant setBackgroundImage:[UIImage imageNamed:@"imgNoEnable.png"] forState:UIControlStateNormal];
    iisRepeatNo = YES;
    objRateCommentModel.commentRepeat = @"0";
}
@end
