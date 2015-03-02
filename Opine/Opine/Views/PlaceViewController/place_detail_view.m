//
//  place_detail_view.m
//  Opine
//
//  Created by apple on 12/01/15.
//  Copyright (c) 2015 TheAppGururz. All rights reserved.
//

#import "place_detail_view.h"
#import "RateLabelTableViewCell.h"
#import "DYRateView.h"
#import "RateView.h"
#import "TableViewCell.h"
#import "place_detail_Cell.h"
#import "My_Places_ViewController.h"
#import "UIImageView+WebCache.h"
#import "Utility_Class.h"

@interface place_detail_view ()<DYRateViewDelegate,RateViewDelegate>
{
    IBOutlet UITableView *tbl_rating;
    IBOutlet UITableView *tbl_place_details;
    IBOutlet UIView *view_answer;
    
    IBOutlet UIView *view_page_count;
    
    IBOutlet UILabel *lbl_ans_place;
    IBOutlet UILabel *lbl_ans_address;
    
    
    // Place details
    IBOutlet UIImageView *img_place;
    IBOutlet UILabel *lbl_place_tittle;
    IBOutlet UILabel *lbl_place_Address;
    IBOutlet UILabel *lbl_rating;
    
    NSMutableArray *array_user_name,*array_comment,*array_image,*totla_username,*total_comment,*total_image,*total_comment_id,*array_comment_id,*total_comment_reply,*array_comment_reply,*array_comment_tittle,*total_comment_tittle;
    
    
    IBOutlet UIView *view_more;
    IBOutlet UILabel *lbl_more_comm_titt;
    IBOutlet UILabel *lbl_more_comment;
    
    IBOutlet UITextView *txtv_ans_address;
    IBOutlet UILabel *lbl_pagecount;
    NSString* imageUrl;
}
@end

@implementation place_detail_view

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setborder:tbl_rating];
    [self setborder_lbl:lbl_ans_address];
    [self setborder_lbl:lbl_ans_place];
    [self setborder_view:view_more];
    [self setborder_textview_view:txtv_ans_address];
   // [self setborder_view:scroll_answer_View];
    tbl_place_details.separatorStyle = UITableViewCellSelectionStyleNone;
    
    
    
    object_appdelegate = [UIApplication sharedApplication].delegate;
  
    total_comment = [NSMutableArray new];
    totla_username = [NSMutableArray new];
    total_image = [NSMutableArray new];
    total_comment_id = [NSMutableArray new];
    total_comment_reply = [NSMutableArray new];
    total_comment_tittle = [NSMutableArray new];
    
    

    [self performSelector:@selector(get_data_from_service) withObject:nil afterDelay:0.2f];
    
//    [self set_array_values : 1];
//    
//    [self splitting_array];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resign_keyboard)];
    [scroll_answer_View addGestureRecognizer:tap];
    
    //    _dic_details
    [self change_framesizes];
    
}

-(void) get_data_from_service
{
    NSDictionary * dic_data = @{ @"place_id" :[NSString stringWithFormat:@"%@",_str_place_id],
                                 @"user_id" : object_appdelegate.userSessionID
                                 };
    NSString *str_url = @"http://opine.com.br/OpineAPI/api/myplace/detail?"; //
    // Post Service
   _dic_details  = [Utility_Class Request_service_get_response_in_Post:dic_data :str_url];
    
    NSDictionary* placeDetails = [[[_dic_details objectForKey:@"PlaceDetails"]objectForKey:@"Details"] objectAtIndex:0];
    lbl_place_tittle.text = [NSString stringWithFormat:@"%@",[placeDetails objectForKey:@"Pla_Name"]];
    lbl_place_Address.text = [NSString stringWithFormat:@"%@",[placeDetails objectForKey:@"Pla_FullAddress"]];
    lbl_rating.text =[NSString stringWithFormat:@"%.2f",[[placeDetails objectForKey:@"Rating"] floatValue]];
    
    imageUrl = [placeDetails objectForKey:@"Pla_Image"];
    [self performSelectorInBackground:@selector(show_image) withObject:nil];
    
    [self splitting_array];
    
    scroll_answer_View.hidden = YES;
}

