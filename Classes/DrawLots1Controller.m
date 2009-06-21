//
//  DrawLots1Controller.m
//  PickOneForMe
//
//  Created by Chung Glen on 2009/6/8.
//  Copyright 2009 Appiness Software. All rights reserved.
//

#import "DrawLots1Controller.h"
#import "EditLotsController.h"
#import "LotsData.h"
#import "UIKeepRatioImageView.h"
#import "HistoryController.h"

@implementation DrawLots1Controller
@synthesize lotsData, resultLots;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = NSLocalizedString(@"Drawing Lots", @"Drawing Lots");
	self.editButtonItem.target = self;
	self.editButtonItem.action = @selector(editBarButtonDown:);
	self.editButtonItem.style = UIBarButtonItemStyleBordered;
	self.navigationItem.rightBarButtonItem = self.editButtonItem;

	//	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"Back")
	//																			 style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonDown:)];
	[UIAccelerometer sharedAccelerometer].delegate = self;
	[UIAccelerometer sharedAccelerometer].updateInterval = 0.2;
}

- (NSMutableArray *) resultLots {
    if (resultLots == nil) {
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:200];
        self.resultLots = array;
        [array release];
    }
    return resultLots;
}

- (LotsRandomSequence *) randomSequence {
    if (randomSequence == nil) {
		randomSequence = [[LotsRandomSequence alloc] initWithSize: 10];
    }
    return randomSequence;
}

- (void) configRandomSequence
{
	switch(((NSNumber*)[lotsData.groupTypes objectAtIndex:0]).intValue)
	{
		case 0: // photo
			lotsLabel.hidden = YES;
			[self.randomSequence setSrcArray: [lotsData.photoLots objectAtIndex:0]];
			break;
		case 1: // number
		{
			int i;
			lotsLabel.hidden = NO;
			NSMutableArray *array = [NSMutableArray arrayWithCapacity: ((NSNumber*)[((NSDictionary*)[lotsData.numberLots objectAtIndex:0]) objectForKey:LOTSDATA_NUMBER_RANGE]).intValue];
			int start = ((NSNumber*)[((NSDictionary*)[lotsData.numberLots objectAtIndex:0]) objectForKey:LOTSDATA_NUMBER_START]).intValue;
			int end = ((NSNumber*)[((NSDictionary*)[lotsData.numberLots objectAtIndex:0]) objectForKey:LOTSDATA_NUMBER_RANGE]).intValue + start;
			for(i=start; i < end; ++i)
			{
				[array addObject: [NSNumber numberWithInt:i]];
			}
			[self.randomSequence setSrcArray:array];
		}
			break;
		case 2: // string
			lotsLabel.hidden = NO;
			[self.randomSequence setSrcArray: [lotsData.stringLots objectAtIndex:0]];
			break;
	}	
}

- (void) setLotsData: (LotsData*) newLots
{
	[lotsData release];
	lotsData = [newLots retain];
	[self.resultLots removeAllObjects];
	[self configRandomSequence];
}

- (void) resetLots
{
//	[self.resultLots removeAllObjects];
	[self configRandomSequence];

	if(self.resultLots.count == 0)
	{
		lotsLabel.text = NSLocalizedString(@"Press Start button", @"Press Start button");
		lotsLabel.font = [UIFont systemFontOfSize:20];
		lotsLabel.hidden = NO;
	}
	barButtonStart.title = NSLocalizedString(@"Start", @"Start");

	CGRect newFrame = remainderBar.frame;
	newFrame.size.width = (remainderBarBase.bounds.size.width-2) * [self.randomSequence getRemainingLotsPercentage];
	remainderBar.frame = newFrame;

	self.navigationItem.rightBarButtonItem.enabled = YES;
	barButtonResult.enabled = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	self.title = self.lotsData.lotsName;

	[self resetLots];
	
	bigButton.enabled = barButtonStart.enabled = YES;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[UIAccelerometer sharedAccelerometer].delegate = nil;
	[lastAcceleration release];
	
	[lotsData release];
	[resultLots release];
	
	[lotsView release];
	[barButtonStart release];
	[lotsLabel release];
	[indicatorView release];
	[randomSequence release];	
	[remainderBar release];
	[remainderBarBase release];
	
	[bigButton release];
	[self stopUpdateTimer];
	
    [super dealloc];
}


- (void) startBarButtonDown:(id)sender
{
	if(sender == nil && [barButtonStart.title isEqualToString:NSLocalizedString(@"Start", @"Start")])
	{
		triggeredByShake = YES;
	}
	else
		triggeredByShake = NO;
	if(updateTimer == nil)
	{
		if(self.randomSequence.srcArray.count == 0)
		{
			[self resetLots];
			return;
		}
				
		lotsLabel.hidden = (((NSNumber*)[lotsData.groupTypes objectAtIndex:0]).intValue == 0);
		if(((NSNumber*)[lotsData.groupTypes objectAtIndex:0]).intValue == 1)
		{
			lotsLabel.text = @"";
			lotsLabel.font = [UIFont systemFontOfSize:100];
		}
		if(((NSNumber*)[lotsData.groupTypes objectAtIndex:0]).intValue == 2)
		{
			lotsLabel.text = @"";
			lotsLabel.font = [UIFont systemFontOfSize:20];
		}
		barButtonStart.title = NSLocalizedString(@"Stop", @"Stop");
		bigButton.enabled = barButtonStart.enabled = YES;
		indicatorView.hidden = NO;

		self.navigationItem.rightBarButtonItem.enabled = NO;
		barButtonResult.enabled = NO;

		[indicatorView startAnimating];
		[self.randomSequence startGenerating];
		[self startUpdateTimer];
	}
	else
	{
		barButtonStart.title = NSLocalizedString(@"Wait", @"Wait");
		bigButton.enabled = barButtonStart.enabled = NO;
		[self.randomSequence stopGenerating];
	}
}

