//
//  CreatePhotoLotsController.m
//  PickOneForMe
//
//  Created by Chung Glen on 2009/6/6.
//  Copyright 2009 Appiness Software. All rights reserved.
//

#import "CreatePhotoLotsController.h"
#import "UIKeepRatioImageView.h"

@implementation CreatePhotoLotsController
@synthesize imagePicker, imageAddedAlert, imageArray;

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
	self.title = NSLocalizedString(@"Create Photo Lots", @"Create Photo Lots");
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
	[tableView release];
	
	[barButtonCamera release];
	[barButtonPhotoLibrary release];
	[barButtonSavedPhotosAlbum release];
	[barButtonDel release];
	
	self.imagePicker = nil;
	self.imageAddedAlert = nil;
	self.imageArray = nil;
    [super dealloc];
}

- (void)cameraButton:(id)sender {
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
	{
		self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
		[self.navigationController presentModalViewController:self.imagePicker animated:YES];
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error") message: NSLocalizedString(@"Camera is not available!", @"Camera is not available!")
													   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];    
		[alert release];
	}
}

- (void)photoLibraryButton:(id)sender {
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
	{
		self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		[self.navigationController presentModalViewController:self.imagePicker animated:YES];
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error") message: NSLocalizedString(@"Photo Library is not available!", @"Photo Library is not available!")
													   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];    
		[alert release];
	}
}

- (void)savedPhotosAlbumButton:(id)sender {
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
	{
		self.imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
		[self.navigationController presentModalViewController:self.imagePicker animated:YES];
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error") message: NSLocalizedString(@"Saved Photos Album is not available!", @"Saved Photos Album is not available!")
													   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];    
		[alert release];
	}
}


- (void)deleteButton:(id)sender {
}

#define IMAGE_HEIGHT_PIXEL 75
#define IMAGE_PER_ROW 4
#define IMAGE_GAP_PIXEL 4
#if 0
- (void) displayImages
{
	int i;
	int width = scrollView.bounds.size.width;
	int imageWidth = (width - (IMAGE_PER_ROW + 1) * IMAGE_GAP_PIXEL) / IMAGE_PER_ROW;
	for(i=0;i<self.imageArray.count;++i)
	{
		[[self.imageArray objectAtIndex:i] removeFromSuperview];
		CGRect rect;
		rect.size.width = imageWidth;
		rect.size.height = IMAGE_HEIGHT_PIXEL;
		rect.origin.x = (i % IMAGE_PER_ROW) * (imageWidth + IMAGE_GAP_PIXEL) + IMAGE_GAP_PIXEL;
		rect.origin.y = (i / IMAGE_PER_ROW) * (IMAGE_HEIGHT_PIXEL + IMAGE_GAP_PIXEL) + IMAGE_GAP_PIXEL;
		((UIView*)[self.imageArray objectAtIndex:i]).frame = rect;
		[scrollView addSubview:[self.imageArray objectAtIndex:i]];
	}
	[scrollView setNeedsLayout];
	
	[scrollView setNeedsDisplay];
}
#endif

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
	UIKeepRatioImageView *view = [[UIKeepRatioImageView alloc] initWithFrame:CGRectZero andImage:image];

	[self.imageArray addObject:view];	
	if(picker.sourceType != UIImagePickerControllerSourceTypeCamera)
	{
		[self.imageAddedAlert show];    
	}
	else
	{
		[tableView reloadData];
		[picker dismissModalViewControllerAnimated:NO];
	}
}

//no longer support since 3.0
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[picker dismissModalViewControllerAnimated:NO];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(alertView == self.imageAddedAlert)
	{
		if(buttonIndex == 1)
		{
			[self.imagePicker dismissModalViewControllerAnimated:NO];
			[tableView reloadData];
		}
	}
}


- (UIImagePickerController *) imagePicker {
    if (imagePicker == nil) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        self.imagePicker = controller;
		self.imagePicker.delegate = self;
        [controller release];
    }
    return imagePicker;
}

- (UIAlertView *) imageAddedAlert {
    if (imageAddedAlert == nil) {
        UIAlertView *view = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Image Added", @"Image Added") 
														 message: NSLocalizedString(@"Image Added", @"Image Added")
														delegate:self cancelButtonTitle:@"Continue" otherButtonTitles: @"Done", nil];
        self.imageAddedAlert = view;
        [view release];
    }
    return imageAddedAlert;
}

- (NSMutableArray *) imageArray {
    if (imageArray == nil) {
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:16];
        self.imageArray = array;
        [array release];
    }
    return imageArray;
}




#pragma mark Table Content and Appearance

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
	return 2;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
	switch(section)
	{
		case 0:
			if(self.imageArray.count == 0)
				return 0;
			if((self.imageArray.count % IMAGE_PER_ROW) == 0)
				return self.imageArray.count / IMAGE_PER_ROW;
			return self.imageArray.count / IMAGE_PER_ROW + 1;
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
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableViewImageCell"] autorelease];
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
			}
			int i;
			int width = tableView.bounds.size.width;
			int imageWidth = (width - (IMAGE_PER_ROW + 1) * IMAGE_GAP_PIXEL) / IMAGE_PER_ROW;
			for(i=0; i < IMAGE_PER_ROW; ++i)
			{
				if((i + IMAGE_PER_ROW * indexPath.row) >= self.imageArray.count)
					break;
				UIImageView *curView = [self.imageArray objectAtIndex:(i + IMAGE_PER_ROW * indexPath.row)];
				[curView removeFromSuperview];
				CGRect rect;
				rect.size.width = imageWidth;
				rect.size.height = IMAGE_HEIGHT_PIXEL;
				rect.origin.x = (i % IMAGE_PER_ROW) * (imageWidth + IMAGE_GAP_PIXEL) + IMAGE_GAP_PIXEL;
				rect.origin.y = IMAGE_GAP_PIXEL/2;
				curView.frame = rect;
				[cell addSubview:curView];
			}
			return cell;
		break;
		
		case 1:
			cell = (UITableViewCell *)[aTableView dequeueReusableCellWithIdentifier:@"TableViewCountCell"];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableViewCountCell"] autorelease];
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
			}
			if(self.imageArray.count <= 1)
				cell.textLabel.text = [NSString stringWithFormat: NSLocalizedString(@"%d Photo", @"%d Photo"), self.imageArray.count];
			else
				cell.textLabel.text = [NSString stringWithFormat: NSLocalizedString(@"%d Photos", @"%d Photos"), self.imageArray.count];
			cell.textLabel.textAlignment = UITextAlignmentCenter;
		break;
	}
    return cell;
}

@end
