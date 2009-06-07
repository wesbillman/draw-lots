//
//  PickOneForMeAppDelegate.h
//  PickOneForMe
//
//  Created by Chung Glen on 2009/6/6.
//  Copyright Appiness Software 2009. All rights reserved.
//

@interface PickOneForMeAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
	NSMutableArray *lotsData;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@property (nonatomic, retain) NSMutableArray *lotsData;
@end

