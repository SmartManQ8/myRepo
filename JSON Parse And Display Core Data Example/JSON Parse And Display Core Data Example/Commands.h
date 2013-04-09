//
//  Commands.h
//  JSON Parse And Display Core Data Example
//
//  Created by Don Larson on 8/27/12.
//  Copyright (c) 2012 Newbound, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Apps, Parameters;

@interface Commands : NSManagedObject

@property (nonatomic, retain) NSString * commandDescription;
@property (nonatomic, retain) NSString * commandID;
@property (nonatomic, retain) NSString * commandName;
@property (nonatomic, retain) NSString * commandAppID;
@property (nonatomic, retain) NSSet *commandAppToParameters;
@property (nonatomic, retain) Apps *commandToApps;
@end

@interface Commands (CoreDataGeneratedAccessors)

- (void)addCommandAppToParametersObject:(Parameters *)value;
- (void)removeCommandAppToParametersObject:(Parameters *)value;
- (void)addCommandAppToParameters:(NSSet *)values;
- (void)removeCommandAppToParameters:(NSSet *)values;

@end
