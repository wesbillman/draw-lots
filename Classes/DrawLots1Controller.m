//
//  DrawLots1Controller.m
//  PickOneForMe
//
//  Created by Chung Glen on 2009/6/8.
//  Copyright 2009 Appiness Software. All rights reserved.
//

#import "DrawLots1Controller.h"
#import "CreateLotsController.h"
#import "LotsData.h"
#import "UIKeepRatioImageView.h"

@implementation DrawLots1Controller
@synthesize lotsData, currentLots, resultLots;

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
}

- (NSMutableArray *) currentLots {
    if (currentLots == nil) {
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:200];
        self.currentLots = array;
        [array release];
    }
    return currentLots;
}

- (NSMutableArray *) resultLots {
    if (resultLots == nil) {
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:200];
        self.resultLots = array;
        [array release];
    }
    return resultLots;
}

- (void) setLotsData: (LotsData*) newLots
{
	[lotsData release];
	lotsData = [newLots retain];
	repeatableSwitch.on = self.lotsData.repeatableLots1;
	[self.currentLots removeAllObjects];
	[self.resultLots removeAllObjects];
	switch(lotsData.group1Type)
	{
		case 0: // photo
			lotsLabel.hidden = YES;
			[self.currentLots addObjectsFromArray:lotsData.photoLots1];
			break;
		case 1: // number
		{
			int i;
			lotsLabel.hidden = NO;
			for(i=lotsData.numberLots1.location; i< (lotsData.numberLots1.location+lotsData.numberLots1.length); ++i)
			{
				[self.currentLots addObject: [NSNumber numberWithInt:i]];
			}
		}
			break;
		case 2: // string
			lotsLabel.hidden = NO;
			[self.currentLots addObjectsFromArray:lotsData.stringLots1];
			break;
	}
}

- (void) resetLots
{
	[self.currentLots removeAllObjects];
	[self.resultLots removeAllObjects];
	switch(lotsData.group1Type)
	{
		case 0: // photo
			lotsLabel.hidden = YES;
			[self.currentLots addObjectsFromArray:lotsData.photoLots1];
			break;
		case 1: // number
		{
			int i;
			lotsLabel.hidden = NO;
			for(i=lotsData.numberLots1.location; i< (lotsData.numberLots1.location+lotsData.numberLots1.length); ++i)
			{
				[self.currentLots addObject: [NSNumber numberWithInt:i]];
			}
		}
			break;
		case 2: // string
			lotsLabel.hidden = NO;
			[self.currentLots addObjectsFromArray:lotsData.stringLots1];
			break;
	}
	lastResultLabel.text = @"";
	barButtonStart.title = NSLocalizedString(@"Start", @"Start");
	lotsLabel.text = NSLocalizedString(@"Press Start button", @"Press Start button");
	lotsLabel.font = [UIFont systemFontOfSize:20];
	remainderLotsLabel.text = [NSString stringWithFormat:@"%d", self.currentLots.count];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	self.title = self.lotsData.lotsName;
	repeatableSwitch.on = self.lotsData.repeatableLots1;
	remainderLotsLabel.text = [NSString stringWithFormat:@"%d", self.currentLots.count];

	barButtonStart.enabled = YES;
	lotsLabel.hidden = NO;
	lotsLabel.text = NSLocalizedString(@"Press Start button", @"Press Start button");
	lotsLabel.font = [UIFont systemFontOfSize:20];
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
	[resultLots release];
	[lotsData release];
	[lotsView release];
	[lastResultView release];
	[repeatableSwitch release];
	[lastResultLabel release];
	[barButtonStart release];
	[lotsLabel release];
	
	[self stopUpdateTimer];
	[currentLots release];
	[lastFewLotsForAnamation release];
    [super dealloc];
}

- (int) nextRandomNumber
{
	int randValue = rand() % currentLots.count;
	if(currentLots.count > 1)
	{
		randValue = (rand() % currentLots.count);
		while(randValue == lastRandomValue)
		{
			randValue = (rand() % currentLots.count);
		}
	}
	lastRandomValue = randValue;
	return randValue;
}

