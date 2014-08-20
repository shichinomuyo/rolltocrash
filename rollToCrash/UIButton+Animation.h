//
//  UIButton+Animation.h
//  rollToCrash
//
//  Created by 七野祐太 on 2014/08/05.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Animation)
- (void)appearWithRotateScaleUpSetEnable;
- (void)disappearWithRotateScaleDownSetDisable;

- (void)scaleUpBtn;
- (void)scaleDownBtn;

- (void)clearTransformBtnSetEnable;
- (void)highlightedAnimation;
- (void)vibeAnimationKeepTransform;
- (void)strongVibeAnimationKeepTransform;
- (void)appearAfterInterval:(NSTimer *)timer;
@end
