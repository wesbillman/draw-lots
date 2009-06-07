//
//  UIKeepRatioImageView.m
//  PickOneForMe
//
//  Created by Chung Glen on 2009/6/7.
//  Copyright 2009 Appiness Software. All rights reserved.
//

#import "UIKeepRatioImageView.h"


@implementation UIKeepRatioImageView


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
		rect.origin.x = deltaWidth;
		rect.origin.y = deltaHeight;
		rect.size.width = imageSize.width - 2*deltaWidth;
		rect.size.height = imageSize.height - 2*deltaHeight; 
		CGImageRef img = CGImageCreateWithImageInRect(srcImage.CGImage, rect);
		image = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:img]];
		image.frame = self.bounds;
		[self addSubview:image];
		CGImageRelease(img);
	}
}


- (void)dealloc {
	[srcImage release];
	[image release];
    [super dealloc];
}


@end
