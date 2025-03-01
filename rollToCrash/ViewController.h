//
//  ViewController.h
//  rollToCrash
//
//  Created by 七野祐太 on 2014/07/20.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <QuartzCore/QuartzCore.h>
#import "ImageViewCircle.h"
#import "UIButton+Animation.h"
#import "UIImageView+Animation.h"
#import "AVAudioPlayer+CustomControllers.h"
#import "BugFixContainerView.h"

#import "kContentView.h"

#import "GADBannerView.h"
#import "GADInterstitial.h"
#import "NADView.h"
#import "AppDelegate.h"

#import "GAITrackedViewController.h"
#import "FluctBannerView.h"
#define MY_BANNER_UNIT_ID @"ca-app-pub-5959590649595305/5220821270"
#define MY_INTERSTITIAL_UNIT_ID @"ca-app-pub-5959590649595305/4941619672"

#define RGB(r, g, b)[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a)[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface ViewController : GAITrackedViewController<GADBannerViewDelegate,GADInterstitialDelegate,NADViewDelegate,UIScrollViewDelegate>{
    //【Ad】AdMobバナー：インスタンス変数として1つ宣言
    GADBannerView *bannerView_;
    
    // 【Ad】AdMobインタースティシャル：インタンス変数として1つ宣言
    GADInterstitial *interstitial_;
    
    NSMutableArray *pages;
}
@property(nonatomic,retain)NADView *nadView;
@end