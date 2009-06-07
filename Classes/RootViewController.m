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


@implementation RootViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.title = NSLocalizedString(@"Draw Lots", @"Draw Lots");
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
    return 2;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch(section)
	{
		case 0:
			return 2;
		case 1:
			return appDelegate.lotsData.count;
	}
	return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch(indexPath.section)
	{
		case 0:
		{
			switch(indexPath.row)
			{
				case 0:
				{
					static NSString *CellIdentifier = @"CreateNewLotsCell";
					UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
					if (cell == nil) {
						cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
						cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
					}
					cell.textLabel.text = NSLocalizedString(@"Create New Lots", @"Create New Lots");
					return cell;
				}

				case 1:
				{
					static NSString *CellIdentifier = @"ShareMyPhotosCell";
					UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
					if (cell == nil) {
						cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
						cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
					}
					cell.textLabel.text = NSLocalizedString(@"Share My Photos", @"Share My Photos");
					cell.detailTextLabel.text = NSLocalizedString(@"Share My Photos to Another Device.", @"Share My Photos to Another Device.");
					return cell;
				}
			}
			break;
		}
		case 1:
		{
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
		}
	}

    return nil;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch(section)
	{
		case 0:
			return nil;
		case 1:
			return NSLocalizedString(@"Saved lots", @"Saved lots");
	}
	return nil;
}



// Override to support row selection in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	CreateLotsController *controller = [[CreateLotsController alloc] initWithNibName:@"CreateLotsController" bundle:nil];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
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


@end

