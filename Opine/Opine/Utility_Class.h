//
//  Utility_Class.h
//  Opine
//
//  Created by apple on 02/01/15.
//  Copyright (c) 2015 TheAppGururz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility_Class : NSObject

+(NSString *) get_unique_Number;

// Post wervice
+(NSDictionary *) Request_service_get_response_in_Post : (NSDictionary *) parametrs_text  : (NSString *) urk_string;

// get service
+(NSDictionary *) Get_method_Service : (NSString *) strurl;
@end
