//
//  kADMOBInterstitialController.h
//  BodyImpersonator
//
//  Created by 七野祐太 on 2015/01/03.
//  Copyright (c) 2015年 shichino yuta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GADInterstitial.h"
#import "NSObject+MyMethod.h"
static const NSInteger kINTERSTITIAL_DISPLAY_RATE_SINGLETON = 5;
#define MY_INTERSTITIAL_UNIT_ID @"ca-app-pub-5959590649595305/4941619672"

@interface kADMOBInterstitialSingleton : NSObject<GADInterstitialDelegate>{
    // 【Ad】AdMobインタースティシャル：インタンス変数として1つ宣言
    GADInterstitial *interstitial_;
}

+ (kADMOBInterstitialSingleton *)sharedInstans;
- (void)loadInterstitial;
- (void)interstitialControll;

@end
