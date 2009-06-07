//
//  DrawLots2Controller.h
//  PickOneForMe
//
//  Created by Chung Glen on 2009/6/8.
//  Copyright 2009 Appiness Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LotsData.h"

@interface DrawLots2Controller : UIViewController {
	LotsData *lotsData;
}

@property (nonatomic, retain) LotsData *lotsData;
@end
