//
//  CreateLotsController.m
//  PickOneForMe
//
//  Created by Chung Glen on 2009/6/7.
//  Copyright 2009 Appiness Software. All rights reserved.
//

#import "CreateLotsController.h"
#import "PickOneForMeAppDelegate.h"

@implementation CreateLotsController
@synthesize textFieldName, segControlNumber, lotsData;
@synthesize segControlGroup1, photoLots1, numberLots1, stringLots1;
@synthesize segControlGroup2, photoLots2, numberLots2, stringLots2;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		photoLots1 = [[CreatePhotoLotsController alloc] initWithNibName:@"CreatePhotoLotsController" bundle:nil];
		photoLots2 = [[CreatePhotoLotsController alloc] initWithNibName:@"CreatePhotoLotsController" bundle:nil];
		numberLots1 = [[CreateNumberLotsController alloc] initWithNibName:@"CreateNumberLotsController" bundle:nil];
		numberLots2 = [[CreateNumberLotsController alloc] initWithNibName:@"CreateNumberLotsController" bundle:nil];
		stringLots1 = [[CreateStringLotsController alloc] initWithNibName:@"CreateStringLotsController" bundle:nil];
		stringLots2 = [[CreateStringLotsController alloc] initWithNibName:@"CreateStringLotsController" bundle:nil];
		NSRange defaultRange = {1, 10};
		numberLots1.range = numberLots2.range = defaultRange;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	if(lotsData)
	{
		textFieldName.text = lotsData.lotsName;
		segControlNumber.selectedSegmentIndex = lotsData.numberOfGroup - 1;
		
		segControlGroup1.selectedSegmentIndex = lotsData.group1Type;
		
		segControlGroup2.selectedSegmentIndex = lotsData.group2Type;

		photoLots1.imageArray = lotsData.photoLots1;
		photoLots2.imageArray = lotsData.photoLots2;
		
		numberLots1.range = lotsData.numberLots1;
		numberLots2.range = lotsData.numberLots2;
		
		stringLots1.stringArray = lotsData.stringLots1;
		stringLots2.stringArray = lotsData.stringLots2;
		
		self.title = NSLocalizedString(@"Edit Lots", @"Edit Lots");
		buttonStart.titleLabel.text = NSLocalizedString(@"Start", @"Start");
	}
	else
	{
		self.title = NSLocalizedString(@"Create New Lots", @"Create New Lots");
		buttonStart.titleLabel.text = NSLocalizedString(@"Save and Start", @"Save and Start");
	}
	[self segControlNumberValueChanged:segControlNumber];
	[self segControlGroupValueChanged:segControlGroup1];
	[self segControlGroupValueChanged:segControlGroup2];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	defaultLableTextColor = labelDetail1.textColor;
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
	[segControlNumber release];
	
	[labelGroup1 release];
	[labelDetail1 release];
	[segControlGroup1 release];
	[buttonEdit1 release];

	[labelGroup2 release];
	[labelDetail2 release];
	[segControlGroup2 release];
	[buttonEdit2 release];
	
	[buttonStart release];
	
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
	if(sender == buttonEdit1)
	{
		switch(segControlGroup1.selectedSegmentIndex)
		{
			case 0:
				[self.navigationController pushViewController:photoLots1 animated:YES];
				break;
			case 1:
				[self.navigationController pushViewController:numberLots1 animated:YES];
				break;
			case 2:
				[self.navigationController pushViewController:stringLots1 animated:YES];
				break;
		}
	}
	if(sender == buttonEdit2)
	{
		switch(segControlGroup2.selectedSegmentIndex)
		{
			case 0:
				[self.navigationController pushViewController:photoLots2 animated:YES];
				break;
			case 1:
				[self.navigationController pushViewController:numberLots2 animated:YES];
				break;
			case 2:
				[self.navigationController pushViewController:stringLots2 animated:YES];
				break;
		}
	}
}

