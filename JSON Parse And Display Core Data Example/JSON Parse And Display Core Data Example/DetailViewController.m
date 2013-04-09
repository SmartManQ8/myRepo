//
//  DetailViewController.m
//  JSON Parse And Display Core Data Example
//
//  Created by Don Larson on 8/27/12.
//  Copyright (c) 2012 Newbound, Inc. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

@synthesize masterPopoverController = _masterPopoverController;

// For 'App' IBOutlets
@synthesize detailNameLabel = _detailNameLabel;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;
@synthesize detailImageIconItem = _detailImageIconItem;


// For 'Command' IBOutlets
@synthesize commandDetailNameLabel = _commandDetailNameLabel;
@synthesize commandDetailDescriptionLabel = _commandDetailDescriptionLabel;


// For 'Parameter' IBOutlets
@synthesize parameter1NameLabel = _parameter1NameLabel;
@synthesize parameter2NameLabel = _parameter2NameLabel;


#pragma mark - Managing the detail item

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}

- (void)setDetailNameLabel:(id)newDetailNameLabel
{
    if (_detailNameLabel != newDetailNameLabel) {
        _detailNameLabel = newDetailNameLabel;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)setDetailImageIconItem:(id)newDetailImageIconItem
{
    if (_detailImageIconItem != newDetailImageIconItem) {
        _detailImageIconItem = newDetailImageIconItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
