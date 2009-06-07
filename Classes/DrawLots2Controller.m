//
//  DrawLots2Controller.m
//  PickOneForMe
//
//  Created by Chung Glen on 2009/6/8.
//  Copyright 2009 Appiness Software. All rights reserved.
//

#import "DrawLots2Controller.h"
#import "CreateLotsController.h"
#import "LotsData.h"

@implementation DrawLots2Controller
@synthesize lotsData;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = NSLocalizedString(@"Drawing Lots", @"Drawing Lots");
	self.editButtonItem.target = self;
	self.editButtonItem.action = @selector(editBarButtonDown:);
	self.editButtonItem.style = UIBarButtonItemStyleBordered;
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	self.title = self.lotsData.lotsName;
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

- (void) startBarButtonDown:(id)sender
{
	
}

- (void) editBarButtonDown:(id)sender
{
	CreateLotsController *controller = [[CreateLotsController alloc] initWithNibName:@"CreateLotsController" bundle:nil];
	controller.lotsData = self.lotsData;
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

@end
