//
//  UIButton+Animation.m
//  rollToCrash
//
//  Created by 七野祐太 on 2014/08/05.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import "UIButton+Animation.h"

@implementation UIButton (Animation)



// 回転しながら拡大して現れる。
- (void)appearWithRotateScaleUpSetEnable{
    self.transform = CGAffineTransformIdentity;
    self.hidden = 0;
    
    float scale = sqrtf(sqrtf(10));
    float adjustX = (self.bounds.size.width - self.frame.size.width) / 2;
    float adjustY = (self.bounds.size.height - self.frame.size.height) / 2;
    
    CGAffineTransform t1 = CGAffineTransformMakeRotation(M_PI_2); // M_PI 180度 M_PI_2 90度 回転
    CGAffineTransform t2 = CGAffineTransformMakeScale(scale, scale); // 拡大
    CGAffineTransform t3 = CGAffineTransformMakeTranslation(adjustX, adjustY); // 拡大の際に発生する中心座標の調整
    CGAffineTransform concat = CGAffineTransformConcat(CGAffineTransformConcat(t1, t2), t3); //  回転　+ 拡大 + 座標調整
    // CGAffineTransform concat = CGAffineTransformConcat(t1, t2); //　回転 + 拡大
    // 中心座標の調整するための座標。以下をsetCenterすると位置がずれない。
    // CGPoint adjustedCenterPoint = CGPointMake(self.center.x + adjustX,self.center.y + adjustY);
    
    self.transform = CGAffineTransformMakeScale(0.1, 0.1);
    NSLog(@"%s",__PRETTY_FUNCTION__);
    [self consoleLog];
    [UIView animateWithDuration:0.1f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.transform =  CGAffineTransformConcat(self.transform, concat);
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.1f
                                               delay:0.0f
                                             options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState
                                          animations:^{
                                              self.transform =  CGAffineTransformConcat(self.transform, concat);
                                          }
                                          completion:^(BOOL finished){
                                              [UIView animateWithDuration:0.1f
                                                                    delay:0.0
                                                                  options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState
                                                               animations:^{
                                                                   self.transform =  CGAffineTransformConcat(self.transform, concat);
                                                               }completion:^(BOOL finished) {
                                                                   [UIView animateWithDuration:0.1f
                                                                                         delay:0.0f
                                                                                       options:UIViewAnimationOptionCurveEaseOut |UIViewAnimationOptionBeginFromCurrentState
                                                                                    animations:^{
                                                                                        self.transform =  CGAffineTransformConcat(self.transform, concat);
                                                                                    }completion:^(BOOL finished) {
                                                                                        [self setEnabled:1];
                                                                                        NSLog(@"%s",__PRETTY_FUNCTION__);
                                                                                        [self consoleLog];
                                                                                    }];
                                                               }];
                                          }];
                     }];
}



// 回転しながら縮小して消える。
- (void)disappearWithRotateScaleDownSetDisable{
    
    self.transform = CGAffineTransformIdentity;
    
    float scale = 1/sqrtf(sqrtf(10));
    float adjustX = (self.bounds.size.width - self.frame.size.width) / 2;
    float adjustY = (self.bounds.size.height - self.frame.size.height) / 2;
    
    CGAffineTransform t1 = CGAffineTransformMakeRotation(-M_PI_2); // M_PI 180度 M_PI_2 90度 回転
    CGAffineTransform t2 = CGAffineTransformMakeScale(scale, scale); // 拡大
    CGAffineTransform t3 = CGAffineTransformMakeTranslation(adjustX, adjustY); // 拡大の際に発生する中心座標の調整
    CGAffineTransform concat = CGAffineTransformConcat(CGAffineTransformConcat(t1, t2), t3); //  回転　+ 拡大 + 座標調整
    //    NSLog(@"%s",__PRETTY_FUNCTION__);
    //    [self consoleLog];
    [UIView animateWithDuration:0.08f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.transform =  CGAffineTransformConcat(self.transform, concat);
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.05f
                                               delay:0.0f
                                             options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState
                                          animations:^{
                                              self.transform =  CGAffineTransformConcat(self.transform, concat);
                                          }
                                          completion:^(BOOL finished){
                                              [UIView animateWithDuration:0.05f
                                                                    delay:0.0
                                                                  options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState
                                                               animations:^{
                                                                   self.transform =  CGAffineTransformConcat(self.transform, concat);
                                                               }completion:^(BOOL finished) {
                                                                   [UIView animateWithDuration:0.05f
                                                                                         delay:0.0f
                                                                                       options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
                                                                                           self.transform =  CGAffineTransformConcat(self.transform, concat);
                                                                                       }completion:^(BOOL finished) {
                                                                                           [self setEnabled:0];
                                                                                           [self setHidden:1];
                                                                                       }];
                                                               }];
                                          }];
                     }];
    
}

