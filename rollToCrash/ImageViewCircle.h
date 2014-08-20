//
//  MyCircle.h
//  drawCircleTest
//
//  Created by 七野祐太 on 2014/08/01.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewCircle : UIImageView
{
    UIColor *myColor;
    float myLineWidth;
}
@property float myLineWidth;
@property UIColor *myColor;
- (id)initWithFrame:(CGRect)frame withColor:(UIColor *)color withLineWidth:(float)lineWidth;
- (UIImage *)imageFillEllipseInRect;
- (void)rippleAnimation;
- (void)rippleAnimationReverse;
- (void)circleAnimationFinish:(float)firstDuration;
@end
