//
//  TableViewCell.m
//  Vaa
//
//  Created by ess on 18/07/14.
//  Copyright (c) 2014 Everestindia. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell
@synthesize lblRateLabelName,lblRateLabelRating;
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
