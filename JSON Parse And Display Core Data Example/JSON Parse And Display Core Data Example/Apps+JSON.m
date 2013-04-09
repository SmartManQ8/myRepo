//
//  Apps+JSON.m
//  JSON Parse And Display Core Data Example
//
//  Created by Don Larson on 8/27/12.
//  Copyright (c) 2012 Newbound, Inc. All rights reserved.
//

// When 'icon images folder' is on web server
#define kNBSmall140ImageURL (NSString *) @"https://s3.amazonaws.com/ios_tutorials/json_parse_and_display_example/icon_images/"


#import "Apps+JSON.h"
#import "JSONToArray.h"

@implementation Apps (JSON)

+ (Apps *)appsWithJSONInfo:(NSDictionary *) nbJSONInfo
    inManagedObjectContext:(NSManagedObjectContext *)context {
    
    Apps *apps = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Apps"];
    request.predicate = [NSPredicate predicateWithFormat:@"appID = %@", [nbJSONInfo objectForKey:JSON_ID]];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1)) {
        [JSONToArray showNetworkError:@"There was an error retrieving the Apps Data."];
    } else if ([matches count] == 0) {
        apps = [NSEntityDescription insertNewObjectForEntityForName:@"Apps" inManagedObjectContext:context];
        apps.appID = NSLocalizedString([nbJSONInfo objectForKey:JSON_ID], nil);
        apps.name = NSLocalizedString([nbJSONInfo objectForKey:JSON_NAME], nil);
        apps.img = NSLocalizedString([nbJSONInfo objectForKey:JSON_IMG], nil);
        apps.detailDescription = NSLocalizedString([nbJSONInfo objectForKey:JSON_DESCRIPTION], nil);
        
        
        NSString *myTempString = kNBSmall140ImageURL;
        myTempString = [myTempString stringByAppendingString:apps.img];
        NSURL *url = [NSURL URLWithString:myTempString];    
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        path = [path stringByAppendingPathComponent:@"/Icon Images/"];
        
        // http://www.ios-developer.net/iphone-ipad-programmer/development/file-saving-and-loading/using-the-document-directory-to-store-files
        NSError *error;
        if (![[NSFileManager defaultManager] fileExistsAtPath:path]) // Does directory already exist?
        {
            if (![[NSFileManager defaultManager] createDirectoryAtPath:path
                                           withIntermediateDirectories:NO
                                                            attributes:nil
                                                                 error:&error])
            {
                [JSONToArray showNetworkError:@"There was an error creating the icon folder."];
                // NSLog(@"Create directory error: %@", error);
            }
        }
    
        path = [path stringByAppendingPathComponent:apps.img];
        if (![[NSFileManager defaultManager] fileExistsAtPath:path]) // Does image file already exist?
        {
            [data writeToFile:path atomically:YES]; // Write the icon image file to "Documents/Icon Images" directory
        }
        // NSLog(@"'path' is %@", path);
    
        apps.img = path;
        // NSLog(@"'apps.img' is %@", apps.img);
        
    } else {
        apps = [matches lastObject];
    }
    
    return apps;
}

+ (Apps *)appsWithID:(NSString *)newID
                inManagedObjectContext:(NSManagedObjectContext *)context
{
    Apps *app = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Apps"];
    request.predicate = [NSPredicate predicateWithFormat:@"appID = %@", newID];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *apps = [context executeFetchRequest:request error:&error];
    
    if ([apps count] == 0) {
        app = [NSEntityDescription insertNewObjectForEntityForName:@"Apps"
                                            inManagedObjectContext:context];
        app.appID = NSLocalizedString(newID, nil);
    } else if ([apps count] >=1) {   
        app = [apps lastObject];
    }
    
    
    // NSLog(@"Apps+JSON.m 'return app' item is: %@\n^^^^^^^^^^\n\n", app);
    return app;
}


@end
