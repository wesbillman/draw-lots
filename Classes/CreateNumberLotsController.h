//
//  CreateNumberLotsController.h
//  PickOneForMe
//
//  Created by Chung Glen on 2009/6/7.
//  Copyright 2009 Appiness Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CreateNumberLotsController : UIViewController {
	NSRange					range;
	IBOutlet UITextField	*textFieldStart;
	IBOutlet UITextField	*textFieldRange;
	IBOutlet UIButton		*okButton;
}

@property (nonatomic, assign) NSRange	range;

- (void) okButtonDown: (id) sender;
@end
