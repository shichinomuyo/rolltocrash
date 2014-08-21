//
//  UIImageView+Animation.m
//  rollToCrash
//
//  Created by 七野祐太 on 2014/08/08.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import "UIImageView+Animation.h"

@implementation UIImageView (Animation)
// 回転しながら拡大してギザギザになるアニメーション　1.09sec
- (void)crashUIImageViewAnimation{
    self.transform = CGAffineTransformIdentity;
    [self setImage:[UIImage imageNamed:@"crash01.png"]];
    [self setHidden:0];
    [self setAlpha:0.7];
    
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
    
    [UIView animateWithDuration:0.05f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.transform =  CGAffineTransformConcat(self.transform, concat);
                         [self setAlpha:0.25];
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.05f
                                               delay:0.0f
                                             options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState
                                          animations:^{
                                              self.transform =  CGAffineTransformConcat(self.transform, concat);
                                              [self setAlpha:0.5];
                                          }
                                          completion:^(BOOL finished){
                                              [UIView animateWithDuration:0.05f
                                                                    delay:0.0
                                                                  options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState
                                                               animations:^{
                                                                   self.transform =  CGAffineTransformConcat(self.transform, concat);
                                                                   [self setAlpha:0.75];
                                                               }completion:^(BOOL finished) {
                                                                   [UIView animateWithDuration:0.05f //ここまでで0.20f
                                                                                         delay:0.0f
                                                                                       options:UIViewAnimationOptionCurveEaseOut |UIViewAnimationOptionBeginFromCurrentState
                                                                                    animations:^{
                                                                                        self.transform =  CGAffineTransformConcat(self.transform, concat);
                                                                                        [self setAlpha:1];
                                                                                    }completion:^(BOOL finished) {
                                                                                        [UIView animateWithDuration:0.02f // 0.22f
                                                                                                              delay:0.0f
                                                                                                            options:UIViewAnimationOptionCurveLinear |UIViewAnimationOptionBeginFromCurrentState
                                                                                                         animations:^{ // パーン
                                                                                                             //    self.transform =  CGAffineTransformConcat(self.transform, concat);
                                                                                                             self.transform =  CGAffineTransformScale(self.transform, 1.2, 1.2);
                                                                                                             
                                                                                                         }completion:^(BOOL finished) {
                                                                                                             [UIView animateWithDuration:0.4f
                                                                                                                                   delay:0.0f
                                                                                                                                 options:UIViewAnimationOptionCurveEaseOut |UIViewAnimationOptionBeginFromCurrentState
                                                                                                                              animations:^{// タメ
                                                                                                                                  self.transform = CGAffineTransformRotate( CGAffineTransformScale(self.transform, 1.08, 1.08),M_2_PI/15);
                                                                                                                                  [self setAlpha:0.95];
                                                                                                                                  
                                                                                                                              }completion:^(BOOL finished) {
                                                                                                                                  [UIView animateWithDuration:0.1f
                                                                                                                                                        delay:0.0f
                                                                                                                                                      options:UIViewAnimationOptionCurveEaseOut |UIViewAnimationOptionBeginFromCurrentState
                                                                                                                                                   animations:^{ // 小さくなる
                                                                                                                                                       self.transform = CGAffineTransformScale(self.transform, 0.1, 0.1);
                                                                                                                                                       [self setImage:[UIImage imageNamed:@"crash02.png"]];
                                                                                                                                                       
                                                                                                                                                   }completion:^(BOOL finished) {
                                                                                                                                                       [UIView animateWithDuration:0.1f
                                                                                                                                                                             delay:0.0f
                                                                                                                                                                           options:UIViewAnimationOptionCurveLinear |UIViewAnimationOptionBeginFromCurrentState
                                                                                                                                                                        animations:^{ // 丸に戻りかけ
                                                                                                                                                                            //                                                                                                                                                       self.transform =  CGAffineTransformConcat(self.transform, concat);
                                                                                                                                                                            [self setImage:[UIImage imageNamed:@"crash03.png"]];
                                                                                                                                                                            
                                                                                                                                                                            self.transform = CGAffineTransformScale(self.transform, 4.0, 4.0);
                                                                                                                                                                            [self setAlpha:0.95];
                                                                                                                                                                            
                                                                                                                                                                        }completion:^(BOOL finished) {
                                                                                                                                                                            [UIView animateWithDuration:0.1f
                                                                                                                                                                                                  delay:0.0f
                                                                                                                                                                                                options:UIViewAnimationOptionCurveEaseOut |UIViewAnimationOptionBeginFromCurrentState
                                                                                                                                                                                             animations:^{ // エメラルド丸に戻る
                                                                                                                                                                                                 //                                                                                                                                                       self.transform =  CGAffineTransformConcat(self.transform, concat);
                                                                                                                                                                                                 
                                                                                                                                                                                                 [self setImage:[UIImage imageNamed:@"ctrlBtnDefault.png"]];
                                                                                                                                                                                                 
                                                                                                                                                                                                 [self setAlpha:1];
                                                                                                                                                                                                 self.transform = CGAffineTransformIdentity;
                                                                                                                                                                                                 self.transform = CGAffineTransformScale(self.transform, 1.05, 1.05);
                                                                                                                                                                                             }completion:^(BOOL finished) {
                                                                                                                                                                                                 
                                                                                                                                                                                                 [UIView animateWithDuration:0.1f
                                                                                                                                                                                                                       delay:0.0f
                                                                                                                                                                                                                     options:UIViewAnimationOptionCurveEaseOut
                                                                                                                                                                                                                  animations:^{
                                                                                                                                                                                                                      self.transform = CGAffineTransformScale(self.transform, 1.05, 1.05);
                                                                                                                                                                                                                  }
                                                                                                                                                                                                                  completion:^(BOOL finished){
                                                                                                                                                                                                                      [UIView animateWithDuration:0.07f
                                                                                                                                                                                                                                            delay:0.0f
                                                                                                                                                                                                                                          options:UIViewAnimationOptionCurveEaseOut
                                                                                                                                                                                                                                       animations:^{
                                                                                                                                                                                                                                           self.transform = CGAffineTransformIdentity;
                                                                                                                                                                                                                                       }
                                                                                                                                                                                                                                       completion:^(BOOL finished){
                                                                                                                                                                                                                                           [self setHidden:1];
                                                                                                                                                                                                                                           
                                                                                                                                                                                                                                           
                                                                                                                                                                                                                                           
                                                                                                                                                                                                                                       }];
                                                                                                                                                                                                                      
                                                                                                                                                                                                                  }];
                                                                                      
                                                                                                                                                                                                 
                                                                                                                                                                                             }];
                                                                                                                                                                        }];
                                                                                                                                                   }];
                                                                                                                                  
                                                                                                                              }];
                                                                                                             
                                                                                                         }];
                                                                                        
                                                                                    }];
                                                               }];
                                          }];
                     }];
}


