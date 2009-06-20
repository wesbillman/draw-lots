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
			return (result.count == 0) ? 1 : 0;
	}
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
	switch(indexPath.section)
	{
		case 0:
		{
			NSDictionary* dict = [result objectAtIndex:indexPath.row];
			if(((NSNumber*)[dict objectForKey:HISTORY_DATA_COUNT]).intValue == 1)
			{
				cell = (UITableViewCell *)[aTableView dequeueReusableCellWithIdentifier:@"TableViewImageCell"];
				if (cell == nil) {
					cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableViewImageCell"] autorelease];
					cell.selectionStyle = UITableViewCellSelectionStyleNone;
					cell.textLabel.textAlignment = UITextAlignmentCenter;
					cell.textLabel.font = [UIFont systemFontOfSize:40];
				}
				id data = [dict objectForKey:HISTORY_DATA_1];
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
			}
			else
			{
				cell = (UITableViewCell *)[aTableView dequeueReusableCellWithIdentifier:@"TableViewImageCell2"];
				if (cell == nil) {
					cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableViewImageCell2"] autorelease];
					cell.selectionStyle = UITableViewCellSelectionStyleNone;
					CGRect rt1 = tableView.bounds;
					rt1.size.width = rt1.size.width/2;
					rt1.size.height = 60;
					CGRect rt2 = rt1;
					rt2.origin.x = rt2.size.width;
					UILabel *view = [[UILabel alloc] initWithFrame:rt1];
					view.tag = 1;
					view.font = [UIFont systemFontOfSize:40];
					view.textAlignment = UITextAlignmentCenter;
					[cell addSubview:view];
					[view release];
					
					view = [[UILabel alloc] initWithFrame:rt2];
					view.tag = 2;
					view.font = [UIFont systemFontOfSize:40];
					view.textAlignment = UITextAlignmentCenter;
					[cell addSubview:view];
					[view release];

					rt1.origin.x = (rt1.size.width - 60) / 2;
					rt1.size.width = rt1.size.height = 60;
					view = [[UIKeepRatioImageView alloc] initWithFrame:rt1 andImage:nil];
					view.tag = 3;
					[cell addSubview:view];
					[view release];
					
					rt2.origin.x += (rt2.size.width - 60) / 2;
					rt2.size.width = rt2.size.height = 60;
					view = [[UIKeepRatioImageView alloc] initWithFrame:rt2 andImage:nil];
					view.tag = 4;
					[cell addSubview:view];
					[view release];
				}

				id data = [dict objectForKey:HISTORY_DATA_1];
				id data2 = [dict objectForKey:HISTORY_DATA_2];
				if([data isKindOfClass:[UIImage class]])
				{
					((UIKeepRatioImageView*)[cell viewWithTag:3]).srcImage = data;
					//[((UIKeepRatioImageView*)[cell viewWithTag:3]) layoutSubviews];
				}
				else
				{
					((UILabel*)[cell viewWithTag:1]).text = [NSString stringWithFormat:@"%@", data];
				}
				if([data2 isKindOfClass:[UIImage class]])
				{
					((UIKeepRatioImageView*)[cell viewWithTag:4]).srcImage = data2;
					//[((UIKeepRatioImageView*)[cell viewWithTag:4]) layoutSubviews];
				}
				else
				{
					((UILabel*)[cell viewWithTag:2]).text = [NSString stringWithFormat:@"%@", data2];
				}
			}
			break;
		}
		case 1:
		{
			if(result.count == 0)
			{
				cell = (UITableViewCell *)[aTableView dequeueReusableCellWithIdentifier:@"TableViewCountCell"];
				if (cell == nil) {
					cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableViewCountCell"] autorelease];
					cell.selectionStyle = UITableViewCellSelectionStyleNone;
					cell.textLabel.textAlignment = UITextAlignmentCenter;
					cell.textLabel.font = [UIFont systemFontOfSize:40];
				}
				cell.textLabel.text = NSLocalizedString(@"No Result Yet!", @"No Result Yet!");
			}
		}
			break;
				
	}

	return cell;
}

@end
