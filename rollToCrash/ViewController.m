//
//  ViewController.m
//  rollToCrash
//
//  Created by 七野祐太 on 2014/07/20.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<AVAudioPlayerDelegate>
{

}


@property (weak, nonatomic) IBOutlet BugFixContainerView *containerViewBtnSetting;
@property (weak, nonatomic) IBOutlet UIButton *btnSetting;

@property (weak, nonatomic) IBOutlet UIScrollView *kScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *kPageControl;
@property (weak, nonatomic) IBOutlet kPageView *kContentViewSnare;
@property (weak, nonatomic) IBOutlet kPageView *kContentViewTimpani;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTimpaniViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTimpaniViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintSnareViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintSnareHeight;

@end
#pragma mark -
@implementation ViewController
#pragma mark audioControlls
+ (void) initialize{
    // 初回起動時の初期データ
    NSMutableDictionary *appDefaults = [[NSMutableDictionary alloc] init];
    [appDefaults setObject:@"0" forKey:@"KEY_countUpCrashPlayed"]; //　crash再生回数
    [appDefaults setObject:@"NO" forKey:@"KEY_ADMOBinterstitialRecieved"]; // インタースティシャル広告受信状況
    // ユーザーデフォルトの初期値に設定する
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults registerDefaults:appDefaults];
}



- (void)viewAdBanners{
    {
        // Zucks Banner
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){// iPhoneの場合は１つ
            FluctBannerView *fluctBannerView;
            fluctBannerView  = [[FluctBannerView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 50)];
            [fluctBannerView setMediaID:FLUCT_MEDIA_ID_iPhone];
            [self.view addSubview:fluctBannerView];
        }
        else{ // iPadの場合は2つ並べる。iPad用のサイズが用意されていないので。
            NSLog(@"iPadの処理");
            FluctBannerView *fluctBannerViewLeft;
            fluctBannerViewLeft  = [[FluctBannerView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width/2, 100)];
            [fluctBannerViewLeft setMediaID:FLUCT_MEDIA_ID_iPad_left];
            [self.view addSubview:fluctBannerViewLeft];
            
            FluctBannerView *fluctBannerViewRight;
            fluctBannerViewRight = [[FluctBannerView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, 20, self.view.frame.size.width/2, 100)];
            [fluctBannerViewRight setMediaID:FLUCT_MEDIA_ID_iPad_right];
            [self.view addSubview:fluctBannerViewRight];
        }
    }
    
    {
        // 【Ad】サイズを指定してAdMobインスタンスを生成
        bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
        
        // 【Ad】AdMobのパブリッシャーIDを指定
        bannerView_.adUnitID = MY_BANNER_UNIT_ID;
        
        
        // 【Ad】AdMob広告を表示するViewController(自分自身)を指定し、ビューに広告を追加
        bannerView_.rootViewController = self;
        [self.view addSubview:bannerView_];
        
        // ビューの一番下に表示
        [bannerView_ setCenter:CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height - bannerView_.bounds.size.height/2)];
        
        // 【Ad】AdMob広告データの読み込みを要求
        [bannerView_ loadRequest:[GADRequest request]];
        // AdMobバナーの回転時のautosize
        bannerView_.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        
        // 【Ad】インタースティシャル広告の表示
        interstitial_ = [[GADInterstitial alloc] init];
        interstitial_.adUnitID = MY_INTERSTITIAL_UNIT_ID;
        interstitial_.delegate = self;
        [interstitial_ loadRequest:[GADRequest request]];
    }
    
    
    {//NADViewの作成
//        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
//            NSLog(@"iPhoneの処理");
//            self.nadView = [[NADView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
//            [self.nadView setCenter:CGPointMake(self.view.bounds.size.width/2, self.nadView.bounds.size.height/2 + 20)];
//            // (3) ログ出力の指定
//            [self.nadView setIsOutputLog:YES];
//            // (4) set apiKey, spotId.
//            //        [self.nadView setNendID:@"a6eca9dd074372c898dd1df549301f277c53f2b9" spotID:@"3172"]; // テスト用
//            [self.nadView setNendID:@"139154ca4d546a7370695f0ba43c9520730f9703" spotID:@"208229"];
//            
//        }
//        else{
//            NSLog(@"iPadの処理");
//            self.nadView = [[NADView alloc] initWithFrame:CGRectMake(0, 0, 728, 90)];
//            [self.nadView setCenter:CGPointMake(self.view.bounds.size.width/2, self.nadView.bounds.size.height/2 + 20)]; // ヘッダー
//            // (3) ログ出力の指定
//            [self.nadView setIsOutputLog:NO];
//            // (4) set apiKey, spotId.
//            //      [self.nadView setNendID:@"2e0b9e0b3f40d952e6000f1a8c4d455fffc4ca3a" spotID:@"70999"]; // テスト用
//            [self.nadView setNendID:@"19d17a40ad277a000f27111f286dc6aaa0ad146b" spotID:@"220604"];
//            
//        }
//        [self.nadView setDelegate:self]; //(5)
//        [self.nadView load]; //(6)
//        [self.view addSubview:self.nadView]; // 最初から表示する場合
//
//        
    }
}

