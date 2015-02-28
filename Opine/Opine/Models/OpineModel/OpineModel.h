//
//  OpineModel.h
//  Opine
//
//  Created by MoonRose Infotech on 21/11/14.
//  Copyright (c) 2014 MoonRose Infotech All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface OpineModel : NSObject

+ (BOOL) validateEmail: (NSString *) candidate;
+ (void) zoomToFitMapAnnotations: (MKMapView *)mapView;
+ (BOOL) checkIsEmpty:(NSString *) s;

@end