- (void) buttonStartDown:(id)sender
{
	switch(segControlGroup1.selectedSegmentIndex)
	{
		case 0:
			if(photoLots1.imageArray.count <= 1)
			{
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error") message: NSLocalizedString(@"Please add more photos of group 1.", @"Please add more photos of group 1.")
															   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
				[alert show];    
				[alert release];
				return;
			}
			break;
		case 1:
			if(numberLots1.range.length <= 1)
			{
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error") message: NSLocalizedString(@"Please increase range of number of group 1.", @"Please increase range of number of group 1.")
															   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
				[alert show];    
				[alert release];
				return;
			}
			break;
		case 2:
			if(stringLots1.stringArray.count <= 1)
			{
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error") message: NSLocalizedString(@"Please add more strings of group 1.", @"Please add more strings of group 1.")
															   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
				[alert show];    
				[alert release];
				return;
			}
			break;
	}
	if(segControlNumber.selectedSegmentIndex == 1)
	{
		switch(segControlGroup2.selectedSegmentIndex)
		{
			case 0:
				if(photoLots2.imageArray.count <= 1)
				{
					UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error") message: NSLocalizedString(@"Please add more photos of group 2.", @"Please add more photos of group 2.")
																   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
					[alert show];    
					[alert release];
					return;
				}
				break;
			case 1:
				if(numberLots2.range.length <= 1)
				{
					UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error") message: NSLocalizedString(@"Please increase range of number of group 2.", @"Please increase range of number of group 2.")
																   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
					[alert show];    
					[alert release];
					return;
				}
				break;
			case 2:
				if(stringLots2.stringArray.count <= 1)
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
	if(lotsData == nil)
	{
		lotsData = [[LotsData alloc] initWithNumberofGroup:segControlNumber.selectedSegmentIndex+1
												  lotsName:textFieldName.text 
												  lotsDate:[[[NSDate date] retain] autorelease]
												group1Type:segControlGroup1.selectedSegmentIndex 
												group2Type:segControlGroup2.selectedSegmentIndex 
												photoLots1:photoLots1.imageArray
												photoLots2:photoLots2.imageArray
											   numberLots1:numberLots1.range
											   numberLots2:numberLots2.range 
											   stringLots1:stringLots1.stringArray
											   stringLots2:stringLots2.stringArray];
		PickOneForMeAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
		[appDelegate.lotsData addObject:lotsData];
		//[lotsData release];
	}
	[self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) segControlNumberValueChanged:(id)sender
{
	labelGroup2.hidden = (segControlNumber.selectedSegmentIndex == 0);
	labelDetail2.hidden = (segControlNumber.selectedSegmentIndex == 0);
	segControlGroup2.hidden = (segControlNumber.selectedSegmentIndex == 0);
	buttonEdit2.hidden = (segControlNumber.selectedSegmentIndex == 0);
}

- (void) segControlGroupValueChanged:(id)sender
{
	UILabel *label;
	CreatePhotoLotsController *photo;
	CreateNumberLotsController *number;
	CreateStringLotsController *string;
	
	if(sender == segControlGroup1)
	{
		label = labelDetail1;
		photo = photoLots1;
		number = numberLots1;
		string = stringLots1;
	}
	else if(sender == segControlGroup2)
	{
		label = labelDetail2;
		photo = photoLots2;
		number = numberLots2;
		string = stringLots2;
	}
	if(label)
	{
		label.textColor = defaultLableTextColor;
		switch(((UISegmentedControl*)sender).selectedSegmentIndex)
		{
			case 0:
				if(photo.imageArray.count <= 1)
				{
					label.text = [NSString stringWithFormat: NSLocalizedString(@"%d Photo", @"%d Photo"), photo.imageArray.count];
					label.textColor = [UIColor redColor];
				}
				else
					label.text = [NSString stringWithFormat: NSLocalizedString(@"%d Photos", @"%d Photos"), photo.imageArray.count];
				break;
			case 1:
				if(number.range.length <= 1)
				{
					label.text = [NSString stringWithFormat: NSLocalizedString(@"%d Number", @"%d Number"), number.range.length];
					label.textColor = [UIColor redColor];
				}
				else
					label.text = [NSString stringWithFormat: NSLocalizedString(@"%d Numbers", @"%d Numbers"), number.range.length];
				break;
			case 2:
				if(string.stringArray.count <= 1)
				{
					label.text = [NSString stringWithFormat: NSLocalizedString(@"%d String", @"%d String"), string.stringArray.count];
					label.textColor = [UIColor redColor];
				}
				else
					label.text = [NSString stringWithFormat: NSLocalizedString(@"%d Strings", @"%d Strings"), string.stringArray.count];
				break;
		}
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

@end
