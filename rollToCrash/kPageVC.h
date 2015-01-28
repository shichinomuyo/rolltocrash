//
//  kPageVC.h
//  rollToCrash
//
//  Created by 七野祐太 on 2015/01/26.
//  Copyright (c) 2015年 shichino yuta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentViewController.h"

#import "AppDelegate.h"

#import "GADBannerView.h"
#import "NADView.h"
#import "FluctBannerView.h"

#define MY_BANNER_UNIT_ID @"ca-app-pub-5959590649595305/5220821270"

@interface kPageVC : UIPageViewController<UIPageViewControllerDataSource,UIPageViewControllerDelegate,UIToolbarDelegate>{
    NSArray *imageNameArray;
    NSArray *soundNameArray;
    NSArray *captionArray;
    NSInteger currentPageIndex;
    //【Ad】AdMobバナー：インスタンス変数として1つ宣言
    GADBannerView *bannerView_;
}

@end
