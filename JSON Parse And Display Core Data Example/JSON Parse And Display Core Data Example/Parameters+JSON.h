//
//  Parameters+JSON.h
//  JSON Parse And Display Core Data Example
//
//  Created by Don Larson on 8/27/12.
//  Copyright (c) 2012 Newbound, Inc. All rights reserved.
//

#import "Parameters.h"

@interface Parameters (JSON)

+ (Parameters *)ParametersWithJSONInfo:(NSDictionary *) nbJSONCommandParameters
                                           listAppID:(NSString *) newCommandAppID
                              inManagedObjectContext:(NSManagedObjectContext *)context;

@end
