//
//  PickOneForMeAppDelegate.h
//  PickOneForMe
//
//  Created by Chung Glen on 2009/6/6.
//  Copyright Appiness Software 2009. All rights reserved.
//

@class LotsData;
@interface PickOneForMeAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
	NSMutableArray *lotsData;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

- (void) deserializeLotsImagesAtIndex:(int)index;

- (int) getLotsDataCount;
- (id) getLotsDataAtIndex:(int)index;
- (void) removeLotsDataAtIndex:(int)index;
- (void) addLotsData: (LotsData*) lots;
@end

