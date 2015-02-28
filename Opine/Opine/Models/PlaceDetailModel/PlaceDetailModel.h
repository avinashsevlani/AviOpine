//
//  PlaceDetailModel.h
//  Opine
//
//  Created by MoonRose Infotech on 20/11/14.
//  Copyright (c) 2014 MoonRose Infotech All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlaceDetailModel : NSObject

@property (nonatomic, strong) NSString *placeID;
@property (nonatomic, strong) NSString *placeName;
@property (nonatomic, strong) NSString *placePhone;
@property (nonatomic, strong) NSString *placeImage;
@property (nonatomic, strong) NSString *placeAddress;
@property (nonatomic, strong) NSString *placeZip;
@property (nonatomic, strong) NSString *placeCity;
@property (nonatomic, strong) NSString *placeState;
@property (nonatomic, strong) NSString *placeQue1;
@property (nonatomic, strong) NSString *placeQue2;
@property (nonatomic, strong) NSString *placeLogo;
@property (nonatomic, strong) NSString *placeMessage;
@property (nonatomic, strong) NSString *placeRating;
@property (nonatomic, strong) NSMutableArray *placeCommentRatingArray;
@property (nonatomic, strong) NSMutableArray *placeCommentArray;

@end
