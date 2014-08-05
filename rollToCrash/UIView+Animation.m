//
//  UIView+Animation.m
//  rollToCrash
//
//  Created by 七野祐太 on 2014/08/05.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import "UIView+Animation.h"

@implementation UIView (Animation)
- (void)removeWithAnimation:(UIButton *)btn{
    NSTimer *timer;
    timer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                                      target:self
                                                    selector:@selector(removeWithAnimationRotateTimer)
                                                    userInfo:nil
                                                     repeats:YES];
}

- (void)removeWithAnimationRotateTimer {
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformRotate(self.transform, -1*M_PI_2), 0.9, 0.9);
    self.transform = transform;
}

@end
