//
//  UIKeepRatioImageView.h
//  PickOneForMe
//
//  Created by Chung Glen on 2009/6/7.
//  Copyright 2009 Appiness Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIKeepRatioImageView : UIView {
	UIImage *srcImage;
	UIImageView *image;
}
- (id)initWithFrame:(CGRect)frame andImage:(UIImage*) img;

@end
