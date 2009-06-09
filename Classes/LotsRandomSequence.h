//
//  LotsRandomSequence.h
//  PickOneForMe
//
//  Created by Chung Glen on 2009/6/9.
//  Copyright 2009 Appiness Software. All rights reserved.
//

#import <Foundation/Foundation.h>


#define RS_DATA			@"RS_DATA"
#define RS_OCCURENCE	@"RS_OCCURENCE"

@interface LotsRandomSequence : NSObject {
	NSMutableArray	*srcArray;
	NSMutableArray	*randSequence;
	NSMutableDictionary	*lastResult;
	BOOL			keepGenerating;
	int				sequenceSize;
	int				lastRandomValue;
	int				originalSrcSize;
}

@property (nonatomic, retain) NSMutableArray	*srcArray;
@property (nonatomic, retain) NSMutableArray	*randSequence;
@property (nonatomic, retain) NSMutableDictionary		*lastResult;



- (id) initWithSize:(int) size;
- (void) startGenerating;
- (void) stopGenerating;
- (int) getResultCount;
- (NSMutableDictionary*) getResult;
- (void) removeLatestResult:(BOOL)srcArrayAlso;
- (float) getRemainingLotsPercentage;
@end
