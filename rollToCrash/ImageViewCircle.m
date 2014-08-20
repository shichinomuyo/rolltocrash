//
//  MyCircle.m
//  drawCircleTest
//
//  Created by 七野祐太 on 2014/08/01.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import "ImageViewCircle.h"

@implementation ImageViewCircle

@synthesize myColor;
@synthesize myLineWidth;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withColor:(UIColor *)color withLineWidth:(float)lineWidth
{
    self = [super initWithFrame:frame];
    if (self != nil) {
        // 初期化
        myColor = color;
        myLineWidth = lineWidth;
    }
    return self;
}



/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */


// 円を描画するメソッド
-(UIImage *)imageFillEllipseInRect{
    
    UIImage *img = nil;
    CGSize ookisa = CGSizeMake(self.frame.size.width, self.frame.size.height);
    CGRect rect;
    
    // ビットマップ形式のコンテキストの生成
    UIGraphicsBeginImageContextWithOptions(ookisa, NO, 0); // (scale)は 0 を指定することで使用デバイスに適した倍率が自動的に採用される
    
    // 現在のコンテキストを取得する
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 線の太さを決める
    CGContextSetLineWidth(context, 3);
    
    rect = CGRectMake(self.myLineWidth, self.myLineWidth, self.frame.size.width - self.myLineWidth * 2, self.frame.size.height - self.myLineWidth *2);
    
    UIColor *color = self.myColor;
    
    // 円を描画する
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextStrokeEllipseInRect(context, rect);
    
    // 現在のグラフィックコンテクストの内容を取得する
    img = UIGraphicsGetImageFromCurrentImageContext();
    
    // 現在のグラフィックコンテクストの編集を終了する
    UIGraphicsEndImageContext();
    
    return img;
}

// 円のホワンホワンアニメーション
- (void)rippleAnimation{
    // transform初期化
    self.transform = CGAffineTransformIdentity;
    CGAffineTransform t1 = CGAffineTransformMakeScale(1.22, 1.22);
    [self setAlpha:1.0];
    
    // 【アニメーション】ロール再生ボタンが押されるまで緑のサークルの拡大、alpha減少を繰り返す
    [UIView animateWithDuration:0.3f // ctrlBtnが縮小するのに合わせる
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.transform = CGAffineTransformScale(self.transform, 0.98, 0.98);
                     }completion:^(BOOL finished){
                         [UIView animateWithDuration:1.25f // 拡大、アルファ減少
                                               delay:0.0f
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              [self setAlpha:0];
                                              [self setHidden:0];

                                              self.transform = CGAffineTransformConcat(self.transform, t1);
                                          }completion:^(BOOL finished) {
                                              [self setHidden:1];
                                          }];
                     }];
}

// 円のギュンギュンアニメーション
-(void)rippleAnimationReverse{
    // transform初期化
    self.transform = CGAffineTransformIdentity;
    CGAffineTransform t1 = CGAffineTransformMakeScale(0.8, 0.8);
    [self setAlpha:0.6];
    
    // 【アニメーション】ロール再生ボタンが押されるまで緑のサークルの拡大、alpha減少を繰り返す
    [UIView animateWithDuration:0.1f // ctrlBtnが縮小するのに合わせる
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.transform = CGAffineTransformScale(self.transform, 0.98, 0.98);
                     }completion:^(BOOL finished){
                         [UIView animateWithDuration:0.4f // 拡大、アルファ減少
                                               delay:0.0f
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              [self setHidden:0];
                                              [self setAlpha:0];
                                              self.transform = CGAffineTransformConcat(self.transform, t1);
                                          }completion:^(BOOL finished) {
                                              [self setHidden:1];
                                          }];
                     }];
}

// 1倍の円から2倍への拡大アニメーション
-(void)circleAnimationFinish:(float)firstDuration{
    // transform初期化
    self.transform = CGAffineTransformIdentity;
    self.transform = CGAffineTransformIdentity;
    // アルファ値初期化
    self.alpha = 1;
    
    CGAffineTransform t1 = CGAffineTransformMakeScale(2, 2);
    
    // 【アニメーション】赤のサークルの拡大、alpha減少
    [UIView animateWithDuration:firstDuration // 0.17f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.hidden = 0;
                         self.alpha = 0;
                         self.transform = t1;
                         
                     }
                     completion:^(BOOL finished){
                         self.transform = CGAffineTransformIdentity;
                         
                     }];
    
}



@end