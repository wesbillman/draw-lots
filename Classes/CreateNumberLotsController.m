//
//  CreateNumberLotsController.m
//  PickOneForMe
//
//  Created by Chung Glen on 2009/6/7.
//  Copyright 2009 Appiness Software. All rights reserved.
//

#import "CreateNumberLotsController.h"


@implementation CreateNumberLotsController
@synthesize range;

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
	self.title = NSLocalizedString(@"Create Number Lots", @"Create Number Lots");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	textFieldStart.text = [NSString stringWithFormat:@"%d", range.location];
	textFieldRange.text = [NSString stringWithFormat:@"%d", range.length];
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
	[textFieldStart release];
	[textFieldRange release];
	[okButton release];
    [super dealloc];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if([textField.text length] == 0)
	{
		textFieldStart.text = [NSString stringWithFormat:@"%d", range.location];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error") message: NSLocalizedString(@"Please input a number.", @"Please input a number.")
													   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];    
		[alert release];
		return YES;
	}
	int number =[textField.text intValue];

	if(textField == textFieldStart)
	{
		range.location = number;
	}
	else if(textField == textFieldRange)
	{
		if(number <= 1)
		{
			textFieldRange.text = [NSString stringWithFormat:@"%d", range];
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error") message: NSLocalizedString(@"Range must greater than 1.", @"Range must greater than 1.")
														   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[alert show];    
			[alert release];
			return YES;
		}
		if(number > 1000)
		{
			textFieldRange.text = [NSString stringWithFormat:@"%d", range];
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error") message: NSLocalizedString(@"Range must smaller than 1000.", @"Range must smaller than 1000.")
														   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[alert show];    
			[alert release];
			return YES;
		}
		range.length = number;
	}
	
	[textField resignFirstResponder];
	return YES;
}

- (void) okButtonDown: (id) sender
{
	if([textFieldStart isFirstResponder])
	{
		[self textFieldShouldReturn:textFieldStart];
	}
	else if([textFieldRange isFirstResponder])
	{
		[self textFieldShouldReturn:textFieldRange];
	}
}


@end