// 拡大して現れる。ctrlBtnALIZARINの出現時のみに使用。0.4sec
- (void)appearALIZARINWithScaleUp:(NSTimer *)timer{
    self.transform = CGAffineTransformIdentity;
    [self setImage:[UIImage imageNamed:@"hit_R1.png"]];
    [self setHidden:0];
    
    self.transform = CGAffineTransformMakeScale(0.1, 0.1);
    
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.transform = CGAffineTransformScale(self.transform, 10.1, 10.1);
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.1f
                                               delay:0.0f
                                             options:UIViewAnimationOptionCurveLinear
                                          animations:^{
                                              self.transform = CGAffineTransformScale(self.transform, 1.01, 1.01);
                                          }
                                          completion:^(BOOL finished){
                                              [UIView animateWithDuration:0.1f
                                                                    delay:0.0f
                                                                  options:UIViewAnimationOptionCurveLinear
                                                               animations:^{
                                                                   self.transform = CGAffineTransformIdentity;
                                                               }
                                                               completion:^(BOOL finished){
                                                                   [self setHidden:1];
                                                                   [timer invalidate];
                                                                   
                                                                   
                                                               }];
                                              
                                              
                                          }];
    
                     }];
}

- (void)appearEmeraldWithScaleUp:(NSTimer *)timer{
    self.transform = CGAffineTransformIdentity;
    [self setImage:[UIImage imageNamed:@"ctrlBtnDefault.png"]];
    [self setHidden:0];
    
    self.transform = CGAffineTransformMakeScale(0.1, 0.1);
    
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.transform = CGAffineTransformScale(self.transform, 10.75, 10.75);
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.1f
                                               delay:0.0f
                                             options:UIViewAnimationOptionCurveLinear
                                          animations:^{
                                              self.transform = CGAffineTransformScale(self.transform, 1.01, 1.01);
                                          }
                                          completion:^(BOOL finished){
                                              [UIView animateWithDuration:0.1f
                                                                    delay:0.0f
                                                                  options:UIViewAnimationOptionCurveLinear
                                                               animations:^{
                                                                   self.transform = CGAffineTransformIdentity;
                                                               }
                                                               completion:^(BOOL finished){
                                                                   [self setHidden:1];
                                                                   [timer invalidate];
                                                                   
                                                                   
                                                               }];
                                              
                                              
                                          }];
                         
                     }];
}


