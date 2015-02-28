//
//  RateCommentModel.h
//  Opine
//
//  Created by MoonRose Infotech on 26/11/14.
//  Copyright (c) 2014 MoonRose Infotech All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RateCommentModel : NSObject

@property (nonatomic, strong) NSString *commentUserSessionID;
@property (nonatomic, strong) NSString *commentTitle;
@property (nonatomic, strong) NSString *commentText;
@property (nonatomic, strong) NSString *commentRateOverAll;
@property (nonatomic, strong) NSString *commentRateService;
@property (nonatomic, strong) NSString *commentRateLocation;
@property (nonatomic, strong) NSString *commentRateFood;
@property (nonatomic, strong) NSString *commentPlaceID;
@property (nonatomic, strong) NSString *commentRepeat;

@end
