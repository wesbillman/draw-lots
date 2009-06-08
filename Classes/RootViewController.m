//
//  RootViewController.m
//  PickOneForMe
//
//  Created by Chung Glen on 2009/6/6.
//  Copyright Appiness Software 2009. All rights reserved.
//

#import "RootViewController.h"
#import "CreateLotsController.h"
#import "LotsData.h"
#import "DrawLots1Controller.h"
#import "DrawLots2Controller.h"


@implementation RootViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Share", @"Share")
																			  style:UIBarButtonItemStylePlain target:self action:@selector(newBarButtonDown:)];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"New", @"New")
																			  style:UIBarButtonItemStylePlain target:self action:@selector(newBarButtonDown:)];
	appDelegate = [UIApplication sharedApplication].delegate;

	lotsTitleArray = [[NSMutableArray arrayWithCapacity:3] retain];
	[lotsTitleArray addObject:NSLocalizedString(@"Photo", @"Photo")];
	[lotsTitleArray addObject:NSLocalizedString(@"Number", @"Number")];
	[lotsTitleArray addObject:NSLocalizedString(@"String", @"String")];
	dateRange.location = 0;
	dateRange.length = 10;
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	self.title = NSLocalizedString(@"List of Lots", @"List of Lots");
	[self.tableView reloadData];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release anything that can be recreated in viewDidLoad or on demand.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return appDelegate.lotsData.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	int idx = indexPath.row;
	LotsData *data = [appDelegate.lotsData objectAtIndex:idx];
	if(data)
	{
		static NSString *CellIdentifier = @"LotsDataCell";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
			cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
		}
		if([data.lotsName length] == 0)
			cell.textLabel.text = NSLocalizedString(@"Untitled Lots", @"Untitled Lots");
		else
			cell.textLabel.text = data.lotsName;
		if(data.numberOfGroup == 1)
		{
			cell.detailTextLabel.text = 
			[NSString stringWithFormat: NSLocalizedString(@"%@ (%@ Lots)", @"%@ (%@ Lots)"),
				[data.lotsDate.description substringWithRange:dateRange], [lotsTitleArray objectAtIndex:data.group1Type]];
		}
		else
		{
			cell.detailTextLabel.text = 
			[NSString stringWithFormat: NSLocalizedString(@"%@ (%@ and %@ Lots)", @"%@ (%@ and %@ Lots)"),
				[data.lotsDate.description substringWithRange:dateRange], [lotsTitleArray objectAtIndex:data.group1Type], [lotsTitleArray objectAtIndex:data.group2Type]];
		}
		return cell;
	}
	return nil;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return NSLocalizedString(@"Saved lots", @"Saved lots");
}



// Override to support row selection in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	LotsData *data = [appDelegate.lotsData objectAtIndex:indexPath.row];
	if(data.numberOfGroup == 1)
	{
		DrawLots1Controller *controller = [[DrawLots1Controller alloc] initWithNibName:@"DrawLots1Controller" bundle:nil];
		controller.lotsData = data;
		self.title = nil;
		[self.navigationController pushViewController:controller animated:YES];
		[controller release];
	}
	else
	{
		DrawLots2Controller *controller = [[DrawLots2Controller alloc] initWithNibName:@"DrawLots2Controller" bundle:nil];
		controller.lotsData = data;
		self.title = nil;
		[self.navigationController pushViewController:controller animated:YES];
		[controller release];
	}
	[self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}




// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc {
	[lotsTitleArray release];
	[appDelegate release];
    [super dealloc];
}

- (void) newBarButtonDown:(id)sender
{
	CreateLotsController *controller = [[CreateLotsController alloc] initWithNibName:@"CreateLotsController" bundle:nil];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

@end

