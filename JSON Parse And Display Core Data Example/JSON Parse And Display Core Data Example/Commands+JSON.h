//
//  ListApps+JSON.h
//  JSON Parse And Display Core Data Example
//
//  Created by Don Larson on 8/27/12.
//  Copyright (c) 2012 Newbound, Inc. All rights reserved.
//

#import "Commands.h"

@interface Commands (JSON)

+ (Commands *)commandAppsWithJSONInfo:(NSDictionary *) nbJSONListAppsInfo
                             appID:(NSString *) newAppID
            inManagedObjectContext:(NSManagedObjectContext *)context;

+ (Commands *)commandAppsWithID:(NSString *)newID
      inManagedObjectContext:(NSManagedObjectContext *)context;

@end
