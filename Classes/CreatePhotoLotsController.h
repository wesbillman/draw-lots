//
//  CreatePhotoLotsController.h
//  PickOneForMe
//
//  Created by Chung Glen on 2009/6/6.
//  Copyright 2009 Appiness Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CreatePhotoLotsController : UIViewController <UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate> {
	IBOutlet UITableView		*tableView;
	
	IBOutlet UIBarButtonItem	*barButtonCamera;
	IBOutlet UIBarButtonItem	*barButtonPhotoLibrary;
	IBOutlet UIBarButtonItem	*barButtonSavedPhotosAlbum;
	IBOutlet UIBarButtonItem	*barButtonDel;

	UIImagePickerController		*imagePicker;
	UIAlertView					*imageAddedAlert;
	
	NSMutableArray				*imageArray;
}

@property (nonatomic, retain) UIImagePickerController	*imagePicker;
@property (nonatomic, retain) UIAlertView				*imageAddedAlert;
@property (nonatomic, retain) NSMutableArray			*imageArray;


- (void)cameraButton:(id)sender;
- (void)photoLibraryButton:(id)sender;
- (void)savedPhotosAlbumButton:(id)sender;
- (void)deleteButton:(id)sender;

@end
