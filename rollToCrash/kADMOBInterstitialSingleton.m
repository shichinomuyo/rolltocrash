//
//  kADMOBInterstitialController.m
//  BodyImpersonator
//
//  Created by 七野祐太 on 2015/01/03.
//  Copyright (c) 2015年 shichino yuta. All rights reserved.
//

#import "kADMOBInterstitialSingleton.h"

static kADMOBInterstitialSingleton *_interstitialController = nil;

@implementation kADMOBInterstitialSingleton
// AdMobインタースティシャルの生成
+ (kADMOBInterstitialSingleton *)sharedInstans {
    @synchronized(self){
        if (!_interstitialController) {
              _interstitialController = [[kADMOBInterstitialSingleton alloc] init];
        }
    }
    return _interstitialController;
}

- (id)init{
    self = [super init];
    if (self) {
        // 【Ad】インタースティシャル広告インスタンス生成
        interstitial_ = [[GADInterstitial alloc] init];
    }
    return self;
}


// AdMobインタースティシャルの生成・インジケーターの表示開始・
- (void)loadInterstitial{
//    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    //    [_kIndicator indicatorStart];
    // 広告表示準備開始状況フラグ更新
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger memoryCountNumberOfInterstitialDidAppear = [defaults integerForKey:@"KEY_countUpCrashPlayed"];
    [defaults setInteger:memoryCountNumberOfInterstitialDidAppear forKey:@"KEY_memoryCountNumberOfInterstitialDidAppear"];
    [defaults synchronize];
    
            interstitial_.adUnitID = MY_INTERSTITIAL_UNIT_ID;
            interstitial_.delegate = self;
            [interstitial_ loadRequest:[GADRequest request]];
}


/// AdMobインタースティシャルのloadrequestが失敗したとき
-(void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error{
    NSLog(@"interstitial:didFailToReceiveAdWithError:%@", [error localizedDescription]);
    // AdMobinterstitialの開放　これをしないと再ロードできない
    [ad setDelegate:nil];
    ad = nil;
    _interstitialController = nil;
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
    NSLog(@"インタースティシャル受信完了");
}

-(void)interstitialWillDismissScreen:(GADInterstitial *)ad{

    // 操作無効解除
    NSLog(@"interstitialWillDismissScreen");
    // AdMobinterstitialの開放　これをしないと再ロードできない
    [ad setDelegate:nil];
    ad = nil;
    _interstitialController = nil;
    
}

- (void)showInterstitial{
    NSLog(@"displayInterstitial");
    if (interstitial_.isReady) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        UIViewController *topVC = [NSObject topViewController];
        [interstitial_ presentFromRootViewController:topVC];
    } else {
        NSLog(@"インタースティシャルがnot ready");
    }
}

- (void)interstitialControll{
    // previewVC、tappedPreviewVC、secondVCでviewdidappearされた回数とplayVCでviewWillDisappearした回数　→ KEY_countUpViewChangedの回数によってインタースティシャルのロードと表示を切り分けて行う
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger countViewChanged = [defaults integerForKey:@"KEY_countUpCrashPlayed"];
    NSInteger memoryCountNumberOfInterstitialDidAppear = [defaults integerForKey:@"KEY_memoryCountNumberOfInterstitialDidAppear"];
    if (countViewChanged != memoryCountNumberOfInterstitialDidAppear){
        switch (countViewChanged % kINTERSTITIAL_DISPLAY_RATE_SINGLETON) { // 5の倍数
            case 0: // 5回目
                NSLog(@"インタースティシャル表示");
                [self showInterstitial];
                break;
            case 3: // 3回目
                NSLog(@"インタースティシャルロード");
                [self loadInterstitial];
                break;
            default:
                break;
        }
    }

}
@end
