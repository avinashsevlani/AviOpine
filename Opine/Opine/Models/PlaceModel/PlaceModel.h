//
//  PlaceModel.h
//  Opine
//
//  Created by MoonRose Infotech on 19/11/14.
//  Copyright (c) 2014 MoonRose Infotech All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlaceModel : NSObject

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
@property double placeRating;
@property (nonatomic, strong) NSString *placeLongitude;
@property (nonatomic, strong) NSString *placeLatitude;


@end
