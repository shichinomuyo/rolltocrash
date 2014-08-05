//
//  UIButton+Animation.m
//  rollToCrash
//
//  Created by 七野祐太 on 2014/08/05.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import "UIButton+Animation.h"

@implementation UIButton (Animation)
- (void)removeWithAnimation:(int)steps{
    self.transform = CGAffineTransformIdentity;
    NSTimer *timer;
    if (steps > 0 && steps < 100)	// just to avoid too much steps
		self.tag = steps;
	else
		self.tag = 50;
    timer = [NSTimer scheduledTimerWithTimeInterval:0.02
                                             target:self
                                           selector:@selector(removeWithAnimationRotateTimer:)
                                           userInfo:timer
                                            repeats:YES];
}

- (void)removeWithAnimationRotateTimer:(NSTimer *)timer {
    CGAffineTransform transform = CGAffineTransformRotate(CGAffineTransformScale(self.transform, 0.98, 0.98) , 0.314);
    self.transform = transform;
    self.center = CGPointMake(160, 382);
    	// self.alpha = self.alpha * 0.98;
    	self.tag = self.tag - 1;
    if (self.tag <= 0)
	{
		[timer invalidate];
		[self setHidden:1];
	}
}

// 回転しながら拡大して現れる
- (void)appearWithRotateScaleUp:(UIButton *)btn{
    self.transform = CGAffineTransformIdentity;
    self.hidden = 0;
    self.transform = CGAffineTransformMakeScale(0.1, 0.1);
    
    float scale = sqrtf(sqrtf(10));
    CGAffineTransform t1 = CGAffineTransformMakeRotation(M_PI_2); // M_PI 180度 M_PI_2 90度
    CGAffineTransform t2 = CGAffineTransformMakeScale(scale, scale);
    CGAffineTransform concat = CGAffineTransformConcat(t1, t2);
    
    
    [UIView animateWithDuration:0.08f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.transform =  CGAffineTransformConcat(self.transform, concat);
                         self.center = CGPointMake(160, 382);
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.07f
                                               delay:0.0f
                                             options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState
                                          animations:^{
                                              self.transform =  CGAffineTransformConcat(self.transform, concat);
                                              self.center = CGPointMake(160, 382);
                                          }
                                          completion:^(BOOL finished){
                                              [UIView animateWithDuration:0.05f
                                                                    delay:0.0
                                                                  options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState
                                                               animations:^{
                                                                   self.transform =  CGAffineTransformConcat(self.transform, concat);
                                                                   self.center = CGPointMake(160, 382);
                                                               }completion:^(BOOL finished) {
                                                                   [UIView animateWithDuration:0.05f
                                                                                         delay:0.0f
                                                                                       options:UIViewAnimationOptionCurveEaseOut |UIViewAnimationOptionBeginFromCurrentState
                                                                                    animations:^{
                                                                                           self.transform =  CGAffineTransformConcat(self.transform, concat);
                                                                                           self.center = CGPointMake(160, 382);
                                                                                       }completion:^(BOOL finished) {
                                                                                           [self setEnabled:1];
                                                                                           [btn setEnabled:1];
                                                                                       }];
                                                               }];
                                          }];
                     }];
}

// startStopBtnをhiddenかつ無効にする
- (void)btnToHiddenDisable{
    self.hidden = 1;
    [self setEnabled:0];
}

// 回転しながら縮小して消える
- (void)disappearWithRotateScaleDown:(UIButton *)btn{
    self.transform = CGAffineTransformIdentity;

    float scale = 1/sqrtf(sqrtf(10));
    CGAffineTransform t1 = CGAffineTransformMakeRotation(-1 * M_PI_2); // M_PI 180度 M_PI_2 90度
    CGAffineTransform t2 = CGAffineTransformMakeScale(scale, scale);
    CGAffineTransform concat = CGAffineTransformConcat(t1, t2);
    
    
    [UIView animateWithDuration:0.08f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.transform =  CGAffineTransformConcat(self.transform, concat);
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.08f
                                               delay:0.0f
                                             options:UIViewAnimationOptionCurveLinear
                                          animations:^{
                                              self.transform =  CGAffineTransformConcat(self.transform, concat);
                                          }
                                          completion:^(BOOL finished){
                                              [UIView animateWithDuration:0.05f
                                                                    delay:0.0
                                                                  options:UIViewAnimationOptionCurveLinear
                                                               animations:^{
                                                                   self.transform =  CGAffineTransformConcat(self.transform, concat);
                                                               }completion:^(BOOL finished) {
                                                                   [UIView animateWithDuration:0.05f
                                                                                         delay:0.0f
                                                                                       options:UIViewAnimationOptionCurveEaseOut animations:^{
                                                                                           self.transform =  CGAffineTransformConcat(self.transform, concat);
                                                                                       }completion:^(BOOL finished) {
                                                                                           [self setEnabled:0];
                                                                                           [self setHidden:1];
                                                                                           [btn setEnabled:1];
                                                                                       }];
                                                               }];
                                          }];
                     }];

    
}

// ctrlBtnアニメーション　ロール停止時
- (void)scaleUpBtn{
    // transform初期化
    self.imageView.transform = CGAffineTransformIdentity;
    CGPoint center = self.center;
    CGAffineTransform t1 = CGAffineTransformScale(self.imageView.transform, 1.1, 1.1);
    self.center = center;
    // 【アニメーション】ロール再生ボタンが押されるまで緑のサークルの拡大、alpha減少を繰り返す
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn |UIViewAnimationOptionAutoreverse
                     animations:^{
                         self.imageView.transform = t1;

                     }
                     completion:nil];

    
}

// ctrlBtnアニメーション　ロール停止時
- (void)scaleDownBtn{
    // transform初期化
    self.imageView.transform = CGAffineTransformIdentity;
    
    CGAffineTransform t1 = CGAffineTransformMakeScale(0.98, 0.98);
    self.imageView.transform = t1;
    // 【アニメーション】ロール再生ボタンが押されるまで緑のサークルの拡大、alpha減少を繰り返す
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.imageView.transform = t1;
                     } completion:nil];

}

@end
