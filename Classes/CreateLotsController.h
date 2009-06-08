//
//  CreateLotsController.h
//  PickOneForMe
//
//  Created by Chung Glen on 2009/6/7.
//  Copyright 2009 Appiness Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreatePhotoLotsController.h"
#import "CreateNumberLotsController.h"
#import "CreateStringLotsController.h"
#import "LotsData.h"


@interface CreateLotsController : UIViewController {
	IBOutlet UITextField		*textFieldName;
	IBOutlet UISegmentedControl	*segControlNumber;

	IBOutlet UILabel			*labelGroup1;
	IBOutlet UILabel			*labelDetail1;
	IBOutlet UISegmentedControl	*segControlGroup1;
	IBOutlet UIButton			*buttonEdit1;
	IBOutlet UISwitch			*repeatableSwitch1;

	IBOutlet UILabel			*labelGroup2;
	IBOutlet UILabel			*labelDetail2;
	IBOutlet UISegmentedControl	*segControlGroup2;
	IBOutlet UIButton			*buttonEdit2;
	IBOutlet UILabel			*repeatableSwitchLabel2;
	IBOutlet UISwitch			*repeatableSwitch2;

	IBOutlet UIButton			*buttonStart;
	
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
@property (nonatomic, retain) UISegmentedControl			*segControlNumber;

@property (nonatomic, retain) UISegmentedControl			*segControlGroup1;
@property (nonatomic, retain) CreatePhotoLotsController		*photoLots1;
@property (nonatomic, retain) CreateNumberLotsController	*numberLots1;
@property (nonatomic, retain) CreateStringLotsController	*stringLots1;

@property (nonatomic, retain) UISegmentedControl			*segControlGroup2;
@property (nonatomic, retain) CreatePhotoLotsController		*photoLots2;
@property (nonatomic, retain) CreateNumberLotsController	*numberLots2;
@property (nonatomic, retain) CreateStringLotsController	*stringLots2;

@property (nonatomic, retain) LotsData						*lotsData;

- (void) buttonEditDown:(id)sender;
- (void) buttonSaveDown:(id)sender;
- (void) buttonCancelDown:(id)sender;
- (void) segControlNumberValueChanged:(id)sender;
- (void) segControlGroupValueChanged:(id)sender;
- (void) repeatableSwitchValueChanged:(id)sender;

@end