- (void) generateALot
{
	int i, j, r;
	[lastFewLotsForAnamation release];
	NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:100];
	for(i=0;i<10;++i)
	{
		r = [self nextRandomNumber];
		for(j=9-i;j<10;++j)
			[array addObject:[NSNumber numberWithInt: r]];
	}
	lastFewLotsForAnamation = array;
}

- (void) startBarButtonDown:(id)sender
{
	if(updateTimer == nil)
	{
		if(self.currentLots.count == 0)
		{
			[self resetLots];
			return;
		}
				
		[lastFewLotsForAnamation removeAllObjects];
		lotsLabel.hidden = (self.lotsData.group1Type == 0);
		if(self.lotsData.group1Type == 1)
		{
			lotsLabel.text = @"";
			lotsLabel.font = [UIFont systemFontOfSize:100];
		}
		if(self.lotsData.group1Type == 2)
		{
			lotsLabel.text = @"";
			lotsLabel.font = [UIFont systemFontOfSize:20];
		}
		barButtonStart.title = NSLocalizedString(@"Stop", @"Stop");
		barButtonStart.enabled = YES;
		[self startUpdateTimer];
	}
	else
	{
		barButtonStart.title = NSLocalizedString(@"Wait", @"Wait");
		barButtonStart.enabled = NO;
		[self generateALot];
	}
}

- (void) editBarButtonDown:(id)sender
{
	CreateLotsController *controller = [[CreateLotsController alloc] initWithNibName:@"CreateLotsController" bundle:nil];
	controller.lotsData = self.lotsData;
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

- (void) lotGenerated: (int) index
{
	NSMutableArray *array = lastFewLotsForAnamation;
	lastFewLotsForAnamation = nil;
	[array release];
	[self.resultLots insertObject:[self.currentLots objectAtIndex:index] atIndex: 0];
	switch(lotsData.group1Type)
	{
		case 0:
		{
			for(int i=0;i<lastResultView.subviews.count;++i)
			{
				if([[lastResultView.subviews objectAtIndex:i] isKindOfClass:[UIKeepRatioImageView class]])
				{
					[[lastResultView.subviews objectAtIndex:i] removeFromSuperview];
				}
			}
			UIKeepRatioImageView *cur = [currentLots objectAtIndex:index];
			cur.frame = lastResultView.bounds;
			[lastResultView addSubview:cur];
		}
			break;
		case 1:
		case 2:
		{
			lastResultLabel.text = [NSString stringWithFormat:@"%@", [currentLots objectAtIndex:index]];
		}
			break;
	}
	if(repeatableSwitch.on == NO)
	{
		[self.currentLots removeObjectAtIndex:index];
	}
	remainderLotsLabel.text = [NSString stringWithFormat:@"%d", self.currentLots.count];
	if(self.currentLots.count == 0)
	{
		barButtonStart.title = NSLocalizedString(@"Reset", @"Reset");
	}
	else
	{
		barButtonStart.title = NSLocalizedString(@"Start", @"Start");
	}
	barButtonStart.enabled = YES;
}

- (void)timerFunc:(NSTimer *)timer 
{
	int randValue;
	if(lastFewLotsForAnamation != nil)
	{
		if(lastFewLotsForAnamation.count == 0)
			return;
		randValue = ((NSNumber*)[lastFewLotsForAnamation objectAtIndex:0]).intValue;
		[lastFewLotsForAnamation removeObjectAtIndex:0];
	}
	else
		randValue = [self nextRandomNumber];
	switch(lotsData.group1Type)
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
			UIKeepRatioImageView *cur = [currentLots objectAtIndex:randValue];
			NSLog(@"1: image %d\n", randValue);
			cur.frame = lotsView.bounds;
			[lotsView addSubview:cur];
		}
			break;
		case 1:
		case 2:
		{
			
			lotsLabel.text = [NSString stringWithFormat:@"%@", [currentLots objectAtIndex:randValue]];
		}
			break;
	}
	
	if(lastFewLotsForAnamation != nil)
	{
		if(lastFewLotsForAnamation.count == 0)
		{
			[self stopUpdateTimer];
			[self lotGenerated:randValue];
			NSLog(@"2: image %d\n", randValue);
		}
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

- (void) repeatableSwitchValueChanged:(id)sender
{
	self.lotsData.repeatableLots1 = repeatableSwitch.on;
}

@end