#pragma mark -


- (void)viewDidLoad
{
    [super viewDidLoad];

    //バックグラウンド時の対応
    
    if (&UIApplicationDidEnterBackgroundNotification) {
        
        [[NSNotificationCenter defaultCenter]
         
         addObserver:self
         
         selector:@selector(appDidEnterBackground:)
         
         name:UIApplicationDidEnterBackgroundNotification
         
         object:[UIApplication sharedApplication]];
        
    }
    
    //フォアグラウンド時の対応
    
    if (&UIApplicationWillEnterForegroundNotification) {
        
        [[NSNotificationCenter defaultCenter]
         
         addObserver:self
         
         selector:@selector(appWillEnterForeground:)
         
         name:UIApplicationWillEnterForegroundNotification
         
         object:[UIApplication sharedApplication]];
        
    }
    
    
    // 広告表示
    [self viewAdBanners]; // SS撮影のためコメントアウト
    
    NSArray *arraySnareImageNames = [NSArray arrayWithObjects:
                                     @"snare.png",
                                     @"hitL1.png",
                                     @"hitL2.png",
                                     @"hitR1.png",
                                     @"hitR2.png",nil];
    NSArray *arrayTimpaniImageNames = [NSArray arrayWithObjects:
                                       @"Timpani1024.png",
                                       @"Timpani1024hitL1.png",
                                       @"Timpani1024hitL2.png",
                                       @"Timpani1024hitR1.png",
                                       @"Timpani1024hitR2.png",nil];
    
    [_kContentViewSnare setImages:arraySnareImageNames soundName:@"roll13" capcion:@"Snare"];
    [_kContentViewTimpani setImages:arrayTimpaniImageNames soundName:@"timpani" capcion:@"Timpani"];
    // pageControl
    pages = [NSMutableArray array];
    [pages addObject:@{@"imageNames":arraySnareImageNames,
                       @"soundName":@"roll13",
                       @"caption":@"Snare Drum"}];
    [pages addObject:@{@"imageNames":arrayTimpaniImageNames,
                       @"soundName":@"timpani",
                       @"caption":@"Timpani"}];
    
    // pageControl設定
    _kPageControl.numberOfPages = 2;
    _kPageControl.currentPage = 0;
    // dot color
    _kPageControl.pageIndicatorTintColor = [UIColor grayColor];
    _kPageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    
    // scrollView設定
    _kScrollView.delegate = self;
    _kScrollView.scrollEnabled = YES;
    _kScrollView.pagingEnabled = YES;
    _kScrollView.showsHorizontalScrollIndicator = NO;
    _kScrollView.showsVerticalScrollIndicator = NO;
    _kScrollView.backgroundColor = [UIColor blueColor];
    

}

// scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    // get current page number
    CGFloat pageWidth = _kScrollView.frame.size.width;
    int pageNo = floor((_kScrollView.contentOffset.x - pageWidth/2)/pageWidth) + 1;
    _kPageControl.currentPage = pageNo;
    if (_kPageControl.currentPage == 0) {
        // stop roll
        [self.kContentViewSnare stopAudioResetAnimation];
    } else if (_kPageControl.currentPage == 1){
        // stop roll
        [self.kContentViewTimpani stopAudioResetAnimation];
    }
}


- (void)viewWillDisappear:(BOOL)animated{
    // 画面が隠れたらNend定期ロード中断
    [self.nadView pause];
    if (_kPageControl.currentPage == 0) {
        // stop roll
        [self.kContentViewSnare stopAudioResetAnimation];
    } else if (_kPageControl.currentPage == 1){
        // stop roll
        [self.kContentViewTimpani stopAudioResetAnimation];
    }
    
}


- (void)viewWillAppear:(BOOL)animated{
    // GoogleAnalystics導入にあたって必要
    self.screenName = @"RollToCrash_Main";
    // 画面が表示されたら定期ロード再開
    [self.nadView resume];
    
    [self.navigationController.navigationBar setHidden:1];

    

}

-(void)viewDidLayoutSubviews{
    NSLog(@"viewDidLayoutSubviews");
    CGRect viewBounds = [[UIScreen mainScreen] bounds];
    _constraintSnareViewWidth.constant = viewBounds.size.width;
    _constraintTimpaniViewWidth.constant = viewBounds.size.width;
    _constraintSnareHeight.constant = _containerViewBtnSetting.frame.origin.y;
    _constraintTimpaniViewHeight.constant = _containerViewBtnSetting.frame.origin.y;

    
    CGRect aPageFrame = _kContentViewSnare.frame;
    NSLog(@"aPageFrame:%.2f,%.2f,%.2f,%.2f",aPageFrame.origin.x,aPageFrame.origin.y,aPageFrame.size.width,aPageFrame.size.height);
    NSLog(@"snareview.frame:%.2f,%.2f,%.2f,%.2f",_kContentViewSnare.frame.origin.x,_kContentViewSnare.frame.origin.y,_kContentViewSnare.frame.size.width,_kContentViewSnare.frame.size.height);
    // scrollable content's width and height
    _kScrollView.contentSize = CGSizeMake(aPageFrame.size.width * pages.count, aPageFrame.size.height);
    NSLog(@"contentsize:%.2f,%.2f",_kScrollView.contentSize.width,_kScrollView.contentSize.height);

}

// ビューが表示されたときに実行される
- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)dealloc{
    // AdMobBannerviewの開放
    bannerView_ = nil;
    // nendの開放
    [self.nadView setDelegate:nil];//delegateにnilをセット
    self.nadView = nil; // プロパティ経由でrelease,nilをセット
    // AdMobinterstitialの開放　これをしないと再ロードできない
    [interstitial_ setDelegate:nil];
    interstitial_ = nil; //
    // [super dealloc]; // MRC(非アーク時には必要)
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)appDidEnterBackground:(NSNotification *)notification{

}

- (void)appWillEnterForeground:(NSNotification *)notification{

}


#pragma mark -
#pragma mark AdMobDelegate
// AdMobバナーのloadrequestが失敗したとき
-(void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error{
    NSLog(@"adView:didFailToReceiveAdWithError:%@", [error localizedDescription]);
    
    // 他の広告ネットワークの広告を表示させるなど。
}


#pragma mark nendDelegate
// nend広告受け取ったらここで処理
- (void)nadViewDidReceiveAd:(NADView *)adView{
    
    
}

// スプラッシュ画面を1秒表示する
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // ここでスレッドを止める
    [NSThread sleepForTimeInterval:2.0];
//    sleep(1);
    
    return YES;
}

//スクリーンショット撮影用
//- (BOOL)prefersStatusBarHidden
//{
//    return YES;
//}
@end