//
//  MasterViewController.m
//  JSON Parse And Display Core Data Example
//
//  Created by Don Larson on 8/27/12.
//  Copyright (c) 2012 Newbound, Inc. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "JSONToArray.h"
#import "Apps+JSON.h"
#import "Commands+JSON.h"
#import "Parameters+JSON.h"

// Discovered this ActionBlock technique from a paid lesson from http://nsscreencast.com
typedef void (^ActionBlock)();

@interface MasterViewController ()

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

@implementation MasterViewController

@synthesize myGradient = _myGradient;


#pragma Uncatorgorized methods

- (void)awakeFromNib
{
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    [super awakeFromNib];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}


#pragma Animation methods

// Discovered this animation technique from a paid lesson from http://nsscreencast.com
- (void)scaleImageTo:(CGFloat)scale completion:(ActionBlock)completion {
    CGFloat duration = 0.25f;
    [UIView animateWithDuration:duration animations:^{
        self.detailViewController.detailImageIconItem.transform = CGAffineTransformMakeScale(scale, scale);
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

- (void)bounceImage {
    [self scaleImageTo:1.1 completion:^{
        [self scaleImageTo:0.9 completion:^{
            [self scaleImageTo:1.0 completion:nil];
        }];
    }];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // self.navigationItem.leftBarButtonItem = self.editButtonItem;

    // UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    // self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    self.myGradient = [UIImage imageNamed:@"newbound_logo_text_color.png"];

    // First delete any records already in database to avoid duplicates.
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Apps"];
    
    NSError *error = nil;
    NSArray *matches = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    for (id myObject in matches) {
        [self.managedObjectContext deleteObject:myObject];
    }
    
    // Now setup fetchedResultsController
    [self fetchedResultsController];
    
    // Now load in the json data into Core Data database
    [self fetchJSONDataIntoDocument:self.managedObjectContext];
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Use this statement below to force landscape orientation and then also comment out the following line, "return YES;"
    // return UIInterfaceOrientationIsLandscape(UIInterfaceOrientationLandscapeRight);
    return YES;
}


#pragma mark - Table View

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)table {
    // return list of section titles to display in section index view (e.g. "ABCD...Z#")
    
    // Use the 'return' statement below if you want an index to appear in 'Group Style'
    // return [self.fetchedResultsController sectionIndexTitles];
    
    // Don't use the 'return' statement below if you want an index to appear in 'Group Style'
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0; // set to '1' or more if using images in row
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    id <NSFetchedResultsSectionInfo> theSection = [[self.fetchedResultsController sections] objectAtIndex:section];
    NSInteger count = [theSection numberOfObjects];
    NSString *mySectionName;
    
    if (count == 0 || count >1) {
        mySectionName = [NSString stringWithFormat:@"%@\nhas %d Commands", [theSection name], [theSection numberOfObjects]];
    } else {
        mySectionName = [NSString stringWithFormat:@"%@\nhas %d Command", [theSection name], [theSection numberOfObjects]];
    }
    
    
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40)];

    UIColor *myHeaderInSectionBackgroundColor = [UIColor colorWithRed:0.863f green:0.875f blue:0.898f alpha:1.0f];
	customView.backgroundColor = myHeaderInSectionBackgroundColor;
    
    [self.view addSubview:customView];
    
    // Build Header Label
    UILabel *mySectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(45,0,275,20)]; // x, y, width, height
    mySectionLabel.font = [UIFont boldSystemFontOfSize:17];
    mySectionLabel.textColor   = [UIColor blueColor];
    mySectionLabel.backgroundColor = [UIColor clearColor];
    mySectionLabel.text = mySectionName;
    mySectionLabel.numberOfLines = 0;
    mySectionLabel.adjustsFontSizeToFitWidth = YES;
    [mySectionLabel sizeToFit];
    [customView addSubview:mySectionLabel];
    
    // Display image in header cell
    NSIndexPath *myIndexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    Commands *commands = [self.fetchedResultsController objectAtIndexPath:myIndexPath];
    UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfFile:commands.commandToApps.img]];
    // NSLog(@"'NSString' 'commands.commandToApps.img' is '%@'", commands.commandToApps.img);
    if (!image) {
        image =[UIImage imageNamed:@"newbound_logo.png"];
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, 0, 40, 40);
    [customView addSubview:imageView];
    
    
    [self.tableView reloadData];
    
    return customView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell"; // <-- Make sure this matches what you have in the storyboard
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    
    // Configure the cell.
	[self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }   
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)tableView:(UITableView *)sender didSelectRowAtIndexPath:(NSIndexPath *)path {
    
    // For 'App' properties
    Commands *commands = [self.fetchedResultsController objectAtIndexPath:path];
    
    self.detailViewController.detailNameLabel.text = commands.commandToApps.name;
    self.detailViewController.detailDescriptionLabel.text = commands.commandToApps.detailDescription;
    
    UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfFile:commands.commandToApps.img]];
    // NSLog(@"'NSString' 'commands.commandToApps.img' is '%@'", commands.commandToApps.img);
    if (!image) {
        image =[UIImage imageNamed:@"newbound_logo.png"];
    }
    
    self.detailViewController.detailImageIconItem.image = image;
    
    // Discovered this animation technique from a paid lesson from http://nsscreencast.com
    [UIView animateWithDuration:0.5 animations:^{
        self.detailViewController.detailImageIconItem.alpha = 1;
    }];
    [self bounceImage];
    
    
    // For 'Command' properties
    self.detailViewController.commandDetailNameLabel.text = commands.commandName;
    self.detailViewController.commandDetailDescriptionLabel.text = commands.commandDescription;
    
    
    // For Parameter properties
    NSInteger parameterCount = [commands.commandAppToParameters count];
    
    
    // Fill parameters
    NSSet *myCommandAndLinkedParameters = commands.commandAppToParameters;
    NSArray *myCommandAndLinkedParameterObjects = [myCommandAndLinkedParameters allObjects];
    
    // Sorting the Parameter array
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"commandAppParameterName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
    NSArray *parameterSortedArray = [myCommandAndLinkedParameterObjects sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    // This display of the parameters could be more elegant. See another of my tutorials as a possible approach icorporating the idea at the link below
    // http://timeoutofmind.com/wordpress/2012/04/13/xcode_4_3_and_ios_5_dynamic_uilabels_and_uitextfields_example/
    self.detailViewController.parameter1NameLabel.text = nil;
    self.detailViewController.parameter2NameLabel.text = nil;
    switch(parameterCount)
    {
        case 0: // No parameters
            break;
        case 1: // One parameter
            self.detailViewController.parameter1NameLabel.text = [[parameterSortedArray objectAtIndex:0] valueForKey:@"commandAppParameterName"];
            break;
        case 2: // Two parameters
            self.detailViewController.parameter1NameLabel.text = [[parameterSortedArray objectAtIndex:0] valueForKey:@"commandAppParameterName"];
            self.detailViewController.parameter2NameLabel.text = [[parameterSortedArray objectAtIndex:1] valueForKey:@"commandAppParameterName"];
            break;
        default: // Error! More than two parameters
            self.detailViewController.parameter1NameLabel.text = @"Error too many parameters";
            break;
    }
    
}


