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

- (void) setLotsData: (LotsData*) newLots
{
	[lotsData release];
	lotsData = [newLots retain];
	[self.resultLots removeAllObjects];
	switch(lotsData.group1Type)
	{
		case 0: // photo
			lotsLabel.hidden = YES;
			[randomSequence setSrcArray:lotsData.photoLots1];
			break;
		case 1: // number
		{
			int i;
			lotsLabel.hidden = NO;
			NSMutableArray *array = [NSMutableArray arrayWithCapacity: lotsData.numberLots1.length];
			for(i=lotsData.numberLots1.location; i < (lotsData.numberLots1.location+lotsData.numberLots1.length); ++i)
			{
				[array addObject: [NSNumber numberWithInt:i]];
			}
			[self.randomSequence setSrcArray:array];
		}
			break;
		case 2: // string
			lotsLabel.hidden = NO;
			[self.randomSequence setSrcArray:lotsData.stringLots1];
			break;
	}
}

- (void) resetLots
{
	[self.resultLots removeAllObjects];
	switch(lotsData.group1Type)
	{
		case 0: // photo
			lotsLabel.hidden = YES;
			[self.randomSequence setSrcArray:lotsData.photoLots1];
			break;
		case 1: // number
		{
			int i;
			lotsLabel.hidden = NO;
			NSMutableArray *array = [NSMutableArray arrayWithCapacity: lotsData.numberLots1.length];
			for(i=lotsData.numberLots1.location; i< (lotsData.numberLots1.location+lotsData.numberLots1.length); ++i)
			{
				[array addObject: [NSNumber numberWithInt:i]];
			}
			[self.randomSequence setSrcArray:array];
		}
			break;
		case 2: // string
			lotsLabel.hidden = NO;
			[self.randomSequence setSrcArray:lotsData.stringLots1];
			break;
	}

	barButtonStart.title = NSLocalizedString(@"Start", @"Start");
	lotsLabel.text = NSLocalizedString(@"Press Start button", @"Press Start button");
	lotsLabel.font = [UIFont systemFontOfSize:20];
	CGRect newFrame = remainderBar.frame;
	newFrame.size.width = (remainderBarBase.bounds.size.width-2) * [self.randomSequence getRemainingLotsPercentage];
	remainderBar.frame = newFrame;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	self.title = self.lotsData.lotsName;
	CGRect newFrame = remainderBar.frame;
	newFrame.size.width = (remainderBarBase.bounds.size.width-2) * [self.randomSequence getRemainingLotsPercentage];
	remainderBar.frame = newFrame;
	
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
	[barButtonStart release];
	[lotsLabel release];
	[indicatorView release];
	
	[remainderBar release];
	[remainderBarBase release];
	[self stopUpdateTimer];
	
	[randomSequence release];
    [super dealloc];
}


- (void) startBarButtonDown:(id)sender
{
	if(updateTimer == nil)
	{
		if(self.randomSequence.srcArray.count == 0)
		{
			[self resetLots];
			return;
		}
				
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
		indicatorView.hidden = NO;
		[indicatorView startAnimating];
		[self.randomSequence startGenerating];
		[self startUpdateTimer];
	}
	else
	{
		barButtonStart.title = NSLocalizedString(@"Wait", @"Wait");
		barButtonStart.enabled = NO;
		[self.randomSequence stopGenerating];
	}
}

- (void) editBarButtonDown:(id)sender
{
	CreateLotsController *controller = [[CreateLotsController alloc] initWithNibName:@"CreateLotsController" bundle:nil];
	controller.lotsData = self.lotsData;
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

- (void) lotGenerated
{
	[self.resultLots insertObject:[[self.randomSequence getResult] objectForKey:RS_DATA] atIndex:0];
	[self.randomSequence removeLatestResult:!self.lotsData.repeatableLots1];

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
	}
	barButtonStart.enabled = YES;
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

@end
