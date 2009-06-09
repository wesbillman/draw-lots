//
//  DrawLots1Controller.h
//  PickOneForMe
//
//  Created by Chung Glen on 2009/6/8.
//  Copyright 2009 Appiness Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LotsData.h"
#import "LotsRandomSequence.h"

@interface DrawLots1Controller : UIViewController {
	LotsData					*lotsData;
	IBOutlet UIView				*lotsView;
	IBOutlet UIBarButtonItem	*barButtonStart;
	IBOutlet UITextField		*lotsLabel;
	IBOutlet UIView				*remainderBar;
	IBOutlet UIView				*remainderBarBase;
	IBOutlet UIActivityIndicatorView *indicatorView;
	LotsRandomSequence			*randomSequence;
	
	NSTimer						*updateTimer;
	NSMutableArray				*resultLots;	

}

@property (nonatomic, retain) LotsData *lotsData;
@property (nonatomic, retain) NSMutableArray *resultLots;

- (void) startBarButtonDown:(id)sender;
- (void) editBarButtonDown:(id)sender;
- (void) resultBarButtonDown:(id)sender;

- (void) stopUpdateTimer;
- (void) startUpdateTimer;

@end
