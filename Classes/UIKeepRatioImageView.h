//
//  UIKeepRatioImageView.h
//  PickOneForMe
//
//  Created by Chung Glen on 2009/6/7.
//  Copyright 2009 Appiness Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIKeepRatioImageView;

@protocol UIKeepRatioImageViewDelegate<NSObject>
@optional
- (void)didSelectedUIKeepRatioImageView:(UIKeepRatioImageView *)view;
- (void)didUnselectedUIKeepRatioImageView:(UIKeepRatioImageView *)view;
@end

@interface UIKeepRatioImageView : UIView {
	UIImage *srcImage;
	UIImageView *image;
	BOOL	touchBegin;
	BOOL	selected;
	id		delegate;
}
- (id)initWithFrame:(CGRect)frame andImage:(UIImage*) img;

@property (nonatomic, retain) id		delegate;
@property (nonatomic, retain) UIImage	*srcImage;

@end
