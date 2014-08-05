//
//  UIButton+Animation.h
//  rollToCrash
//
//  Created by 七野祐太 on 2014/08/05.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Animation)
- (void)removeWithAnimation:(int)steps;
- (void)removeWithAnimationRotateTimer:(NSTimer *)timer;
- (void)appearWithRotateScaleUp:(UIButton *)btn;
- (void)btnToHiddenDisable;
- (void)disappearWithRotateScaleDown:(UIButton *)btn;
- (void)scaleUpBtn;
- (void)scaleDownBtn;
@end
