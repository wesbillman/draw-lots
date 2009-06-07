//
//  DrawLots1Controller.h
//  PickOneForMe
//
//  Created by Chung Glen on 2009/6/8.
//  Copyright 2009 Appiness Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LotsData.h"

@interface DrawLots1Controller : UIViewController {
	LotsData					*lotsData;
	IBOutlet UIView				*lotsView;
	IBOutlet UIView				*lastResultView;
	IBOutlet UISwitch			*repeatableSwitch;
	IBOutlet UILabel			*lastResultLabel;
	IBOutlet UIBarButtonItem	*barButtonStart;
}

@property (nonatomic, retain) LotsData *lotsData;

- (void) startBarButtonDown:(id)sender;
- (void) editBarButtonDown:(id)sender;
@end
