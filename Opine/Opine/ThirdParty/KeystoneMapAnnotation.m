//
//  KeystoneMapAnnotation.m
//  Keystone
//
//  Created by MoonRose Infotech on 23/04/12.
//  Copyright (c) 2012 Jeff Krueger. All rights reserved.
//

#import "KeystoneMapAnnotation.h"

@implementation KeystoneMapAnnotation

@synthesize coordinate, title, subtitle, yTag;

- (id)initWithCoordinate:(CLLocationCoordinate2D) inCoordinate {
    coordinate = inCoordinate;
    return self;
}

@end