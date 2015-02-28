//
//  KeystoneMapAnnotation.h
//  Keystone
//
//  Created by MoonRose Infotech on 23/04/12.
//  Copyright (c) 2012 Jeff Krueger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface KeystoneMapAnnotation : NSObject<MKAnnotation>
{
    CLLocationCoordinate2D coordinate;
    NSString *title, *subtitle1;
    int yTag;
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title, *subtitle;
@property (nonatomic, readwrite) int yTag;

- (id)initWithCoordinate:(CLLocationCoordinate2D) inCoordinate;

@end