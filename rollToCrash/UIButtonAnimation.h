//
//  UIButtonAnimation.h
//  rollToCrash
//
//  Created by 七野祐太 on 2014/08/02.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIButtonAnimation : NSObject
+ (void)appearWithRotate:(UIButton *)btn;
+ (void)btnToHiddenDisable:(UIButton *)btn;
+ (void)disAppearWithRotate:(UIButton *)btn;
@end
