//
//  HistoryController.m
//  PickOneForMe
//
//  Created by Chung Glen on 2009/6/9.
//  Copyright 2009 Appiness Software. All rights reserved.
//

#import "HistoryController.h"
#import "UIKeepRatioImageView.h"

@implementation HistoryController
@synthesize result;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

- (void)viewWillAppear:(BOOL)animated {
	[tableView reloadData];
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
	[result release];
    [super dealloc];
}

#pragma mark Table Content and Appearance

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
	return 2;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
	switch(section)
	{
		case 0:
			if(result)
				return result.count;
			break;
		case 1:
			return 1;
	}
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
	switch(indexPath.section)
	{
		case 0:
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableViewImageCell"] autorelease];
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				cell.textLabel.textAlignment = UITextAlignmentCenter;
				cell.textLabel.font = [UIFont systemFontOfSize:40];
			}
			id data = [result objectAtIndex:indexPath.row];
			if([data isKindOfClass:[UIImage class]])
			{
				for(int i=0;i<cell.subviews.count;++i)
				{
					if([[cell.subviews objectAtIndex:i] isKindOfClass:[UIKeepRatioImageView class]])
					{
						[[cell.subviews objectAtIndex:i] removeFromSuperview];
					}
				}

				UIKeepRatioImageView *curView = [[UIKeepRatioImageView alloc] initWithFrame:CGRectZero andImage:data];

				CGRect rect;
				rect.size.width = 60;
				rect.size.height = 60;
				rect.origin.x = (tableView.bounds.size.width - 60) / 2;
				rect.origin.y = 0;
				curView.frame = rect;
				[cell addSubview:curView];
				[curView release];
			}
			else
			{
				cell.textLabel.text = [NSString stringWithFormat:@"%@", data];
			}
				break;
		case 1:
		{
			cell = (UITableViewCell *)[aTableView dequeueReusableCellWithIdentifier:@"TableViewCountCell"];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableViewCountCell"] autorelease];
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				cell.textLabel.textAlignment = UITextAlignmentCenter;
				cell.textLabel.font = [UIFont systemFontOfSize:40];
			}
			cell.textLabel.text = [NSString stringWithFormat: NSLocalizedString(@"%d Data", @"%d Data"), result.count];
		}
			break;
				
	}

	return cell;
}

@end
