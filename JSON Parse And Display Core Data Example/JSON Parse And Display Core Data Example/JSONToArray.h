//
//  JSONToArray.h
//  JSON Parse And Display Core Data Example
//
//  Created by Don Larson on 8/27/12.
//  Copyright (c) 2012 Newbound, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

// For Apps
#define JSON_DESCRIPTION @"description"
#define JSON_NAME @"name"
#define JSON_ID @"id"
#define JSON_IMG @"img"
#define JSON_IMAGEICON @"detailImageIcon"

// For ListApps
// #define JSON_LISTAPPID @"???"
#define JSON_COMMANDID @"id"
#define JSON_COMMANDNAME @"name"
#define JSON_COMMANDDESCRIPTION @"description"
// #define JSON_PARAMETERS @"parameters"

// For ListAppParameters
#define JSON_COMMANDAPPPARAMETERID @"commandAppParameterID"
#define JSON_COMMANDAPPPARAMETERNAME @"name"
#define JSON_COMMANDAPPPARAMETERDESCRIPTION @"description"

@interface JSONToArray : NSObject

// For Apps
@property (nonatomic, copy) NSString *appId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, strong) UIImageView *detailAppImageIcon;


// For ListApps
@property (nonatomic, copy) NSString *commandAppID;
@property (nonatomic, copy) NSString *commandID;
@property (nonatomic, copy) NSString *commandName;
@property (nonatomic, copy) NSString *commandDescription;
@property (nonatomic, copy) NSString *parameters;


// For ListAppParameters
@property (nonatomic, copy) NSString *commandAppParameterID;
@property (nonatomic, copy) NSString *commandAppParameterName;
@property (nonatomic, copy) NSString *commandAppParameterDescription;

+ (void)showNetworkError:(NSString *)theMessage;
+ (NSArray*)retrieveJSONItems;

@end