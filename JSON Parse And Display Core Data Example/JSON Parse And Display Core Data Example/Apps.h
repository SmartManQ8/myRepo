//
//  Apps.h
//  JSON Parse And Display Core Data Example
//
//  Created by Don Larson on 8/27/12.
//  Copyright (c) 2012 Newbound, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Commands;

@interface Apps : NSManagedObject

@property (nonatomic, retain) NSString * detailDescription;
@property (nonatomic, retain) NSString * img;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * appID;
@property (nonatomic, retain) NSSet *appsToCommands;
@end

@interface Apps (CoreDataGeneratedAccessors)

- (void)addAppsToCommandsObject:(Commands *)value;
- (void)removeAppsToCommandsObject:(Commands *)value;
- (void)addAppsToCommands:(NSSet *)values;
- (void)removeAppsToCommands:(NSSet *)values;

@end
