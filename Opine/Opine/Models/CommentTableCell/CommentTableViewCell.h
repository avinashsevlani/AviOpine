//
//  CommentTableViewCell.h
//  Opine
//
//  Created by MoonRose Infotech on 12/11/14.
//  Copyright (c) 2014 MoonRose Infotech All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblCommenterName;
@property (weak, nonatomic) IBOutlet UILabel *lblCommentTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblComment;
@property (weak, nonatomic) IBOutlet UILabel *lblCommentDate;
@property (weak, nonatomic) IBOutlet UIButton *btnCommentReadMore;
@property (weak, nonatomic) IBOutlet UIImageView *imgCommenter;
- (IBAction)btnReadMoreTapped:(id)sender;

@end