// 縮小して消える。ctrlBtnEmeraldの消失時のみに使用。
- (void)disappearEmeraldWithScaleDown:(NSTimer *)timer{
    self.transform = CGAffineTransformIdentity;
    [self setImage:[UIImage imageNamed:@"ctrlBtnDefault.png"]];
    [self setHidden:0];
    [UIView animateWithDuration:0.1f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.transform = CGAffineTransformScale(self.transform, 1.05, 1.05);
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.1f
                                               delay:0.0f
                                             options:UIViewAnimationOptionCurveLinear
                                          animations:^{
                                              self.transform = CGAffineTransformScale(self.transform, 1.1, 1.1);
                                          }
                                          completion:^(BOOL finished){
                                              [UIView animateWithDuration:0.1f
                                                                    delay:0.0f
                                                                  options:UIViewAnimationOptionCurveEaseOut
                                                               animations:^{
                                                                   self.transform = CGAffineTransformScale(self.transform, 0.1, 0.1);
                                                               }
                                                               completion:^(BOOL finished){
                                                                   [self setHidden:1];
                                                                   [timer invalidate];
                                                                   
                                                                   
                                                               }];
                                              
                                              
                                          }];
                         
                     }];
}


// 縮小して消える。ctrlBtnALIZARINの消失時のみに使用。
- (void)disappearALIZARINWithScaleUp:(NSTimer *)timer{
    self.transform = CGAffineTransformIdentity;
    [self setImage:[UIImage imageNamed:@"hit_R1.png"]];
    [self setHidden:0];
    [UIView animateWithDuration:0.1f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.transform = CGAffineTransformScale(self.transform, 1.05, 1.05);
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.1f
                                               delay:0.0f
                                             options:UIViewAnimationOptionCurveLinear
                                          animations:^{
                                              self.transform = CGAffineTransformScale(self.transform, 1.1, 1.1);
                                          }
                                          completion:^(BOOL finished){
                                              [UIView animateWithDuration:0.1f
                                                                    delay:0.0f
                                                                  options:UIViewAnimationOptionCurveEaseOut
                                                               animations:^{
                                                                   self.transform = CGAffineTransformScale(self.transform, 0.1, 0.1);
                                                               }
                                                               completion:^(BOOL finished){
                                                                   [self setHidden:1];
                                                                   [timer invalidate];
                                                                   
                                                                   
                                                               }];
                                              
                                              
                                          }];
                         
                     }];
}

@end
