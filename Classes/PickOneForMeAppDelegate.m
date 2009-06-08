//
//  PickOneForMeAppDelegate.m
//  PickOneForMe
//
//  Created by Chung Glen on 2009/6/6.
//  Copyright Appiness Software 2009. All rights reserved.
//

#import "PickOneForMeAppDelegate.h"
#import "RootViewController.h"


@implementation PickOneForMeAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize lotsData;


#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
	
	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
	srand(time(0));
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[lotsData release];
	[navigationController release];
	[window release];
	[super dealloc];
}

- (NSMutableArray *) lotsData {
    if (lotsData == nil) {
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:16];
        self.lotsData = array;
        [array release];
    }
    return lotsData;
}

@end

