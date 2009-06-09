//
//  DrawLots2Controller.h
//  PickOneForMe
//
//  Created by Chung Glen on 2009/6/8.
//  Copyright 2009 Appiness Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LotsData.h"
#import "LotsRandomSequence.h"

@interface DrawLots2Controller : UIViewController {
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

	//group 2
	IBOutlet UIView				*lotsView2;
	IBOutlet UITextField		*lotsLabel2;
	IBOutlet UIView				*remainderBar2;
	IBOutlet UIView				*remainderBarBase2;
	IBOutlet UIActivityIndicatorView *indicatorView2;
	LotsRandomSequence			*randomSequence2;
}


@property (nonatomic, retain) LotsData *lotsData;
@property (nonatomic, retain) NSMutableArray *resultLots;

- (void) startBarButtonDown:(id)sender;
- (void) editBarButtonDown:(id)sender;
- (void) resultBarButtonDown:(id)sender;

- (void) stopUpdateTimer;
- (void) startUpdateTimer;

@end
