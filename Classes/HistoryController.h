//
//  HistoryController.h
//  PickOneForMe
//
//  Created by Chung Glen on 2009/6/9.
//  Copyright 2009 Appiness Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HistoryController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	IBOutlet UITableView* tableView;
	NSMutableArray *result;
}

@property (nonatomic, retain) NSMutableArray *result;

@end
