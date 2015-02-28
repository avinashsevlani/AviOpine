//
//  PlaceTableViewCell.h
//  Opine
//
//  Created by MoonRose Infotech on 11/11/14.
//  Copyright (c) 2014 MoonRose Infotech All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface PlaceTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView *lblPlaceTitleCell;
@property (weak, nonatomic) IBOutlet UITextView *lblPlaceAddressCell;
@property (weak, nonatomic) IBOutlet UIImageView *imgPlace;
@property (weak, nonatomic) IBOutlet UILabel *lblPlaceRatingCell;
@property (weak, nonatomic) IBOutlet UILabel *lblPalceRatingLabelCell;

@end