-(void) splitting_array
{
    array_comment = [NSMutableArray new];
    array_user_name = [NSMutableArray new];
    array_image = [NSMutableArray new];
    array_comment_id = [NSMutableArray new];
    array_comment_reply = [NSMutableArray new];
    array_comment_tittle = [NSMutableArray new];
    
    float count = [[_dic_details valueForKeyPath:@"PlaceDetails.Comments.Com_Comment"] count];
    float five = 5;
    float no_of_badge = (count / five);
    CGFloat rounded_up =ceilf(no_of_badge);
    
    split_array =0;
    int j=0;
    for (int i=0; i <= rounded_up; i++)
    {
        for (j = j; j<[[_dic_details valueForKeyPath:@"PlaceDetails.Comments.Com_Comment"] count]; j++)
        {
            [total_comment addObject:[_dic_details valueForKeyPath:@"PlaceDetails.Comments.Com_Comment"][j]];
            [total_image addObject:[_dic_details valueForKeyPath:@"PlaceDetails.Comments.Com_Name_Image"][j]];
            [totla_username addObject:[_dic_details valueForKeyPath:@"PlaceDetails.Comments.Com_Name"][j]];
            [total_comment_id addObject:[_dic_details valueForKeyPath:@"PlaceDetails.Comments.Com_Id"][j]];
            [total_comment_reply addObject:[_dic_details valueForKeyPath:@"PlaceDetails.Comments.Com_Reply"][j]];
            [total_comment_tittle addObject:[_dic_details valueForKeyPath:@"PlaceDetails.Comments.Com_Title"][j]];
            
            if (total_comment .count % 5 == 0)
            {
                [array_comment addObject:total_comment];
                [array_image addObject:total_image];
                [array_user_name addObject:totla_username];
                [array_comment_id addObject:total_comment_id];
                [array_comment_reply addObject:total_comment_reply];
                [array_comment_tittle addObject:total_comment_tittle];
                
                total_comment = [NSMutableArray new];
                totla_username = [NSMutableArray new];
                total_image = [NSMutableArray new];
                total_comment_id = [NSMutableArray new];
                total_comment_reply = [NSMutableArray new];
                total_comment_tittle = [NSMutableArray new];
                break;
            }
        }
        if (rounded_up == i)
        {
            [array_comment addObject:total_comment];
            [array_image addObject:total_image];
            [array_user_name addObject:totla_username];
            [array_comment_id addObject:total_comment_id];
            [array_comment_reply addObject:total_comment_reply];
            [array_comment_tittle addObject:total_comment_tittle];
        }
    }
    [tbl_place_details reloadData];
}
-(void) show_image
{
    if (imageUrl)
    {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", imageUrl]]];
        if (data)
        {
            img_place.image = [UIImage imageWithData:data];
        }
        else
        {
            img_place.image = [UIImage imageNamed:@"myImage.jpg"];
        }

    }
    else
    {
        img_place.image = [UIImage imageNamed:@"myImage.jpg"];
    }
}

-(void) setvalign
{
    [lbl_ans_address sizeToFit];
}

-(void) resign_keyboard
{
    [txtv_answer resignFirstResponder];
}

#pragma mark - textview 

-(BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if (textView == txtv_answer)
    {
        CGPoint scrollPoint = CGPointMake(0.0,scroll_answer_View.frame.origin.y+100);
        [scroll_answer_View setContentOffset:scrollPoint animated:YES];
    }
    
    return YES;
}

-(BOOL) textViewShouldEndEditing:(UITextView *)textView
{
    if (textView == txtv_answer)
    {
        CGPoint scrollPoint = CGPointMake(0.0,scroll_answer_View.frame.origin.y-100);
        [scroll_answer_View setContentOffset:scrollPoint animated:YES];
    }
    return YES;
}

