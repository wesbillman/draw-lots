//
//  EditLotsController.m
//  PickOneForMe
//
//  Created by Chung Glen on 2009/6/18.
//  Copyright 2009 Appiness Software. All rights reserved.
//

#import "EditLotsController.h"
#import "PickOneForMeAppDelegate.h"

@implementation EditLotsController
@synthesize textFieldName, lotsData;
@synthesize photoLots1, numberLots1, stringLots1;
@synthesize photoLots2, numberLots2, stringLots2;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		self.title = NSLocalizedString(@"Edit Lots", @"Edit Lots");
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	NSArray *titleArray = [NSArray arrayWithObjects: 
		NSLocalizedString(@"Photo", @"Photo"),
		NSLocalizedString(@"Number", @"Number"),
		NSLocalizedString(@"String", @"String"), nil];
	
	textFieldName.text = lotsData.lotsName;
	textFieldNumber.text = [NSString stringWithFormat:@"%d", lotsData.numberOfGroup.intValue - 1];
		
	textFieldGroup1Name.text = [titleArray objectAtIndex: ((NSNumber*)[lotsData.groupTypes objectAtIndex:0]).intValue];
	repeatableSwitch1.on = ((NSNumber*)[lotsData.repeatables objectAtIndex:0]).boolValue;
		
	if(lotsData.numberOfGroup.intValue > 1)
	{
		textFieldGroup2Name.text = [titleArray objectAtIndex: ((NSNumber*)[lotsData.groupTypes objectAtIndex:1]).intValue];
		repeatableSwitch2.on = ((NSNumber*)[lotsData.repeatables objectAtIndex:1]).boolValue;
	}
	labelGroup2.hidden = (lotsData.numberOfGroup.intValue == 1);
	labelDetail2.hidden = (lotsData.numberOfGroup.intValue == 1);
	textFieldGroup2Name.hidden = (lotsData.numberOfGroup.intValue == 1);
	buttonEdit2.hidden = (lotsData.numberOfGroup.intValue == 1);
	repeatableSwitchLabel2.hidden = (lotsData.numberOfGroup.intValue == 1);
	repeatableSwitch2.hidden = (lotsData.numberOfGroup.intValue == 1);
	[self updateGroupDetail:0];
	if(lotsData.numberOfGroup.intValue > 1)
		[self updateGroupDetail:1];
	
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	defaultLableTextColor = labelDetail1.textColor;
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", @"Save")
																			  style:UIBarButtonItemStyleDone target:self action:@selector(buttonSaveDown:)];
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
	[defaultLableTextColor release];
	
	[textFieldName release];
	[textFieldNumber release];
	
	[labelGroup1 release];
	[labelDetail1 release];
	[textFieldGroup1Name release];
	[buttonEdit1 release];
	[repeatableSwitch1 release];
	
	[labelGroup2 release];
	[labelDetail2 release];
	[textFieldGroup2Name release];
	[buttonEdit2 release];
	[repeatableSwitchLabel2 release];
	[repeatableSwitch2 release];
	
	[photoLots1 release];
	[photoLots2 release];
	[numberLots1 release];
	[numberLots2 release];
	[stringLots1 release];
	[stringLots2 release];
	
	[lotsData release];
	
    [super dealloc];
}

- (void) buttonEditDown:(id)sender
{
	NSRange range;
	if(sender == buttonEdit1)
	{
		switch(((NSNumber*)[lotsData.groupTypes objectAtIndex:0]).intValue)
		{
			case 0:
				self.photoLots1.imageArray = [NSMutableArray arrayWithArray:((NSMutableArray*)[lotsData.photoLots objectAtIndex:0])];
				[self.navigationController pushViewController:photoLots1 animated:YES];
				break;
			case 1:
				range.location = ((NSNumber*)[((NSDictionary*)[lotsData.numberLots objectAtIndex:0]) objectForKey:LOTSDATA_NUMBER_START]).intValue;
				range.length = ((NSNumber*)[((NSDictionary*)[lotsData.numberLots objectAtIndex:0]) objectForKey:LOTSDATA_NUMBER_RANGE]).intValue;
				self.numberLots1.range = range; 
				[self.navigationController pushViewController:numberLots1 animated:YES];
				break;
			case 2:
				self.stringLots1.stringArray = [NSMutableArray arrayWithArray:((NSMutableArray*)[lotsData.stringLots objectAtIndex:0])];
				[self.navigationController pushViewController:stringLots1 animated:YES];
				break;
		}
	}
	if(sender == buttonEdit2)
	{
		switch(((NSNumber*)[lotsData.groupTypes objectAtIndex:1]).intValue)
		{
			case 0:
				self.photoLots2.imageArray = [NSMutableArray arrayWithArray:((NSMutableArray*)[lotsData.photoLots objectAtIndex:1])];
				[self.navigationController pushViewController:photoLots2 animated:YES];
				break;
			case 1:
				range.location = ((NSNumber*)[((NSDictionary*)[lotsData.numberLots objectAtIndex:1]) objectForKey:LOTSDATA_NUMBER_START]).intValue;
				range.length = ((NSNumber*)[((NSDictionary*)[lotsData.numberLots objectAtIndex:1]) objectForKey:LOTSDATA_NUMBER_RANGE]).intValue;
				self.numberLots2.range = range;
				[self.navigationController pushViewController:numberLots2 animated:YES];
				break;
			case 2:
				self.stringLots2.stringArray = [NSMutableArray arrayWithArray:((NSMutableArray*)[lotsData.stringLots objectAtIndex:1])];
				[self.navigationController pushViewController:stringLots2 animated:YES];
				break;
		}
	}
}

