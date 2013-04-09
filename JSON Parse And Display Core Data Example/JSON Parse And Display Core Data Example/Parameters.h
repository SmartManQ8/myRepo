//
//  Parameters.h
//  JSON Parse And Display Core Data Example
//
//  Created by Don Larson on 8/27/12.
//  Copyright (c) 2012 Newbound, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Commands;

@interface Parameters : NSManagedObject

@property (nonatomic, retain) NSString * commandAppParameterDescription;
@property (nonatomic, retain) NSString * commandAppParameterID;
@property (nonatomic, retain) NSString * commandAppParameterName;
@property (nonatomic, retain) Commands *parametersToCommandApps;

@end
