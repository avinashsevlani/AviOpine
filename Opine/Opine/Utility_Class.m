////
//  Utility_Class.m
//  Opine
//
//  Created by apple on 02/01/15.
//  Copyright (c) 2015 TheAppGururz. All rights reserved.
//

#import "Utility_Class.h"

@implementation Utility_Class


#pragma mark - get unique number
+(NSString *) get_unique_Number
{
    NSMutableArray *uniqueNumbers = [[NSMutableArray alloc] init];
    int r;
    while ([uniqueNumbers count] < 5) {
        r = arc4random();
        if (![uniqueNumbers containsObject:[NSNumber numberWithInt:r]]) {
            [uniqueNumbers addObject:[NSNumber numberWithInt:r]];
        }
    }
    NSString *str = [NSString stringWithFormat:@"%@", uniqueNumbers[0]];
    str = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return str;
}

#pragma mark - post_service delegate
+(NSDictionary *) Request_service_get_response_in_Post : (NSDictionary *) parametrs_text  : (NSString *) urk_string
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", urk_string]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"0xKhTmLbOuNdArY";
    NSString *kNewLine = @"\r\n";
    
    // Note that setValue is used so as to override any existing Content-Type header.
    // addValue appends to the Content-Type header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    // Add the parameters from the dictionary to the request body
    for (NSString *name in parametrs_text.allKeys)
    {
        NSData *value = [[NSString stringWithFormat:@"%@", parametrs_text[name]] dataUsingEncoding:NSUTF8StringEncoding];
        
        [body appendData:[[NSString stringWithFormat:@"--%@%@", boundary, kNewLine] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"", name] dataUsingEncoding:NSUTF8StringEncoding]];
        // For simple data types, such as text or numbers, there's no need to set the content type
        [body appendData:[[NSString stringWithFormat:@"%@%@", kNewLine, kNewLine] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:value];
        [body appendData:[kNewLine dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    // Add the terminating boundary marker to signal that we're at the end of the request body
    [body appendData:[[NSString stringWithFormat:@"--%@--", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    NSError *error;
    [request setHTTPBody:body];
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary * dic1;
    if (returnData!=nil)
    {
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", returnString);
        dic1 = [NSJSONSerialization JSONObjectWithData:returnData options:kNilOptions error:&error];
    }
    return dic1;
}

#pragma mark - get method service
+(NSDictionary *) Get_method_Service : (NSString *) strurl
{
    NSError *error;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", strurl]];
    NSDictionary *Get_Response ;
    if (url!=nil)
    {
        NSData *Get_data = [NSData dataWithContentsOfURL:url options:kNilOptions error:&error];
        if (Get_data!= nil)
        {
            Get_Response = [NSJSONSerialization JSONObjectWithData:Get_data
                                                           options:0
                                                             error:NULL];
        }
    }
    return Get_Response;
}
@end