- (void) editBarButtonDown:(id)sender
{
	EditLotsController *controller = [[EditLotsController alloc] initWithNibName:@"EditLotsController" bundle:nil];
	controller.lotsData = self.lotsData;
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

- (void) resultBarButtonDown:(id)sender
{
	HistoryController *controller = [[HistoryController alloc] initWithNibName:@"HistoryController" bundle:nil];
	controller.result = self.resultLots;
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

- (void) lotGenerated
{
	id data1 = [[self.randomSequence getResult] objectForKey:RS_DATA];
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
		[NSNumber numberWithInt:1], HISTORY_DATA_COUNT, data1, HISTORY_DATA_1, nil];
	[self.resultLots insertObject:dict atIndex:0];
	[self.randomSequence removeLatestResult:!((NSNumber*)[lotsData.repeatables objectAtIndex:0]).boolValue];

	CGRect newFrame = remainderBar.frame;
	newFrame.size.width = (remainderBarBase.bounds.size.width-2) * [self.randomSequence getRemainingLotsPercentage];
	remainderBar.frame = newFrame;
	if(self.randomSequence.srcArray.count == 0)
	{
		barButtonStart.title = NSLocalizedString(@"Reset", @"Reset");
	}
	else
	{
		barButtonStart.title = NSLocalizedString(@"Start", @"Start");
		self.navigationItem.rightBarButtonItem.enabled = YES;
		barButtonResult.enabled = YES;
	}
	bigButton.enabled = barButtonStart.enabled = YES;
	[indicatorView stopAnimating];
	indicatorView.hidden = YES;
}

- (void)timerFunc:(NSTimer *)timer 
{
	if([self.randomSequence getResultCount] == 0)
		return;
	NSMutableDictionary *dict = [self.randomSequence getResult];
	id data = [dict objectForKey:RS_DATA];
	int occurence = ((NSNumber*)[dict objectForKey:RS_OCCURENCE]).intValue;

	switch(((NSNumber*)[lotsData.groupTypes objectAtIndex:0]).intValue)
	{
		case 0:
		{
			for(int i=0;i<lotsView.subviews.count;++i)
			{
				if([[lotsView.subviews objectAtIndex:i] isKindOfClass:[UIKeepRatioImageView class]])
				{
					[[lotsView.subviews objectAtIndex:i] removeFromSuperview];
				}
			}
			UIKeepRatioImageView *cur = [[UIKeepRatioImageView alloc] initWithFrame:CGRectZero andImage:data];
			cur.frame = lotsView.bounds;
			[lotsView addSubview:cur];
			[cur release];
		}
			break;
		case 1:
		case 2:
		{
			
			lotsLabel.text = [NSString stringWithFormat:@"%@", data];
		}
			break;
	}
	if([self.randomSequence getResultCount] == 1 && occurence <= 1)
	{
		[self stopUpdateTimer];
		[self lotGenerated];
		return;
	}
	if(occurence <= 1)
	{
		[self.randomSequence removeLatestResult:NO]; 
	}
	else
	{
		[dict setObject:[NSNumber numberWithInt:--occurence] forKey:RS_OCCURENCE];
	}
}


- (void) stopUpdateTimer
{
	[updateTimer invalidate];
	updateTimer = nil;
}

#define UPDATE_PERIOD 0.1
- (void) startUpdateTimer
{
	[self stopUpdateTimer];
	updateTimer = [NSTimer scheduledTimerWithTimeInterval:UPDATE_PERIOD
												   target:self
												 selector:@selector(timerFunc:)
												 userInfo:nil
												  repeats:YES];
}


- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
	if(lastAcceleration)
	{
		UIAccelerationValue x = lastAcceleration.x - acceleration.x;
		UIAccelerationValue y = lastAcceleration.y - acceleration.y;
		UIAccelerationValue z = lastAcceleration.z - acceleration.z;
		x = x * x;
		y = y * y;
		z = z * z;
//		NSLog(@"(%f, %f, %f) %f", acceleration.x, acceleration.y, acceleration.z, (x + y + z));
		if((x + y + z) >= 0.8)
		{
			if(accelerationChanged < 3)
				++accelerationChanged;
		}
		else
		{
			//accelerationChanged = 0;
			if(accelerationChanged > 0)
				--accelerationChanged;
		}
		if(accelerationChanged >= 3)
		{
			if([barButtonStart.title isEqualToString:NSLocalizedString(@"Start", @"Start")])
			{
				NSLog(@"Motion Started");
				[self startBarButtonDown:nil];
			}
		}
		else if(triggeredByShake && accelerationChanged == 0)
		{
			if([barButtonStart.title isEqualToString:NSLocalizedString(@"Stop", @"Stop")])
			{
				NSLog(@"Motion Ended");
				[self startBarButtonDown:nil];
			}
		}
	}

	[lastAcceleration release];
	lastAcceleration = [acceleration retain];
}

@end
