//
//  Parameters+JSON.m
//  JSON Parse And Display Core Data Example
//
//  Created by Don Larson on 8/27/12.
//  Copyright (c) 2012 Newbound, Inc. All rights reserved.
//

#import "Commands+JSON.h"
#import "Parameters+JSON.h"
#import "JSONToArray.h"

@implementation Parameters (JSON)

+ (Parameters *)ParametersWithJSONInfo:(NSDictionary *) nbJSONCommandParameters
                                           listAppID:(NSString *) newCommandAppID
                              inManagedObjectContext:(NSManagedObjectContext *)context {

    Parameters *parameters = nil;

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Parameters"];
    request.predicate = [NSPredicate predicateWithFormat:@"commandAppParameterID = %@", newCommandAppID];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"commandAppParameterName" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];

    parameters = [NSEntityDescription insertNewObjectForEntityForName:@"Parameters" inManagedObjectContext:context];
    parameters.commandAppParameterID = NSLocalizedString(newCommandAppID, nil);
    parameters.commandAppParameterName = NSLocalizedString([nbJSONCommandParameters objectForKey:JSON_COMMANDAPPPARAMETERNAME], nil);
    parameters.commandAppParameterDescription = NSLocalizedString([nbJSONCommandParameters objectForKey:JSON_COMMANDAPPPARAMETERDESCRIPTION], nil);
    
    parameters.parametersToCommandApps = [Commands commandAppsWithID:newCommandAppID inManagedObjectContext:context];

    return parameters;
}

@end
