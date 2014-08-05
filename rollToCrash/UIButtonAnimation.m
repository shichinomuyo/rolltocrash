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
    btn.alpha = 1;
    btn.imageView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    
    float scale = 1.0;
    CGAffineTransform t1 = CGAffineTransformMakeRotation(M_PI_2); // M_PI 180度 M_PI_2 90度
    CGAffineTransform t5 = CGAffineTransformMakeScale(scale, scale);
  
    
    [UIView animateWithDuration:0.1f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         btn.imageView.transform =  CGAffineTransformConcat(t1, t5);
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.08f
                                               delay:0.0f
                                             options:UIViewAnimationOptionCurveLinear
                                          animations:^{
                                               btn.imageView.transform =  CGAffineTransformConcat(btn.imageView.transform,t1);
                                          }
                                          completion:^(BOOL finished){
                                              [UIView animateWithDuration:0.06f
                                                                    delay:0.0
                                                                  options:UIViewAnimationOptionCurveLinear
                                                               animations:^{
                                                                   btn.imageView.transform =  CGAffineTransformConcat(btn.imageView.transform,t1);
                                                               }completion:^(BOOL finished) {
                                                                   [UIView animateWithDuration:0.05f
                                                                                         delay:0.0f
                                                                                       options:UIViewAnimationOptionCurveEaseOut animations:^{
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



// pauseBtnの消失アニメーション
+ (void)disAppearWithRotate:(UIButton *)btn{
    btn.imageView.transform = CGAffineTransformIdentity;
    [btn setEnabled:0];
    
    
    float scale = 2.0f;
    CGAffineTransform t1 = CGAffineTransformMakeRotation(-1*M_PI_2); // M_PI 180度 M_PI_2 90度
    CGAffineTransform t2 = CGAffineTransformMakeScale(scale, scale);
    CGAffineTransform concat = CGAffineTransformConcat(t1, t2);
    CGSize testSize = CGSizeApplyAffineTransform(CGSizeMake(0.5, 0.5), btn.imageView.transform);
    btn.imageView.transform = CGAffineTransformMakeScale( 1.0f, 1.0f);
    
    
    [UIView animateWithDuration:1.0f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{

             //これを四回実行で１回転
                         btn.imageView.transform = CGAffineTransformConcat(btn.imageView.transform, t1);

                   //      btn.imageView.transform = CGAffineTransformScale(t1, 0.9, 0.9);
                         
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:2.0f
                                               delay:0.0f
                                             options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState
                                          animations:^{
                                              
                                          //これを四回実行で１回転
                                              btn.imageView.transform = CGAffineTransformConcat(btn.imageView.transform, t1);
                     //    btn.imageView.transform = CGAffineTransformScale(t1, 0.8, 0.8);
                                          }
                                          completion:^(BOOL finished){
                                              [UIView animateWithDuration:1.0f
                                                                    delay:0.0
                                                                  options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState
                                                               animations:^{
                                                                   
                         //これを四回実行で１回転
                                                                   btn.imageView.transform = CGAffineTransformConcat(btn.imageView.transform, t1);
                    //     btn.imageView.transform = CGAffineTransformScale(t1, scale, scale);
                                                               }completion:^(BOOL finished) {
                                                                   [UIView animateWithDuration:1.0f
                                                                                         delay:0.0f
                                                                                       options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState
                                                                                    animations:^{
                                                                                                                 
                                                                                                                                          //これを四回実行で１回転
                                                                                        btn.imageView.transform = CGAffineTransformConcat(btn.imageView.transform, t1);
                     //    btn.imageView.transform = CGAffineTransformScale(t1, scale, scale);
                                                                                       // btn.imageView.transform = CGAffineTransformConcat(btn.imageView.transform, t1);


//                                                                                        btn.imageView.transform =CGAffineTransformRotate(CGAffineTransformScale(btn.imageView.transform, 0.1, 0.1), -1*M_PI_2);
                                                                                       }completion:^(BOOL finished) {
                                                                                           [self btnToHiddenDisable:btn];
                                                                                       }];
                                                               }];
                                          }];
                     }];
    
    
}

@end
