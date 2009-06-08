//
//  RootViewController.h
//  PickOneForMe
//
//  Created by Chung Glen on 2009/6/6.
//  Copyright Appiness Software 2009. All rights reserved.
//
#import "PickOneForMeAppDelegate.h"

@interface RootViewController : UITableViewController {
	PickOneForMeAppDelegate	*appDelegate;
	NSMutableArray *lotsTitleArray;
	NSRange dateRange;
}

- (void) newBarButtonDown:(id)sender;

@end
