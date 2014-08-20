//
//  UIImageView+Animation.h
//  rollToCrash
//
//  Created by 七野祐太 on 2014/08/08.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Animation)
- (void)crashUIImageViewAnimation;
- (void)appearEmeraldWithScaleUp:(NSTimer *)timer;
- (void)appearALIZARINWithScaleUp:(NSTimer *)timer;
- (void)disappearEmeraldWithScaleDown:(NSTimer *)timer;
- (void)disappearALIZARINWithScaleUp:(NSTimer *)timer;
@end
