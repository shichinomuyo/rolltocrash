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
        NSLog(@"初期化");
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

- (void)scaleUpAnimation{
    // transform初期化
    self.transform = CGAffineTransformIdentity;
    // アルファ値初期化
    self.alpha = 1;

    CGAffineTransform t1 = CGAffineTransformMakeScale(1.25, 1.25);
    
    // 【アニメーション】ロール再生ボタンが押されるまで緑のサークルの拡大、alpha減少を繰り返す
    [UIView animateWithDuration:1.25f
                          delay:0.1f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.hidden = 0;
                         self.alpha = 0;
                         self.transform = t1;
                     } completion:nil];
}

// 0.9倍への縮小アニメーション
-(void)scaleDownAnimation{
    // transform初期化
    self.transform = CGAffineTransformIdentity;
    // アルファ値初期化
    self.alpha = 1;
    
    CGAffineTransform t1 = CGAffineTransformMakeScale(0.9, 0.9);
    // 【アニメーション】クラッシュ再生ボタンが押されるまで赤のサークルの縮小、alpha減少を繰り返す
    [UIView animateWithDuration:0.2f // ロールアニメーションが1.5秒
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.hidden = 0;
                         self.alpha = 0;
                         self.transform = t1;
                         
                     } completion:nil];
}

// 1倍の円から2倍への拡大アニメーション
-(void)circleAnimationFinish:(float)firstDuration secondDuration:(float)secondDuration{
    // transform初期化
    self.transform = CGAffineTransformIdentity;
    self.transform = CGAffineTransformIdentity;
    // アルファ値初期化
    self.alpha = 1;
    
    CGAffineTransform t2 = CGAffineTransformMakeScale(2, 2);
    
    // 【アニメーション】赤のサークルの拡大、alpha減少
    [UIView animateWithDuration:firstDuration // 0.17f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         //  self.ctrlBtn.imageView.transform = t1;
                         
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:secondDuration // 0.17f
                                               delay:0.0f
                                             options:UIViewAnimationOptionCurveEaseInOut
                                          animations:^{
                                              self.hidden = 0;
                                              self.alpha = 0;
                                              self.transform = t2;
                                              
                                          }
                                          completion:^(BOOL finished){
                                              self.transform = CGAffineTransformIdentity;
                                          }];
                     }];
    
}



@end