// ctrlBtnアニメーション　ロール停止時
- (void)scaleUpBtn{

    // transform初期化
    self.transform = CGAffineTransformIdentity;
    CGPoint center = self.center;
    CGAffineTransform t1 = CGAffineTransformMakeScale(0.96, 0.96);
    CGAffineTransform t2 = CGAffineTransformMakeScale(0.98, 0.98);
    self.center = center;

    // 【アニメーション】ロール再生ボタンが押されるまで緑のサークルの拡大、alpha減少を繰り返す
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction                     animations:^{
                         self.transform = CGAffineTransformConcat(self.transform, t1);
                     }completion:^(BOOL finished){
                         [UIView animateWithDuration:0.1f
                                               delay:0.0f
                                             options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction                                          animations:^{
                                              self.transform = CGAffineTransformIdentity;
                                          }
                                          completion:^(BOOL finished){
                                              [UIView animateWithDuration:0.08f
                                                                    delay:0.0f
                                                                  options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction
                                                               animations:^{
                                                                   self.transform = CGAffineTransformConcat(self.transform, t2);
                                                               }
                                                               completion:^(BOOL finished){
                                                                   [UIView animateWithDuration:0.15f
                                                                                         delay:0.0f
                                                                                       options:UIViewAnimationOptionCurveLinear| UIViewAnimationOptionAllowUserInteraction
                                                                                    animations:^{
                                                                                        self.transform = CGAffineTransformIdentity;
                                                                                    }completion:nil];
                                                               }];
                                          }];
                     }];
}

// ctrlBtnアニメーション　ロール再生中 0.3sec
- (void)scaleDownBtn{
    // transform初期化
    self.transform = CGAffineTransformIdentity;
    CGPoint center = self.center;
    CGAffineTransform t1 = CGAffineTransformMakeScale(1.04, 1.04);
    CGAffineTransform t2 = CGAffineTransformMakeScale(1.02, 1.02);
    self.center = center;
    // 【アニメーション】ロール再生ボタンが押されるまで赤いサークルの縮小、alpha減少を繰り返す
    [UIView animateWithDuration:0.05f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.transform = CGAffineTransformConcat(self.transform, t1);

                     }completion:^(BOOL finished){
                         [UIView animateWithDuration:0.05f
                                               delay:0.0f
                                             options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                                          animations:^{
                                              self.transform = CGAffineTransformIdentity;
                                              [self setAlpha:0.8];
                                          }
                                          completion:^(BOOL finished){
                                              [UIView animateWithDuration:0.05f
                                                                    delay:0.0f
                                                                  options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction
                                                               animations:^{
                                                                   self.transform = CGAffineTransformConcat(self.transform, t2);
                                                                   [self setAlpha:0.7];
                                                               }
                                                               completion:^(BOOL finished){
                                                                   [UIView animateWithDuration:0.15f
                                                                                         delay:0.0f
                                                                                       options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                                                                                    animations:^{
                                                                                        self.transform = CGAffineTransformIdentity;
                                                                                        [self setAlpha:1];
                                                                                    }completion:nil];
                                                               }];
                                          }];
                     }];
}

// ctrlBtnハイライト用のアニメーション。縮小だけされる。
- (void)highlightedAnimation{
    self.transform = CGAffineTransformIdentity;
    float scale1 = 0.95;
    CGAffineTransform t1 = CGAffineTransformMakeScale(scale1, scale1);
    [UIView animateWithDuration:0.1f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         self.transform =  CGAffineTransformConcat(self.transform, t1);
                     }
                     completion:nil];

}
// ctrlBtnのハイライト用のアニメーション。小さくなってプルプルする(弱)
- (void)vibeAnimationKeepTransform{
    

    float vel = 1;
    
    [UIView animateWithDuration:0.1f
                          delay:0.0f
        usingSpringWithDamping:0.1
          initialSpringVelocity:vel
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         self.transform =  CGAffineTransformTranslate(self.transform, 4,0);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.1f
                                               delay:0.0f
                              usingSpringWithDamping:0.1
                               initialSpringVelocity:vel
                                             options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowAnimatedContent
                                          animations:^{
                                              self.transform =  CGAffineTransformTranslate(self.transform, -7,0);
                                          }
                                          completion:^(BOOL finished) {
                                              [UIView animateWithDuration:0.07f
                                                                    delay:0.0f
                                                   usingSpringWithDamping:0.1
                                                    initialSpringVelocity:vel
                                                                  options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowAnimatedContent
                                                               animations:^{
                                              self.transform =  CGAffineTransformTranslate(self.transform, 4,0);
                                                               }
                                                               completion:^(BOOL finished) {
                                                                   [UIView animateWithDuration:0.1f
                                                                                         delay:0.0f
                                                                        usingSpringWithDamping:0.3
                                                                         initialSpringVelocity:vel
                                                                                       options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowAnimatedContent
                                                                                    animations:^{
                                              self.transform =  CGAffineTransformTranslate(self.transform, -2,0);
                                                                                    }
                                                                                    completion:^(BOOL finished) {
                                                                                        [UIView animateWithDuration:0.1f
                                                                                                              delay:0.0f
                                                                                             usingSpringWithDamping:0.1
                                                                                              initialSpringVelocity:vel
                                                                                                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowAnimatedContent
                                                                                                         animations:^{
                                                                                                      self.transform =  CGAffineTransformTranslate(self.transform, 1,0);
                                                                                                         }
                                                                                                         completion:^(BOOL finished) {
                                                                                    
                                                                                                             
                                                                                                         }];

                                                                                        
                                                                                    }];
                                                                   
                                                               }];
                                          }];
                     }];
    
}

