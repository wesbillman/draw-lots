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
	IBOutlet UISwitch			*repeatableSwitch;
	IBOutlet UIBarButtonItem	*barButtonStart;
	IBOutlet UITextField		*lotsLabel;
	IBOutlet UIView				*remainderBar;
	IBOutlet UIView				*remainderBarBase;
	IBOutlet UIActivityIndicatorView *indicatorView;
	
	NSTimer						*updateTimer;
	NSMutableArray				*currentLots;
	NSMutableArray				*resultLots;	
	NSMutableArray				*lastFewLotsForAnamation;
	int							lastRandomValue;
	float						currentLotsOriginalCount;
}

@property (nonatomic, retain) LotsData *lotsData;
@property (nonatomic, retain) NSMutableArray *currentLots;
@property (nonatomic, retain) NSMutableArray *resultLots;

- (void) startBarButtonDown:(id)sender;
- (void) editBarButtonDown:(id)sender;

- (void) stopUpdateTimer;
- (void) startUpdateTimer;

@end
