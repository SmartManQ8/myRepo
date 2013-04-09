/*
     File: DetailViewController.m
 Abstract: 
	Displays the detail view of the split view controller. This also contains buttons and a bar button item that all present popovers.
	The detail view responds to orientation changes when popovers are visible and re-displays them in the new orientation.
	The detail view is also responsible for ensuring that there are never multiple popovers visible at the same time.
 
  Version: 1.1
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2012 Apple Inc. All Rights Reserved.
 
 */

#import "DetailViewController.h"
#import "RootViewController.h"
#import "PopoverContentViewController.h"

@interface DetailViewController ()

@property (nonatomic, weak) IBOutlet UIToolbar *toolbar;
@property (nonatomic, strong) id detailItem;
@property (nonatomic, strong) UIPopoverController *detailViewPopover;
@property (nonatomic, strong) UIPopoverController *barButtonItemPopover;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *myBarButtonItem;
@property (nonatomic, weak) IBOutlet UIButton *button1;
@property (nonatomic, weak) IBOutlet UIButton *button2;
@property (nonatomic, weak) IBOutlet UIButton *button3;
@property (nonatomic, weak) IBOutlet UIButton *button4;
@property (nonatomic, weak) IBOutlet UIButton *button5;
@property (nonatomic, strong) id lastTappedButton;

@property (nonatomic, strong) UIPopoverController *mainPopoverController;

@end


@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)configureView {
    // Update the user interface for the detail item.
}

// When setting the detail item, update the view and dismiss the popover controller if it's showing
- (void)setDetailItem:(id)newDetailItem {
    if (self.detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.mainPopoverController != nil) {
        [self.mainPopoverController dismissPopoverAnimated:YES];
    }        
}


#pragma mark - Split view support

- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
    barButtonItem.title = @"Master List";
    NSMutableArray *items = [[self.toolbar items] mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
    [self.toolbar setItems:items animated:YES];
    self.mainPopoverController = pc;
}

// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {    
    NSMutableArray *items = [[self.toolbar items] mutableCopy];
    [items removeObjectAtIndex:0];
    [self.toolbar setItems:items animated:YES];
    self.mainPopoverController = nil;
}

// Called when the hidden view controller is about to be displayed in a popover.
- (void)splitViewController:(UISplitViewController*)svc popoverController:(UIPopoverController*)pc willPresentViewController:(UIViewController *)aViewController {
	// Check to see if the popover presented from the "Tap" UIBarButtonItem is visible.
	if ([self.barButtonItemPopover isPopoverVisible]) {
		// Dismiss the popover.
        [self.barButtonItemPopover dismissPopoverAnimated:YES];
    } 
}


#pragma mark - Rotation support

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	// If the detail popover is presented, dismiss it.
	if (self.detailViewPopover != nil) {
		[self.detailViewPopover dismissPopoverAnimated:YES];
	}
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	// If the last button tapped is not nil, present the popover from that button.
	if (self.lastTappedButton != nil) {
		[self showPopover:self.lastTappedButton];
	}
}

// Ensure that the view controller supports rotation and that the split view can
// therefore show in both portrait and landscape.
//
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {

    return YES;
}


#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	PopoverContentViewController *content = [[PopoverContentViewController alloc] init];
	
	// Setup the popover for use in the detail view.
	self.detailViewPopover = [[UIPopoverController alloc] initWithContentViewController:content];
	self.detailViewPopover.popoverContentSize = CGSizeMake(320., 320.);
	self.detailViewPopover.delegate = self;
	
	// Setup the popover for use from the navigation bar.
	self.barButtonItemPopover = [[UIPopoverController alloc] initWithContentViewController:content];
	self.barButtonItemPopover.popoverContentSize = CGSizeMake(320., 320.);
	self.barButtonItemPopover.delegate = self;
}


#pragma mark - Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    self.mainPopoverController = nil;
	self.detailViewPopover = nil;
	self.barButtonItemPopover = nil;
	self.button1 = nil;
	self.button2 = nil;
	self.button3 = nil;
	self.button4 = nil;
	self.button5 = nil;
}


#pragma mark - Popover controller delegates

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
	// If a popover is dismissed, set the last button tapped to nil.
	self.lastTappedButton = nil;
}


#pragma mark - DetailViewController methods

- (IBAction)showPopover:(id)sender {
	// Set the sender to a UIButton.
	UIButton *tappedButton = (UIButton *)sender;
	
	// Present the popover from the button that was tapped in the detail view.
	[self.detailViewPopover presentPopoverFromRect:tappedButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

	// Set the last button tapped to the current button that was tapped.
	self.lastTappedButton = sender;
}

- (IBAction)showPopoverFromBarButtonItem:(id)sender {	
	// Set the sender to a UIBarButtonItem.
	UIBarButtonItem *tappedButton = (UIBarButtonItem *)sender;
	
	// If the master list popover is showing, dismiss it before presenting the popover from the bar button item.
	if (self.mainPopoverController != nil) {
        [self.mainPopoverController dismissPopoverAnimated:YES];
    } 
	
	// If the popover is already showing from the bar button item, dismiss it. Otherwise, present it.
	if (self.barButtonItemPopover.popoverVisible == NO) {
		[self.barButtonItemPopover presentPopoverFromBarButtonItem:tappedButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];		
	}
	else {
		[self.barButtonItemPopover dismissPopoverAnimated:YES];
	}
}

@end
