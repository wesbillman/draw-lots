//
//  UIKeepRatioImageView.m
//  PickOneForMe
//
//  Created by Chung Glen on 2009/6/7.
//  Copyright 2009 Appiness Software. All rights reserved.
//

#import "UIKeepRatioImageView.h"


@implementation UIKeepRatioImageView
@synthesize delegate, srcImage;

- (id)initWithFrame:(CGRect)frame andImage:(UIImage*) img{
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		srcImage = [img retain];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
	if(self.bounds.size.width != 0 && self.bounds.size.height != 0 &&
	   srcImage.size.width != 0 && srcImage.size.height != 0)
	{
		if(image)
		{
			[image removeFromSuperview];
			[image release];
		}
		CGSize imageSize = srcImage.size;
		CGSize boundsSize = self.bounds.size;
		float witdhRatio = imageSize.width / boundsSize.width;
		float heightRatio = imageSize.height / boundsSize.height;
		float ratio;
		if(witdhRatio >= heightRatio)
		{
			ratio = heightRatio;
		}
		else
		{
			ratio = witdhRatio;
		}
		float deltaWidth = (int)((imageSize.width - ratio * boundsSize.width) / 2);
		float deltaHeight = (int)((imageSize.height - ratio * boundsSize.height) / 2);
		CGRect rect;
		rect.origin.x = deltaWidth + 2;
		rect.origin.y = deltaHeight + 2;
		rect.size.width = imageSize.width - 2*deltaWidth - 4;
		rect.size.height = imageSize.height - 2*deltaHeight - 4;
		CGImageRef img = CGImageCreateWithImageInRect(srcImage.CGImage, rect);
		image = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:img]];
		rect.origin.x = 2;
		rect.origin.y = 2;
		rect.size.width = self.frame.size.width - 4;
		rect.size.height = self.frame.size.height - 4;
		image.frame = rect;
		[self addSubview:image];
		CGImageRelease(img);
	}
}


- (void)dealloc {
	[srcImage release];
	[image release];
	self.delegate = nil;
    [super dealloc];
}

#if 0
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
	if(CGRectContainsPoint(image.frame, point))
	{
		NSLog(@"Point %f, %f\n", point.x, point.y);
		return self;
	}
	return nil;
}
#endif

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch* touch = (UITouch*)[touches anyObject];
	CGPoint location = [touch locationInView:self];
	NSLog(@"(%f, %f, %f, %f) (%f, %f)", self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height, location.x, location.y);
	if(touches.count == 1 && CGRectContainsPoint(self.bounds, location))
	{
		touchBegin = YES;
	}
	else
	{
		touchBegin = NO;
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch* touch = (UITouch*)[touches anyObject];
	if(touchBegin && touches.count == 1 && CGRectContainsPoint(self.bounds, [touch locationInView:self]))
	{
		selected = !selected;
		if(selected)
		{
			if(delegate &&  [delegate respondsToSelector:@selector(didSelectedUIKeepRatioImageView:)])
			{
				[delegate didSelectedUIKeepRatioImageView:self];
				self.backgroundColor = [UIColor orangeColor];
			}
		}
		else
		{
			if(delegate &&  [delegate respondsToSelector:@selector(didUnselectedUIKeepRatioImageView:)])
			{
				[delegate didUnselectedUIKeepRatioImageView:self];
				self.backgroundColor = [UIColor grayColor];
			}
		}
	}
	touchBegin = NO;
}

@end