- (void) buttonSaveDown:(id)sender
{
	switch(((NSNumber*)[lotsData.groupTypes objectAtIndex:0]).intValue)
	{
		case 0:
			if(photoLots1 && photoLots1.imageArray.count <= 1)
			{
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error") message: NSLocalizedString(@"Please add more photos of group 1.", @"Please add more photos of group 1.")
															   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
				[alert show];    
				[alert release];
				return;
			}
			break;
		case 1:
			if(numberLots1 && numberLots1.range.length <= 1)
			{
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error") message: NSLocalizedString(@"Please increase range of number of group 1.", @"Please increase range of number of group 1.")
															   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
				[alert show];    
				[alert release];
				return;
			}
			break;
		case 2:
			if(stringLots1 && stringLots1.stringArray.count <= 1)
			{
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error") message: NSLocalizedString(@"Please add more strings of group 1.", @"Please add more strings of group 1.")
															   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
				[alert show];    
				[alert release];
				return;
			}
			break;
	}
	if(lotsData.numberOfGroup.intValue == 2)
	{
		switch(((NSNumber*)[lotsData.groupTypes objectAtIndex:1]).intValue)
		{
			case 0:
				if(photoLots2 && photoLots2.imageArray.count <= 1)
				{
					UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error") message: NSLocalizedString(@"Please add more photos of group 2.", @"Please add more photos of group 2.")
																   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
					[alert show];    
					[alert release];
					return;
				}
				break;
			case 1:
				if(numberLots2 && numberLots2.range.length <= 1)
				{
					UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error") message: NSLocalizedString(@"Please increase range of number of group 2.", @"Please increase range of number of group 2.")
																   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
					[alert show];    
					[alert release];
					return;
				}
				break;
			case 2:
				if(stringLots2 && stringLots2.stringArray.count <= 1)
				{
					UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error") message: NSLocalizedString(@"Please add more strings of group 2.", @"Please add more strings of group 2.")
																   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
					[alert show];    
					[alert release];
					return;
				}
				break;
		}
	}
	
	lotsData.lotsName = textFieldName.text;

	switch(((NSNumber*)[lotsData.groupTypes objectAtIndex:0]).intValue)
	{
		case 0:
			if(photoLots1)
			{
				[lotsData.photoLots replaceObjectAtIndex:0 withObject:photoLots1.imageArray];
				lotsData.dataChanged |= YES;
			}
			break;
		case 1:
			if(numberLots1)
			{
				[lotsData.numberLots replaceObjectAtIndex:0 withObject:[NSDictionary dictionaryWithObjectsAndKeys:
					[NSNumber numberWithInt:numberLots1.range.location], LOTSDATA_NUMBER_START,
					[NSNumber numberWithInt:numberLots1.range.length], LOTSDATA_NUMBER_RANGE, nil]];
				lotsData.dataChanged |= YES;
			}
			break;
		case 2:
			if(stringLots1)
			{
				[lotsData.stringLots replaceObjectAtIndex:0 withObject:stringLots1.stringArray];
				lotsData.dataChanged |= YES;
			}
			break;
	}
	if(lotsData.numberOfGroup.intValue == 2)
	{
		switch(((NSNumber*)[lotsData.groupTypes objectAtIndex:1]).intValue)
		{
			case 0:
				if(photoLots2)
				{
					[lotsData.photoLots replaceObjectAtIndex:1 withObject:photoLots2.imageArray];
					lotsData.dataChanged |= YES;
				}
				break;
			case 1:
				if(numberLots2)
				{
					[lotsData.numberLots replaceObjectAtIndex:1 withObject:[NSDictionary dictionaryWithObjectsAndKeys:
						[NSNumber numberWithInt:numberLots2.range.location], LOTSDATA_NUMBER_START,
						[NSNumber numberWithInt:numberLots2.range.length], LOTSDATA_NUMBER_RANGE, nil]];
					lotsData.dataChanged |= YES;
				}
				break;
			case 2:
				if(stringLots2)
				{
					[lotsData.stringLots replaceObjectAtIndex:1 withObject:stringLots2.stringArray];
					lotsData.dataChanged |= YES;
				}
				break;
		}
	}

	[self.navigationController popViewControllerAnimated:YES];
}

