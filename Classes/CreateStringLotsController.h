//
//  CreateStringLotsController.h
//  PickOneForMe
//
//  Created by Chung Glen on 2009/6/7.
//  Copyright 2009 Appiness Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CreateStringLotsController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>{
	IBOutlet UITableView	*tableView;
	IBOutlet UITextField	*textFieldString;
	IBOutlet UIButton		*addButton;
	NSMutableArray			*stringArray;
}

@property (nonatomic, retain) NSMutableArray	*stringArray;

- (void) addButtonDown:(id)sender;
@end
