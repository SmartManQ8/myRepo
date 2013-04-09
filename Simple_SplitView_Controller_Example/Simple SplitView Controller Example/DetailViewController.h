//
//  DetailViewController.h
//  Simple SplitView Controller Example
//
//  Created by Donald Larson on 1/23/12.
//  Copyright (c) 2012 Newbound, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
