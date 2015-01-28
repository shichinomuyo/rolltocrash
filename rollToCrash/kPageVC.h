//
//  kPageVC.h
//  rollToCrash
//
//  Created by 七野祐太 on 2015/01/26.
//  Copyright (c) 2015年 shichino yuta. All rights reserved.
//
///// v1.2ではscrollViewでsnare,timpaniを切り替えるページングを実装
///// その実装が出来る前の試作段階でUIPageViewControllerを使い、ContentViewControllerを2つ作って当て込む方法で実装した。
///// だけどscrollViewでの実装が狙い通りなのでこれらのファイルは不要。rootViewをkPageVCにすれば動作確認ができます。
///// 狙いというのはセッティングボタンは動かさずにkContentViewだけをスワイプで切り替えること。pageViewControllerを使った実装だと、セッティングボタンをnavigationControllerのtoolBarに入れることになっちゃったので、AdMobバナーと重なるので適さないという意味で狙いを満たさなかった。
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
