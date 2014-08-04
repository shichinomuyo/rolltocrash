//
//  UIButtonAnimation.m
//  rollToCrash
//
//  Created by 七野祐太 on 2014/08/02.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import "UIButtonAnimation.h"

@implementation UIButtonAnimation

// ctrlBtnアニメーション ロール再生中

// pauseBtnの出現アニメーション
+ (void)appearWithRotate:(UIButton *)btn{
    btn.imageView.transform = CGAffineTransformIdentity;

    btn.hidden = 0;
    btn.alpha = 0;
    btn.imageView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    
    float scale = 1.0;
    CGAffineTransform t1 = CGAffineTransformMakeRotation(M_PI_2); // M_PI 180度 M_PI_2 90度
    CGAffineTransform t5 = CGAffineTransformMakeScale(scale, scale);
  
    
    [UIView animateWithDuration:0.1f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         btn.alpha = 0.5;
                         btn.imageView.transform =  CGAffineTransformConcat(t1, t5);
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.1f
                                               delay:0.0f
                                             options:UIViewAnimationOptionCurveLinear
                                          animations:^{
                                              btn.alpha = 0.6;
                                               btn.imageView.transform =  CGAffineTransformConcat(btn.imageView.transform,t1);
                                          }
                                          completion:^(BOOL finished){
                                              [UIView animateWithDuration:0.1f
                                                                    delay:0.0
                                                                  options:UIViewAnimationOptionCurveLinear
                                                               animations:^{
                                                                   btn.alpha = 0.75;
                                                                   btn.imageView.transform =  CGAffineTransformConcat(btn.imageView.transform,t1);
                                                               }completion:^(BOOL finished) {
                                                                   [UIView animateWithDuration:0.1f
                                                                                         delay:0.0f
                                                                                       options:UIViewAnimationOptionCurveEaseOut animations:^{
                                                                                           btn.alpha = 1;
                                                                                           btn.imageView.transform =  CGAffineTransformConcat(btn.imageView.transform,t1);
                                                                                       }completion:^(BOOL finished) {
                                                                                           [btn setEnabled:1];
                                                                                       }];
                                                               }];
                                          }];
                     }];
     
    
}

// startStopBtnをhiddenかつ無効にする
+ (void)btnToHiddenDisable:(UIButton *)btn{
    btn.hidden = 1;
    [btn setEnabled:0];
}


// pauseBtnの出現アニメーション
+ (void)disAppearWithRotate:(UIButton *)btn{
    btn.imageView.alpha = 0;
    btn.hidden = 0;
    btn.imageView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    
    CGAffineTransform t1 = CGAffineTransformMakeRotation(M_PI/2.0f);
    CGAffineTransform t2 = CGAffineTransformRotate(t1, M_PI/2.0f);
    CGAffineTransform t3 = CGAffineTransformRotate(t2, M_PI/2.0f);
    CGAffineTransform t4 = CGAffineTransformRotate(t3, M_PI/2.0f);
    
    CGAffineTransform t5 = CGAffineTransformMakeScale(1.25, 1.25);
    CGAffineTransform t6 = CGAffineTransformScale(t5, 1.25, 1.25);
    CGAffineTransform t7 = CGAffineTransformScale(t6, 1.25, 1.25);
    CGAffineTransform t8 = CGAffineTransformScale(t7, 1.25, 1.25);
    
    
    
    [UIView animateWithDuration:0.12f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         btn.imageView.alpha = 0.3;
                         btn.imageView.transform =  CGAffineTransformConcat(t1, t5);
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.12f
                                               delay:0.0f
                                             options:UIViewAnimationOptionCurveLinear
                                          animations:^{
                                              btn.imageView.alpha = 0.6;
                                              btn.imageView.transform =  CGAffineTransformConcat(t2, t6);
                                          }
                                          completion:^(BOOL finished){
                                              [UIView animateWithDuration:0.12f
                                                                    delay:0.0f
                                                                  options:UIViewAnimationOptionCurveLinear
                                                               animations:^{
                                                                   btn.imageView.alpha = 1;
                                                                   btn.imageView.transform =  CGAffineTransformConcat(t3, t7);
                                                               }
                                                               completion:^(BOOL finished){
                                                                   [UIView animateWithDuration:0.12f
                                                                                         delay:0.0f
                                                                                       options:UIViewAnimationOptionCurveEaseOut
                                                                                    animations:^{
                                                                                        btn.imageView.alpha = 1;
                                                                                        btn.imageView.transform =  CGAffineTransformConcat(t4, t8);
                                                                                        // アニメーションが再生されるまでボタンを無効化
                                                                                        [btn setEnabled:1];
                                                                                    }
                                                                                    completion:nil];
                                                                   
                                                               }];
                                              
                                          }];
                     }];
    
}

@end