#pragma UItextView Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController // attaches an NSFetchRequest to this UITableViewController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Commands"];
    [fetchRequest setIncludesSubentities:YES];
    
    // Sort by Application name
    NSSortDescriptor* sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"commandToApps.name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
    //Sort by CommandName
    NSSortDescriptor* sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"commandName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
    NSArray* sortDescriptors = [[NSArray alloc] initWithObjects: sortDescriptor1, sortDescriptor2, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    [fetchRequest setFetchBatchSize:25];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"commandToApps.name" cacheName:@"JSON_Parse_And_Display_Core_Data_Example_Cache"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
    
}

- (void)fetchJSONDataIntoDocument:(NSManagedObjectContext *)managedObjectContext
{
    
    // Retrieve the JSON data at the designated URL
    NSArray * tempArray = [JSONToArray retrieveJSONItems];
    // int FirstNumberOfObjects = [tempArray count];
    // NSLog(@"First Count of 'tempArray' is '%@'", [NSString stringWithFormat:@"%d",FirstNumberOfObjects]);
    
    
    // First, parse the topmost level of JSON for the list of Apps
    for (NSDictionary *JSONInfo in tempArray) {
        // int SecondNumberOfObjects = [tempArray count];
        // NSLog(@"Second Count of 'tempArray' is '%@'", [NSString stringWithFormat:@"%d",SecondNumberOfObjects]);
        // NSLog(@"'JSONInfo' is '%@'", JSONInfo);
        [Apps appsWithJSONInfo:JSONInfo inManagedObjectContext:managedObjectContext];
        
        
        
        // Second, parse the next level of JSON for the list of Commands
        NSString * theCurrentAppID = [JSONInfo objectForKey:@"id"];
        NSArray * commandsTempArray = [JSONInfo objectForKey:@"commands"];
        // NSLog(@"NSArray 'commandsTempArray'  count is: %d", [commandsTempArray count]);
        // NSLog(@"NSArray 'commandsTempArray' is: %@", commandsTempArray);
        // if ([commandsTempArray count] == 0) NSLog(@"NSString 'theCurrentAppID' item is: %@\n, commandsTempArray 'count' is: %d\n\n", theCurrentAppID, [commandsTempArray count]);
        
        for (NSDictionary *JSONCommandApps in commandsTempArray) {
            // NSLog(@"NSString 'theCurrentAppID' item is: %@\n, commandsTempArray 'count' is: %d\n\n", theCurrentAppID, [commandsTempArray count]);
            [Commands commandAppsWithJSONInfo:JSONCommandApps
                                     appID: theCurrentAppID
                    inManagedObjectContext:managedObjectContext];
            
            
            // Third, parse the next level of JSON for the Paramters
            NSString * theCurrentCommandAppID = [JSONCommandApps objectForKey:@"id"];
            // NSString * theCurrentCommandAppID = [JSONCommandApps objectForKey:@"name"];
            NSArray * parametersTempArray = [JSONCommandApps objectForKey:@"parameters"];
            // NSLog(@"+++++++++\nNSArray 'parametersTempArray'  count is: %d", [commandsTempArray count]);
            for (NSDictionary *JSONParameters in parametersTempArray) {
                
                [Parameters ParametersWithJSONInfo:JSONParameters
                                                       listAppID:(NSString *) theCurrentCommandAppID
                                          inManagedObjectContext:managedObjectContext];
            } // end third level 'for loop'
            
        } // end second level 'for loop'        
        
    }
    
    // Save the context.
    NSError *error = nil;
    if (![managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
}



- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Commands *commands = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSInteger parameterCount = [commands.commandAppToParameters count];
    NSString *parameterCountString = [NSString stringWithFormat:@"%d", parameterCount];
    NSString * parameterCountString2 = @" Parameters";
    NSString * parameterCountString3 = @" Parameter";
    switch(parameterCount)
    {
        case 0: // No parameters
            parameterCountString = [parameterCountString stringByAppendingString: parameterCountString2];
            break;
        case 1: // One parameter
            // NSString *parameterName = [myCommandAndLinkedParameters lastObject];
            parameterCountString = [parameterCountString stringByAppendingString: parameterCountString3];
            break;
        default: // 2 or more parameters
            parameterCountString = [parameterCountString stringByAppendingString: parameterCountString2];
            // NSLog(@"Final 'parameterCountString' is: %@", parameterCountString);
            break;
    }
    
    // Then configure the cell using it ...
    cell.textLabel.text = commands.commandName;
    cell.textLabel.textColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:0.5f green:0.85f blue:0.9f alpha:1.0f];
    cell.detailTextLabel.text = parameterCountString;

}

@end
