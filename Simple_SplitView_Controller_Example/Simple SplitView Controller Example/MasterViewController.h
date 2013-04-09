//
//  MasterViewController.h
//  Simple SplitView Controller Example
//
//  Created by Donald Larson on 1/23/12.
//  Copyright (c) 2012 Newbound, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;
// Added this statement below
@property (strong, nonatomic) NSArray *items; // Row values for tableView

@end
