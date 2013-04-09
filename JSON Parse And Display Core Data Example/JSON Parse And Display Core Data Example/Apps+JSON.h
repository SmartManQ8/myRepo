//
//  Apps+JSON.h
//  JSON Parse And Display Core Data Example
//
//  Created by Don Larson on 8/27/12.
//  Copyright (c) 2012 Newbound, Inc. All rights reserved.
//

#import "Apps.h"

@interface Apps (JSON)

+ (Apps *)appsWithJSONInfo:(NSDictionary *) nbJSONInfo
    inManagedObjectContext:(NSManagedObjectContext *)context;

+ (Apps *)appsWithID:(NSString *)newID
inManagedObjectContext:(NSManagedObjectContext *)context;

@end
