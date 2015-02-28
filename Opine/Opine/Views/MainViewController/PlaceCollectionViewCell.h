//
//  PlaceCollectionViewCell.h
//  Opine
//
//  Created by MoonRose Infotech on 06/11/14.
//  Copyright (c) 2014 MoonRose Infotech All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RateView.h"

@interface PlaceCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgPlacePhoto;
@property (weak, nonatomic) IBOutlet UILabel *lblPlaceName;
@property (weak, nonatomic) IBOutlet UILabel *lblPlaceCity;
@property (weak, nonatomic) IBOutlet RateView *vwRating;

@end
