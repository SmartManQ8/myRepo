//
//  DetailViewController.h
//  JSON Parse And Display Core Data Example
//
//  Created by Don Larson on 8/27/12.
//  Copyright (c) 2012 Newbound, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

// For 'App' IBOutlets
@property (strong, nonatomic) IBOutlet UILabel *detailNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *detailImageIconItem;


// For 'Command' IBOutlets
@property (weak, nonatomic) IBOutlet UILabel *commandDetailNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commandDetailDescriptionLabel;


// For 'Parameter' IBOutlets
@property (weak, nonatomic) IBOutlet UILabel *parameter1NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *parameter2NameLabel;

@end
