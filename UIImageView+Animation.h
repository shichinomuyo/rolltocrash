//
//  UIImageView+Animation.h
//  rollToCrash
//
//  Created by 七野祐太 on 2014/08/08.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Animation)
- (void)crashUIImageViewAnimationCompletion:(void (^)(void))completion;
- (void)appearEmeraldWithScaleUp:(UIImage *)image completion:(void (^)(void))completion;
- (void)appearALIZARINWithScaleUp:(NSTimer *)timer completion:(void (^)(void))completion;
- (void)disappearEmeraldWithScaleDown:(NSTimer *)timer;
- (void)disappearALIZARINWithScaleUp:(UIImage *)image completion:(void (^)(void))completion;
@end
