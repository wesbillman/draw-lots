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
	selectImages = [[NSMutableArray alloc] initWithCapacity:8];
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
	[selectImages release];
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

#if 0
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	if(navigationController == self.imagePicker)
	{
		viewController.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"Done", @"Done");
	}
}
#endif

- (void)deleteButton:(id)sender {
	if(selectImages.count)
	{
		[self.imageArray removeObjectsInArray:selectImages];
		[selectImages removeAllObjects];
		[tableView reloadData];
	}
	barButtonDel.enabled = selectImages.count > 0;
}

#define IMAGE_HEIGHT_PIXEL 75
#define IMAGE_PER_ROW 4
#define IMAGE_GAP_PIXEL 4

- (UIImage *) createResizeImage:(UIImage*) srcImage
{
#if 0
	NSData *sourceData = nil;
	float resizeWidth = 13.0;
	float resizeHeight = 13.0;
	
	NSImage *sourceImage = [[NSImage alloc] initWithData: sourceData];
	NSImage *resizedImage = [[NSImage alloc] initWithSize: NSMakeSize(resizeWidth, resizeHeight)];
	
	NSSize originalSize = [sourceImage size];
	
	[resizedImage lockFocus];
	[sourceImage drawInRect: NSMakeRect(0, 0, resizeWidth, resizeHeight) fromRect: NSMakeRect(0, 0, originalSize.width, originalSize.height) operation: NSCompositeSourceOver fraction: 1.0];
	[resizedImage unlockFocus];
	
	NSData *resizedData = [resizedImage TIFFRepresentation];
	
	[sourceImage release];
	[resizedImage release];

#else
#define IMAGE_WIDTH_WANT 180
#define IMAGE_HEIGHT_WANT 180
	
	CGSize newSize;
	float xRatio = srcImage.size.width / IMAGE_WIDTH_WANT;
	float yRatio = srcImage.size.height / IMAGE_HEIGHT_WANT;
	if(xRatio >= yRatio)
	{
		newSize.width = IMAGE_WIDTH_WANT;
		newSize.height = srcImage.size.height / xRatio;
	}
	else
	{
		newSize.width = srcImage.size.width / yRatio;;
		newSize.height = IMAGE_HEIGHT_WANT;
	}
	UIGraphicsBeginImageContext( newSize );// a CGSize that has the size you want
	[srcImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
	//srcImage is the original UIImage
	UIImage* newImage = [UIGraphicsGetImageFromCurrentImageContext() retain];
	UIGraphicsEndImageContext();
	
	return newImage;
#endif
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage *image = [self createResizeImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
	[self.imageArray addObject:image];	
	[image release];
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
			for(i=0;i<cell.subviews.count;++i)
			{
				if([[cell.subviews objectAtIndex:i] isKindOfClass:[UIKeepRatioImageView class]])
				{
					[[cell.subviews objectAtIndex:i] removeFromSuperview];
				}
			}
				int width = tableView.bounds.size.width;
			int imageWidth = (width - (IMAGE_PER_ROW + 1) * IMAGE_GAP_PIXEL) / IMAGE_PER_ROW;
			for(i=0; i < IMAGE_PER_ROW; ++i)
			{
				if((i + IMAGE_PER_ROW * indexPath.row) >= self.imageArray.count)
					break;

				UIImage *img = [self.imageArray objectAtIndex:(i + IMAGE_PER_ROW * indexPath.row)];
				UIKeepRatioImageView *curView = [[UIKeepRatioImageView alloc] initWithFrame:CGRectZero andImage:img];
				curView.delegate = self;
				
				CGRect rect;
				rect.size.width = imageWidth;
				rect.size.height = IMAGE_HEIGHT_PIXEL;
				rect.origin.x = (i % IMAGE_PER_ROW) * (imageWidth + IMAGE_GAP_PIXEL) + IMAGE_GAP_PIXEL;
				rect.origin.y = IMAGE_GAP_PIXEL/2;
				curView.frame = rect;
				[cell addSubview:curView];
				[curView release];
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

- (void)didSelectedUIKeepRatioImageView:(UIKeepRatioImageView *)view
{
	if(![selectImages containsObject:view.srcImage])
	{
		[selectImages addObject:view.srcImage];
	}
	barButtonDel.enabled = selectImages.count > 0;
}

- (void)didUnselectedUIKeepRatioImageView:(UIKeepRatioImageView *)view
{
	[selectImages removeObject:view.srcImage];
	barButtonDel.enabled = selectImages.count > 0;
}


@end
