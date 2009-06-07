//
//  CreateStringLotsController.m
//  PickOneForMe
//
//  Created by Chung Glen on 2009/6/7.
//  Copyright 2009 Appiness Software. All rights reserved.
//

#import "CreateStringLotsController.h"


@implementation CreateStringLotsController
@synthesize stringArray;

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
	self.title = NSLocalizedString(@"Create String Lots", @"Create String Lots");
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

- (void) addButtonDown:(id)sender
{
	if([textFieldString.text length])
	{
		[self.stringArray addObject:textFieldString.text];
		[tableView reloadData];
		textFieldString.text = @"";
		[textFieldString resignFirstResponder];
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error") message: NSLocalizedString(@"No String Provieded!", @"No String Provieded!")
													   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];    
		[alert release];
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textFieldString resignFirstResponder];
	return YES;
}

- (NSMutableArray *) stringArray {
    if (stringArray == nil) {
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:16];
        self.stringArray = array;
        [array release];
    }
    return stringArray;
}

#pragma mark Table Content and Appearance

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
	return 2;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
	switch(section)
	{
		case 0:
			return self.stringArray.count;
		case 1:
			return 1;
	}
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
	switch(indexPath.section)
	{
		case 0:
			cell = (UITableViewCell *)[aTableView dequeueReusableCellWithIdentifier:@"TableViewStatementCell"];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableViewStatementCell"] autorelease];
				//cell.selectionStyle = UITableViewCellSelectionStyleNone;
			}
			cell.textLabel.text = [self.stringArray objectAtIndex:indexPath.row];
			break;
			
		case 1:
			cell = (UITableViewCell *)[aTableView dequeueReusableCellWithIdentifier:@"TableViewCountCell"];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableViewCountCell"] autorelease];
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
			}
			if(self.stringArray.count <= 1)
					cell.textLabel.text = [NSString stringWithFormat: NSLocalizedString(@"%d Statement", @"%d Statement"), self.stringArray.count];
			else
				cell.textLabel.text = [NSString stringWithFormat: NSLocalizedString(@"%d Statements", @"%d Statements"), self.stringArray.count];
			cell.textLabel.textAlignment = UITextAlignmentCenter;
			break;
	}
    return cell;
}

@end
