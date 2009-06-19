//
//  EditLotsController.h
//  PickOneForMe
//
//  Created by Chung Glen on 2009/6/18.
//  Copyright 2009 Appiness Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreatePhotoLotsController.h"
#import "CreateNumberLotsController.h"
#import "CreateStringLotsController.h"
#import "LotsData.h"

@interface EditLotsController : UIViewController {
	IBOutlet UITextField		*textFieldName;
	IBOutlet UITextField		*textFieldNumber;
	
	IBOutlet UILabel			*labelGroup1;
	IBOutlet UILabel			*labelDetail1;
	IBOutlet UITextField		*textFieldGroup1Name;
	IBOutlet UIButton			*buttonEdit1;
	IBOutlet UISwitch			*repeatableSwitch1;
	
	IBOutlet UILabel			*labelGroup2;
	IBOutlet UILabel			*labelDetail2;
	IBOutlet UITextField		*textFieldGroup2Name;
	IBOutlet UIButton			*buttonEdit2;
	IBOutlet UILabel			*repeatableSwitchLabel2;
	IBOutlet UISwitch			*repeatableSwitch2;
	
	CreatePhotoLotsController	*photoLots1;
	CreatePhotoLotsController	*photoLots2;
	
	CreateNumberLotsController	*numberLots1;
	CreateNumberLotsController	*numberLots2;
	
	CreateStringLotsController	*stringLots1;
	CreateStringLotsController	*stringLots2;
	
	UIColor						*defaultLableTextColor;
	
	LotsData					*lotsData;
}

@property (nonatomic, retain) UITextField					*textFieldName;

@property (nonatomic, retain) CreatePhotoLotsController		*photoLots1;
@property (nonatomic, retain) CreateNumberLotsController	*numberLots1;
@property (nonatomic, retain) CreateStringLotsController	*stringLots1;

@property (nonatomic, retain) CreatePhotoLotsController		*photoLots2;
@property (nonatomic, retain) CreateNumberLotsController	*numberLots2;
@property (nonatomic, retain) CreateStringLotsController	*stringLots2;

@property (nonatomic, retain) LotsData						*lotsData;

- (void) buttonEditDown:(id)sender;
- (void) buttonSaveDown:(id)sender;
- (void) updateGroupDetail:(int)group;

@end
