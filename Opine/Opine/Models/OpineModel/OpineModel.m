//
//  OpineModel.m
//  Opine
//
//  Created by MoonRose Infotech on 21/11/14.
//  Copyright (c) 2014 MoonRose Infotech All rights reserved.
//

#import "OpineModel.h"
#import "KeystoneMapAnnotation.h"

@implementation OpineModel

+ (BOOL) validateEmail: (NSString *) candidate
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}

+ (void)zoomToFitMapAnnotations:(MKMapView *)mapView
{
    if([mapView.annotations count] == 0)
        return;
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for(KeystoneMapAnnotation* annotation in mapView.annotations)
    {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    
    if([mapView.annotations count] == 1) {
        region.span.latitudeDelta = topLeftCoord.latitude/2000; // Add a little extra space on the sides
        region.span.longitudeDelta = bottomRightCoord.longitude/2000; // Add a little extra space on the sides
    } else {
        region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 2.5;
        region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 2.5;
    }
    if (region.span.longitudeDelta < 0) {
        region.span.longitudeDelta = 0.01;
    }
    region = [mapView regionThatFits:region];
    [mapView setRegion:region animated:YES];
}

+ (NSString *) myTrim:(NSString *) string { return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; }

+ (BOOL) checkIsEmpty:(NSString *) s
{
    if ([s isEqual:[NSNull null]]) return YES;
    s = [self myTrim:[NSString stringWithFormat:@"%@",s]];
    if([s isEqualToString:@"(null)"]) s = @"";
    return ([s isEqualToString:@""])?YES:NO;
}

@end