- (void) updateGroupDetail:(int)group
{
	UILabel *label = nil;
	int photo = 0;
	int number = 0;
	int string = 0;
	int groupType;
	
	if(group == 0)
	{
		label = labelDetail1;
		if(photoLots1)
			photo = photoLots1.imageArray.count;
		else
			photo = ((NSMutableArray*)[lotsData.photoLots objectAtIndex:0]).count;
		if(numberLots1)
			number = numberLots1.range.length;
		else
			number = ((NSNumber*)[((NSDictionary*)[lotsData.numberLots objectAtIndex:0]) objectForKey:LOTSDATA_NUMBER_RANGE]).intValue;
		if(stringLots1)
			string = stringLots1.stringArray.count;
		else
			string = ((NSMutableArray*)[lotsData.stringLots objectAtIndex:0]).count;
		groupType = ((NSNumber*)[lotsData.groupTypes objectAtIndex:0]).intValue;
	}
	else if(group == 1)
	{
		label = labelDetail2;
		if(photoLots2)
			photo = photoLots2.imageArray.count;
		else
			photo = ((NSMutableArray*)[lotsData.photoLots objectAtIndex:1]).count;
		if(numberLots2)
			number = numberLots2.range.length;
		else
			number = ((NSNumber*)[((NSDictionary*)[lotsData.numberLots objectAtIndex:1]) objectForKey:LOTSDATA_NUMBER_RANGE]).intValue;
		if(stringLots2)
			string = stringLots2.stringArray.count;
		else
			string = ((NSMutableArray*)[lotsData.stringLots objectAtIndex:1]).count;
		groupType = ((NSNumber*)[lotsData.groupTypes objectAtIndex:1]).intValue;
	}
	if(label)
	{
		label.textColor = defaultLableTextColor;
		switch(groupType)
		{
			case 0:
				if(photo <= 1)
				{
					label.text = [NSString stringWithFormat: NSLocalizedString(@"%d Photo", @"%d Photo"), photo];
					label.textColor = [UIColor redColor];
				}
				else
					label.text = [NSString stringWithFormat: NSLocalizedString(@"%d Photos", @"%d Photos"), photo];
				break;
			case 1:
				if(number <= 1)
				{
					label.text = [NSString stringWithFormat: NSLocalizedString(@"%d Number", @"%d Number"), number];
					label.textColor = [UIColor redColor];
				}
				else
					label.text = [NSString stringWithFormat: NSLocalizedString(@"%d Numbers", @"%d Numbers"), number];
				break;
			case 2:
				if(string <= 1)
				{
					label.text = [NSString stringWithFormat: NSLocalizedString(@"%d String", @"%d String"), string];
					label.textColor = [UIColor redColor];
				}
				else
					label.text = [NSString stringWithFormat: NSLocalizedString(@"%d Strings", @"%d Strings"), string];
				break;
		}
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}


- (CreatePhotoLotsController *) photoLots1 {
    if (photoLots1 == nil) {
        CreatePhotoLotsController *controller = [[CreatePhotoLotsController alloc] initWithNibName:@"CreatePhotoLotsController" bundle:nil];
        self.photoLots1 = controller;
        [controller release];
    }
    return photoLots1;
}

- (CreatePhotoLotsController *) photoLots2 {
    if (photoLots2 == nil) {
        CreatePhotoLotsController *controller = [[CreatePhotoLotsController alloc] initWithNibName:@"CreatePhotoLotsController" bundle:nil];
        self.photoLots2 = controller;
        [controller release];
    }
    return photoLots2;
}

- (CreateNumberLotsController *) numberLots1 {
    if (numberLots1 == nil) {
        CreateNumberLotsController *controller = [[CreateNumberLotsController alloc] initWithNibName:@"CreateNumberLotsController" bundle:nil];
        self.numberLots1 = controller;
        [controller release];
    }
    return numberLots1;
}

- (CreateNumberLotsController *) numberLots2 {
    if (numberLots2 == nil) {
        CreateNumberLotsController *controller = [[CreateNumberLotsController alloc] initWithNibName:@"CreateNumberLotsController" bundle:nil];
        self.numberLots2 = controller;
        [controller release];
    }
    return numberLots2;
}

- (CreateStringLotsController *) stringLots1 {
    if (stringLots1 == nil) {
        CreateStringLotsController *controller = [[CreateStringLotsController alloc] initWithNibName:@"CreateStringLotsController" bundle:nil];
        self.stringLots1 = controller;
        [controller release];
    }
    return stringLots1;
}

- (CreateStringLotsController *) stringLots2 {
    if (stringLots2 == nil) {
        CreateStringLotsController *controller = [[CreateStringLotsController alloc] initWithNibName:@"CreateStringLotsController" bundle:nil];
        self.stringLots2 = controller;
        [controller release];
    }
    return stringLots1;
}

@end
