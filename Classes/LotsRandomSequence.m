//
//  LotsRandomSequence.m
//  PickOneForMe
//
//  Created by Chung Glen on 2009/6/9.
//  Copyright 2009 Appiness Software. All rights reserved.
//

#import "LotsRandomSequence.h"

#define EXTRA_RANDOM_SIZE_WHEN_STOP 10

@implementation LotsRandomSequence
@synthesize srcArray, randSequence, lastResult;

- (id) initWithSize:(int) size;
{
	if(self = [super init])
	{
		sequenceSize = size;
		self.srcArray = nil;
	}
	return self;
}

- (NSMutableArray *) randSequence {
    if (randSequence == nil) {
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:(sequenceSize+EXTRA_RANDOM_SIZE_WHEN_STOP)];
        self.randSequence = array;
        [array release];
    }
    return randSequence;
}

- (float) getRemainingLotsPercentage
{
	if(originalSrcSize)
		return ((float)self.srcArray.count) / originalSrcSize;
	return 0.0;
}


- (void) setSrcArray:(NSMutableArray*) newArray
{
    if (srcArray == nil) {
        srcArray = [[NSMutableArray alloc] initWithCapacity:256];
    }
	[srcArray removeAllObjects];
	if(newArray)
		[srcArray addObjectsFromArray:newArray];
	originalSrcSize = srcArray.count;
	[self.randSequence removeAllObjects];
	[lastResult release];
	lastResult = nil;
	keepGenerating = NO;
}

- (int) nextRandomNumber
{
	int randValue = rand() % srcArray.count;
	if(srcArray.count > 1)
	{
		randValue = (rand() % srcArray.count);
		while(randValue == lastRandomValue)
		{
			randValue = (rand() % srcArray.count);
		}
	}
	lastRandomValue = randValue;
	return randValue;
}


- (void) startGenerating
{
	keepGenerating = YES;
	lastRandomValue = -1;
	[lastResult release];
	lastResult = nil;
	[self.randSequence removeAllObjects];
	for(int i=0;i<sequenceSize;++i)
	{
		[self.randSequence addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
			[srcArray objectAtIndex:[self nextRandomNumber]], RS_DATA, [NSNumber numberWithInt:1], RS_OCCURENCE, nil]];
	}
}

- (void) stopGenerating
{
	keepGenerating = NO;
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:EXTRA_RANDOM_SIZE_WHEN_STOP];
	for(int i=1;i<=EXTRA_RANDOM_SIZE_WHEN_STOP;i+=2)
	{
		[array addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
			[srcArray objectAtIndex:[self nextRandomNumber]], RS_DATA, [NSNumber numberWithInt:i], RS_OCCURENCE, nil]];
	}
	[self.randSequence addObjectsFromArray:array];
}

- (int) getResultCount
{
	return self.randSequence.count;
}

- (NSMutableDictionary*) getResult
{
	if(self.randSequence.count > 0)
		return [self.randSequence objectAtIndex:0];
	return nil;
}

- (void) removeLatestResult:(BOOL)srcArrayAlso
{
	[lastResult release];
	lastResult = [[self.randSequence objectAtIndex:0] retain];
	[self.randSequence removeObjectAtIndex:0];
	if(keepGenerating)
	{
		[self.randSequence addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
			[srcArray objectAtIndex:[self nextRandomNumber]], RS_DATA, [NSNumber numberWithInt:1], RS_OCCURENCE, nil]];
	}
	if(srcArrayAlso)
	{
		[srcArray removeObject:[lastResult objectForKey:RS_DATA]];
	}
}

- (void)dealloc {
	[lastResult release];
	[srcArray release];
	[randSequence release];
    [super dealloc];
}

@end