// ctrlBtnのハイライト用のアニメーション。小さくなってプルプルする(強)
- (void)strongVibeAnimationKeepTransform{
    
    float vel = 1;
    
    [UIView animateWithDuration:0.1f
                          delay:0.0f
         usingSpringWithDamping:0.1
          initialSpringVelocity:vel
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         self.transform =  CGAffineTransformTranslate(self.transform, 2,0);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.1f
                                               delay:0.0f
                              usingSpringWithDamping:0.1
                               initialSpringVelocity:vel
                                             options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowAnimatedContent
                                          animations:^{
                                              self.transform =  CGAffineTransformTranslate(self.transform, -4,0);
                                          }
                                          completion:^(BOOL finished) {
                                              [UIView animateWithDuration:0.07f
                                                                    delay:0.0f
                                                   usingSpringWithDamping:0.1
                                                    initialSpringVelocity:vel
                                                                  options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowAnimatedContent
                                                               animations:^{
                                                                   self.transform =  CGAffineTransformTranslate(self.transform, 4,0);
                                                               }
                                                               completion:^(BOOL finished) {
                                                                   [UIView animateWithDuration:0.1f
                                                                                         delay:0.0f
                                                                        usingSpringWithDamping:0.3
                                                                         initialSpringVelocity:vel
                                                                                       options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowAnimatedContent
                                                                                    animations:^{
                                                                                        self.transform =  CGAffineTransformTranslate(self.transform, -4,0);
                                                                                    }
                                                                                    completion:^(BOOL finished) {
                                                                                        [UIView animateWithDuration:0.1f
                                                                                                              delay:0.0f
                                                                                             usingSpringWithDamping:0.1
                                                                                              initialSpringVelocity:vel
                                                                                                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowAnimatedContent
                                                                                                         animations:^{
                                                                                                             self.transform =  CGAffineTransformTranslate(self.transform, 2,0);
                                                                                                         }
                                                                                                         completion:^(BOOL finished) {
                                                                                                             
                                                                                                             
                                                                                                         }];
                                                                                        
                                                                                        
                                                                                    }];
                                                                   
                                                               }];
                                          }];
                     }];
    
}

// ctrlBtnのハイライトから復帰させるためのアニメーション。
- (void)clearTransformBtnSetEnable{
    [self setHidden:0];
        [UIView animateWithDuration:0.08f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.transform = CGAffineTransformIdentity;
                         }
                         completion:^(BOOL finished) {
                             [self setEnabled:1];
                             NSLog(@"%s",__PRETTY_FUNCTION__);
                             [self consoleLog];
                         }];

    
}

- (void)appearAfterInterval:(NSTimer *)timer{
    [self setHidden:0];
    [self setEnabled:1];
    [self setAlpha:1];
    [timer invalidate];
    NSLog(@"%s",__PRETTY_FUNCTION__);
    [self consoleLog];
}


- (void)consoleLog{
   // NSLog(@"ctrlBtn.enabled %d",self.enabled);
    // NSLog(@"self.image.view.size (x,y)=(%.2f,%.2f)",self.imageView.frame.size.width,self.imageView.frame.size.height); イメージビューはアニメ非対応
   // NSLog(@"self.frame.size (x,y)=(%.2f,%.2f)",self.frame.size.width,self.frame.size.height);
    //   NSLog(@"self.bounds.origine (x,y)=(%.2f,%.2f)",self.bounds.origin.x,self.bounds.origin.y);
    //  NSLog(@"self.bounds.size (x,y)=(%.2f,%.2f)",self.bounds.size.width,self.bounds.size.height);
    //  NSLog(@"adjustX:%.2f adjustY:%.2f",aX,aY);
    //  NSLog(@"self.center        (x,y)=(%.2f,%.2f)",self.center.x,self.center.y);
    
}



@end
