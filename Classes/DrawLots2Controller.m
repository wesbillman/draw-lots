//
//  DrawLots2Controller.m
//  PickOneForMe
//
//  Created by Chung Glen on 2009/6/8.
//  Copyright 2009 Appiness Software. All rights reserved.
//

#import "DrawLots2Controller.h"
#import "CreateLotsController.h"
#import "LotsData.h"
#import "UIKeepRatioImageView.h"
#import "HistoryController.h"

@implementation DrawLots2Controller
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

- (LotsRandomSequence *) randomSequence2 {
    if (randomSequence2 == nil) {
		randomSequence2 = [[LotsRandomSequence alloc] initWithSize: 10];
    }
    return randomSequence2;
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

	switch(((NSNumber*)[lotsData.groupTypes objectAtIndex:1]).intValue)
	{
		case 0: // photo
			lotsLabel2.hidden = YES;
			[self.randomSequence2 setSrcArray: [lotsData.photoLots objectAtIndex:1]];
			break;
		case 1: // number
		{
			int i;
			lotsLabel2.hidden = NO;
			NSMutableArray *array = [NSMutableArray arrayWithCapacity: ((NSNumber*)[((NSDictionary*)[lotsData.numberLots objectAtIndex:1]) objectForKey:LOTSDATA_NUMBER_RANGE]).intValue];
			int start = ((NSNumber*)[((NSDictionary*)[lotsData.numberLots objectAtIndex:1]) objectForKey:LOTSDATA_NUMBER_START]).intValue;
			int end = ((NSNumber*)[((NSDictionary*)[lotsData.numberLots objectAtIndex:1]) objectForKey:LOTSDATA_NUMBER_RANGE]).intValue + start;
			for(i=start; i < end; ++i)
			{
				[array addObject: [NSNumber numberWithInt:i]];
			}
			[self.randomSequence2 setSrcArray:array];
		}
			break;
		case 2: // string
			lotsLabel2.hidden = NO;
			[self.randomSequence2 setSrcArray: [lotsData.stringLots objectAtIndex:1]];
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
	[self.resultLots removeAllObjects];
	[self configRandomSequence];
	
	barButtonStart.title = NSLocalizedString(@"Start", @"Start");
	lotsLabel.text = NSLocalizedString(@"Press Start button", @"Press Start button");
	lotsLabel.font = [UIFont systemFontOfSize:20];
	lotsLabel2.text = NSLocalizedString(@"Press Start button", @"Press Start button");
	lotsLabel2.font = [UIFont systemFontOfSize:20];
	CGRect newFrame = remainderBar.frame;
	newFrame.size.width = (remainderBarBase.bounds.size.width-2) * [self.randomSequence getRemainingLotsPercentage];
	remainderBar.frame = newFrame;
	newFrame = remainderBar2.frame;
	newFrame.size.width = (remainderBarBase2.bounds.size.width-2) * [self.randomSequence2 getRemainingLotsPercentage];
	remainderBar2.frame = newFrame;

	self.navigationItem.rightBarButtonItem.enabled = YES;
	barButtonResult.enabled = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	self.title = self.lotsData.lotsName;
	CGRect newFrame = remainderBar.frame;
	newFrame.size.width = (remainderBarBase.bounds.size.width-2) * [self.randomSequence getRemainingLotsPercentage];
	remainderBar.frame = newFrame;
	newFrame = remainderBar2.frame;
	newFrame.size.width = (remainderBarBase2.bounds.size.width-2) * [self.randomSequence2 getRemainingLotsPercentage];
	remainderBar2.frame = newFrame;
	
	[self resetLots];
	
	barButtonStart.enabled = YES;
	lotsLabel.hidden = NO;
	lotsLabel.text = NSLocalizedString(@"Press Start button", @"Press Start button");
	lotsLabel.font = [UIFont systemFontOfSize:20];
	lotsLabel2.hidden = NO;
	lotsLabel2.text = NSLocalizedString(@"Press Start button", @"Press Start button");
	lotsLabel2.font = [UIFont systemFontOfSize:20];
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
	[lotsData release];
	[resultLots release];
	
	[lotsView release];
	[barButtonStart release];
	[lotsLabel release];
	[indicatorView release];
	[randomSequence release];
	[remainderBar release];
	[remainderBarBase release];
	
	[self stopUpdateTimer];
	
	[lotsView2 release];
	[lotsLabel2 release];
	[remainderBar2 release];
	[remainderBarBase2 release];
	[indicatorView2 release];
	[randomSequence2 release];
	
    [super dealloc];
}


- (void) startBarButtonDown:(id)sender
{
	if(updateTimer == nil)
	{
 		if(self.randomSequence.srcArray.count == 0 || self.randomSequence2.srcArray.count == 0)
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
		indicatorView.hidden = NO;
		[indicatorView startAnimating];
		[self.randomSequence startGenerating];

		lotsLabel2.hidden = (((NSNumber*)[lotsData.groupTypes objectAtIndex:1]).intValue == 0);
		if(((NSNumber*)[lotsData.groupTypes objectAtIndex:1]).intValue == 1)
		{
			lotsLabel2.text = @"";
			lotsLabel2.font = [UIFont systemFontOfSize:100];
		}
		if(((NSNumber*)[lotsData.groupTypes objectAtIndex:1]).intValue == 2)
		{
			lotsLabel2.text = @"";
			lotsLabel2.font = [UIFont systemFontOfSize:20];
		}
		indicatorView2.hidden = NO;
		[indicatorView2 startAnimating];
		[self.randomSequence2 startGenerating];
		
		barButtonStart.title = NSLocalizedString(@"Stop", @"Stop");
		barButtonStart.enabled = YES;

		self.navigationItem.rightBarButtonItem.enabled = NO;
		barButtonResult.enabled = NO;
		[self startUpdateTimer];
	}
	else
	{
		barButtonStart.title = NSLocalizedString(@"Wait", @"Wait");
		barButtonStart.enabled = NO;
		[self.randomSequence stopGenerating];
		[self.randomSequence2 stopGenerating];
	}
}

- (void) editBarButtonDown:(id)sender
{
	CreateLotsController *controller = [[CreateLotsController alloc] initWithNibName:@"CreateLotsController" bundle:nil];
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
	[self.resultLots insertObject:[[self.randomSequence getResult] objectForKey:RS_DATA] atIndex:0];
	[self.randomSequence removeLatestResult:!((NSNumber*)[lotsData.repeatables objectAtIndex:0]).boolValue];
	[self.randomSequence2 removeLatestResult:!((NSNumber*)[lotsData.repeatables objectAtIndex:1]).boolValue];
	
	CGRect newFrame = remainderBar.frame;
	newFrame.size.width = (remainderBarBase.bounds.size.width-2) * [self.randomSequence getRemainingLotsPercentage];
	remainderBar.frame = newFrame;
	newFrame = remainderBar2.frame;
	newFrame.size.width = (remainderBarBase2.bounds.size.width-2) * [self.randomSequence2 getRemainingLotsPercentage];
	remainderBar2.frame = newFrame;
	
	if(self.randomSequence.srcArray.count == 0 || self.randomSequence2.srcArray.count == 0)
	{
		barButtonStart.title = NSLocalizedString(@"Reset", @"Reset");
	}
	else
	{
		barButtonStart.title = NSLocalizedString(@"Start", @"Start");
		self.navigationItem.rightBarButtonItem.enabled = YES;
		barButtonResult.enabled = YES;
	}
	barButtonStart.enabled = YES;
	[indicatorView stopAnimating];
	indicatorView.hidden = YES;
	[indicatorView2 stopAnimating];
	indicatorView2.hidden = YES;
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

	NSMutableDictionary *dict2 = [self.randomSequence2 getResult];
	id data2 = [dict2 objectForKey:RS_DATA];
	int occurence2 = ((NSNumber*)[dict2 objectForKey:RS_OCCURENCE]).intValue;
	
	switch(((NSNumber*)[lotsData.groupTypes objectAtIndex:1]).intValue)
	{
		case 0:
		{
			for(int i=0;i<lotsView2.subviews.count;++i)
			{
				if([[lotsView2.subviews objectAtIndex:i] isKindOfClass:[UIKeepRatioImageView class]])
				{
					[[lotsView2.subviews objectAtIndex:i] removeFromSuperview];
				}
			}
			UIKeepRatioImageView *cur = [[UIKeepRatioImageView alloc] initWithFrame:CGRectZero andImage:data2];
			cur.frame = lotsView2.bounds;
			[lotsView2 addSubview:cur];
			[cur release];
		}
			break;
		case 1:
		case 2:
		{
			
			lotsLabel2.text = [NSString stringWithFormat:@"%@", data2];
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
		[self.randomSequence2 removeLatestResult:NO]; 
	}
	else
	{
		[dict setObject:[NSNumber numberWithInt:--occurence] forKey:RS_OCCURENCE];
		[dict2 setObject:[NSNumber numberWithInt:--occurence2] forKey:RS_OCCURENCE];
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

@end
