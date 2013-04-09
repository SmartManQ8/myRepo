//
//  ListApps+JSON.m
//  JSON Parse And Display Core Data Example
//
//  Created by Don Larson on 8/27/12.
//  Copyright (c) 2012 Newbound, Inc. All rights reserved.
//

#import "Apps+JSON.h"
#import "Commands+JSON.h"
#import "JSONToArray.h"

@implementation Commands (JSON)

+ (Commands *)commandAppsWithJSONInfo:(NSDictionary *) nbJSONListAppsInfo
                             appID:(NSString *) newAppID
            inManagedObjectContext:(NSManagedObjectContext *)context {
    
    Commands *commands = nil;
        
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Commands"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"commandAppID = %@", [nbJSONListAppsInfo objectForKey:newAppID]];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"commandName" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];

    commands = [NSEntityDescription insertNewObjectForEntityForName:@"Commands" inManagedObjectContext:context];
    commands.commandAppID = NSLocalizedString(newAppID, nil);
    commands.commandID = NSLocalizedString([nbJSONListAppsInfo objectForKey:JSON_COMMANDID], nil);
    commands.commandName = NSLocalizedString([nbJSONListAppsInfo objectForKey:JSON_COMMANDNAME], nil);
    commands.commandDescription = NSLocalizedString([nbJSONListAppsInfo objectForKey:JSON_COMMANDDESCRIPTION], nil);

    commands.commandToApps = [Apps appsWithID:newAppID inManagedObjectContext:context];
    
    return commands;
}

+ (Commands *)commandAppsWithID:(NSString *)newID
inManagedObjectContext:(NSManagedObjectContext *)context
{
    Commands *command = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Commands"];
    request.predicate = [NSPredicate predicateWithFormat:@"commandID = %@", newID];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"commandName" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *commands = [context executeFetchRequest:request error:&error];
    
    if ([commands count] == 0) {
        command = [NSEntityDescription insertNewObjectForEntityForName:@"Commands"
                                            inManagedObjectContext:context];
        command.commandID = NSLocalizedString(newID, nil);
    } else if ([commands count] >=1) {
        command = [commands lastObject];
    }
    
    return command;
}

@end
