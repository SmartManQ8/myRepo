//
//  JSONToArray.m
//  JSON Parse And Display Core Data Example
//
//  Created by Don Larson on 8/27/12.
//  Copyright (c) 2012 Newbound, Inc. All rights reserved.
//

// When 'json_test_data.txt' is on web server
#define kNBRemoteURL [NSURL URLWithString: @"https://s3.amazonaws.com/ios_tutorials/json_parse_and_display_example/json_test_data.txt"]


#import "JSONToArray.h"

@implementation JSONToArray

// For Apps
@synthesize appId = _appId;
@synthesize name = _name;
@synthesize img = _img;
@synthesize description = _description;
@synthesize detailAppImageIcon = _detailAppImageIcon;


// For ListApps
@synthesize commandAppID = _commandAppID;
@synthesize commandID = _commandID;
@synthesize commandName = _commandName;
@synthesize commandDescription = _commandDescription;
@synthesize parameters = _parameters;


// For ListAppParameters
@synthesize commandAppParameterID = _commandAppParameterID;
@synthesize commandAppParameterName = _commandAppParameterName;
@synthesize commandAppParameterDescription =_commandAppParameterDescription;

#pragma mark - Alert Method

+ (void)showNetworkError:(NSString *)theMessage
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Whoops..."
                              message:theMessage
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    
    [alertView show];
}

#pragma mark - JSON Methods

+ (NSArray*)retrieveJSONItems {
    
    
    NSError *err = nil;
    id resultObject = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:kNBRemoteURL]
                                                      options:kNilOptions
                                                        error:&err];
    
    if (resultObject == nil) {
            NSLog(@"resultObject Error: %@", err);
            [self showNetworkError:@"There was an error retrieving the JSON Data."];
            return nil;
    }
    
    if (![resultObject isKindOfClass:[NSDictionary class]]) {
            NSLog(@"JSON Error: Expected dictionary");
            [self showNetworkError:@"A dictionary was expected in the JSON Data."];
            return nil;
    }
    // NSLog(@"Received JSON dictionary '%@'", resultObject);
    
    
    NSArray *tempJSONData = [resultObject objectForKey:@"data"];
    if (tempJSONData == nil) {
            NSLog(@"Expected 'data' array");
            [self showNetworkError:@"An 'array' object was expected."];
        return nil;
    }
    
    // NSLog(@"tempJSONData is: %@", tempJSONData);
    return tempJSONData;
}

@end