-(void) change_framesizes
{
    view_page_count.frame = CGRectMake(view_page_count.frame.origin.x, tbl_rating.frame.size.height+tbl_rating.frame.origin.y, view_page_count.frame.size.width, view_page_count.frame.size.height);
    
     tbl_place_details.frame = CGRectMake(tbl_place_details.frame.origin.x, view_page_count.frame.size.height+view_page_count.frame.origin.y, tbl_place_details.frame.size.width, tbl_place_details.frame.size.height);
}
-(void) setborder : (UITableView *) view
{
    [view layer].borderWidth = 2;
    [view layer].borderColor = [UIColor whiteColor].CGColor;
    view.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void) setborder_lbl : (UILabel *) lbl
{
    [lbl layer].borderWidth = 2;
    [lbl layer].borderColor = [UIColor whiteColor].CGColor;
}
-(void) setborder_view : (UIView *) view
{
    [view layer].borderWidth = 2;
    [view layer].borderColor = [UIColor whiteColor].CGColor;
}
-(void) setborder_scroll_view : (UIScrollView *) view
{
    [view layer].borderWidth = 2;
    [view layer].borderColor = [UIColor whiteColor].CGColor;
}
-(void) setborder_textview_view : (UITextView *) view
{
    [view layer].borderWidth = 2;
    [view layer].borderColor = [UIColor whiteColor].CGColor;
}
- (IBAction)btn_back_action:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 5001) {
        return 4;//[objPlaceDetail.placeCommentRatingArray count]-1;
    } else  if (tableView.tag == 5002)
    {
        NSLog(@"%d", [[array_comment objectAtIndex:split_array] count]);
        return [[array_comment objectAtIndex:split_array] count];   //[array_comment[split_array] count]; //return [[dictComments valueForKey:[NSString stringWithFormat:@"%d", tableView.tag]] count];
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 5001) {
        return 60;//[objPlaceDetail.placeCommentRatingArray count]-1;
    }
    else
    {
         return 150;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 5001)
    {
        static NSString *CellIdentifier = @"cell";
        TableViewCell *cell =(TableViewCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
        if (cell == nil)
        {
            cell=(TableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:self options:nil]objectAtIndex:0];
        }
        cell.backgroundColor = [UIColor colorWithRed:0.f green:187/255.0f blue:194/255.0f alpha:1.0f];
        DYRateView *rv = [[DYRateView alloc] initWithFrame:CGRectMake(100, 22, 220, 25)];
        rv.rate = 5;
        rv.delegate = self;
        rv.alignment = RateViewAlignmentLeft;
        rv.editable = YES;
        [cell addSubview:rv];
        cell.lblRateLabelName.text =  @"sdtetewrtertertdsgsdgdsgdfg";
        cell.lblRateLabelRating.text = @"13.4";
        
        if (indexPath.row % 2 == 0)
        {
            [cell.contentView setBackgroundColor:[UIColor colorWithRed:60/255.0f green:193/255.0f blue:200/255.0f alpha:1]];
            [cell.textLabel setBackgroundColor:[UIColor colorWithRed:60/255.0f green:193/255.0f blue:200/255.0f alpha:1]];
            [cell.textLabel setTextColor:[UIColor whiteColor]];
        }
        else
        {
            [cell.textLabel setBackgroundColor:[UIColor colorWithRed:140/255.0f green:221/255.0f blue:223/255.0f alpha:1]];
            [cell.contentView setBackgroundColor:[UIColor colorWithRed:140/255.0f green:221/255.0f blue:223/255.0f alpha:1]];
        }

        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"cell";
        place_detail_Cell *cell =(place_detail_Cell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
        if (cell == nil)
        {
            cell=(place_detail_Cell *)[[[NSBundle mainBundle] loadNibNamed:@"place_detail_Cell" owner:self options:nil]objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
       // cell.backgroundColor = [UIColor colorWithRed:120/255.0f green:214/255.0f blue:216/255.0f alpha:1.0f];
        cell.backgroundColor = [UIColor clearColor];
        cell.layer.borderWidth = 1.0;
        cell.layer.borderColor = [UIColor whiteColor].CGColor;
        DYRateView *rv = [[DYRateView alloc] initWithFrame:CGRectMake(8, 38, 200, 30)];
        rv.rate = 5;
        rv.delegate = self;
        rv.alignment = RateViewAlignmentLeft;
        rv.editable = YES;
        [cell addSubview:rv];
        NSLog(@"%@", [NSString stringWithFormat:@"%@",array_image[split_array][indexPath.row]]);
        [cell.img_place setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",array_image[split_array][indexPath.row]]] placeholderImage:[UIImage imageNamed:@"imagenotfound.png"]];
        
        cell.btn_reply.tag = indexPath.row;
        [cell.btn_reply addTarget:self action:@selector(btn_reply_action:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.btn_read_more.tag = indexPath.row;
        [cell.btn_read_more addTarget:self action:@selector(btn_read_more_action:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.lbl_comment.text =[NSString stringWithFormat:@"%@", array_comment[split_array] [indexPath.row]];
        cell.lbl_tittle.text = [NSString stringWithFormat:@"%@", array_comment_tittle[split_array] [indexPath.row]];
        cell.lbl_username.text = [NSString stringWithFormat:@"%@",array_user_name [split_array][indexPath.row]];
        
        return cell;
    }
    
    return nil;
}
#pragma mark - arrow action

- (IBAction)btn_right_arrow_action:(id)sender
{
    //[self set_array_values : 1];
    split_array ++;
    
    if (split_array >= [totla_username count])
    {
        
    }
    else
    {
        lbl_pagecount.text = [NSString stringWithFormat:@"Page: %d", split_array];
        [tbl_place_details reloadData];
    }
    
}
- (IBAction)btn_left_arrow_action:(id)sender
{
//    [self set_array_values : 0];
    split_array --;
    
    if (split_array >= [totla_username count])
    {
        
    }
    else
    {
        lbl_pagecount.text = [NSString stringWithFormat:@"Page: %d", split_array];
         [tbl_place_details reloadData];
    }
    
}

#pragma mark - set array count

-(void) set_array_values : (int) isfrom
{
   
    if (isfrom == 1)
    {
        if (total_comment.count > 5)
        {
            int i = index;
            for (i = index; index < [total_comment count]; index++)
            {
                [array_comment addObject: total_comment[index]];
                [array_user_name addObject:totla_username[index]];
                [array_image addObject:total_image[index]];
                if ([array_comment count] >4)
                {
                    break;
                }
            }
        }
        else
        {
            for (int i= index; i <[total_comment count]; i++)
            {
                [array_comment addObject: total_comment[i]];
                [array_user_name addObject:totla_username[i]];
                [array_image addObject:total_image[index]];
                index++;
            }
        }
    }
    else
    {
        index = index-5;
        if (total_comment.count > 5)
        {
            int i = index;
            for (i = index; index <= [total_comment count]; index--)
            {
                [array_comment addObject: total_comment[index]];
                [array_user_name addObject:totla_username[index]];
                [array_image addObject:total_image[index]];
                if ([array_comment count] >4)
                {
                    array_comment =  [[[array_comment reverseObjectEnumerator] allObjects] mutableCopy];
                    array_user_name =  [[[array_user_name reverseObjectEnumerator] allObjects] mutableCopy];
                    array_image =  [[[array_image reverseObjectEnumerator] allObjects] mutableCopy];
                    break;
                }
            }
        }
        else
        {
            for (int i= index; i <[total_comment count]; i--)
            {
                [array_comment addObject: total_comment[i]];
                [array_user_name addObject:totla_username[i]];
                [array_image addObject:total_image[index]];
                index--;
            }
        }
    }
    
    [tbl_place_details reloadData];
}

-(void) btn_reply_action : (UIButton *) button
{
    str_comment_id = array_comment_id [split_array][button.tag];
    lbl_ans_place.text = lbl_place_tittle.text;
//    lbl_ans_address.text =[NSString stringWithFormat:@"%@", array_comment [button.tag]];
    txtv_ans_address.text =[NSString stringWithFormat:@"Comment:\n%@", array_comment [split_array][button.tag]];
    txtv_answer.text =[NSString stringWithFormat:@"%@", array_comment_reply [split_array][button.tag]];
    scroll_answer_View.hidden = NO;
}
-(void) btn_read_more_action : (UIButton *) button
{
    view_more.hidden = NO;
    lbl_more_comm_titt.text = lbl_place_tittle.text;
    lbl_more_comment.text = [NSString stringWithFormat:@"%@", array_comment [split_array][button.tag]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btn_anser_cancel_action:(id)sender
{
    scroll_answer_View.hidden = YES;
}

-(void) reply_service
{
    NSDictionary * dic_data = @{ @"comment_id" :[NSString stringWithFormat:@"%@",str_comment_id],
                                 @"reply" : txtv_answer.text
                                 };
    NSString *str_url = @"http://opine.com.br/OpineAPI/api/myplace/reply?"; //
    // Post Service
    NSDictionary *dic_res  = [Utility_Class Request_service_get_response_in_Post:dic_data :str_url];
    
    [[[UIAlertView alloc]initWithTitle:[dic_res valueForKeyPath:@"Message"] message:[dic_res valueForKeyPath:@"MessageInfo"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];

    [self get_data_from_service];
    
}

- (IBAction)btn_answer_reply_action:(id)sender
{
     [self performSelectorInBackground:@selector(reply_service) withObject:nil];
}

#pragma mark- report action

- (IBAction)btn_report_action:(id)sender
{
    My_place_reportViewController *controller = [[My_place_reportViewController alloc] initWithNibName:@"My_place_reportViewController" bundle:nil];
    NSLog(@"%d", [[_dic_details valueForKeyPath:@"PlaceDetails.Details.Pla_Id"][0] intValue]);
    controller.str_placeid = [[_dic_details valueForKeyPath:@"PlaceDetails.Details.Pla_Id"][0] intValue];
    [self presentViewController:controller animated:YES completion:nil];
}
- (IBAction)btn_more_close:(id)sender
{
    view_more.hidden = YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
