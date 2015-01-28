//
//  kPageVC.m
//  rollToCrash
//
//  Created by 七野祐太 on 2015/01/26.
//  Copyright (c) 2015年 shichino yuta. All rights reserved.
//

#import "kPageVC.h"

@interface kPageVC ()

@end

@implementation kPageVC
+ (void) initialize{
    // 初回起動時の初期データ
    NSMutableDictionary *appDefaults = [[NSMutableDictionary alloc] init];
    [appDefaults setObject:@"0" forKey:@"KEY_countUpCrashPlayed"]; //　crash再生回数
    [appDefaults setObject:@"NO" forKey:@"KEY_ADMOBinterstitialRecieved"]; // インタースティシャル広告受信状況
    // ユーザーデフォルトの初期値に設定する
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults registerDefaults:appDefaults];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    self.navigationController.toolbar.delegate = self;
    [self.navigationController.toolbar setCenter:CGPointMake(self.view.center.x, self.view.frame.size.height - 50)];
    
    self.dataSource = self;
    self.delegate = self;
    
    imageNameArray = @[@[@"snare.png",
                         @"hitL1.png",
                         @"hitL2.png",
                         @"hitR1.png",
                         @"hitR2.png"],
                       @[@"Timpani1024.png",
                         @"Timpani1024hitL1.png",
                         @"Timpani1024hitL2.png",
                         @"Timpani1024hitR1.png",
                         @"Timpani1024hitR2.png"]];

    soundNameArray = @[@"roll13",
                       @"timpani"
                       ];
    
    captionArray = @[@"Snare",
                     @"Timpani"
                     ];

    
    ContentViewController *startingViewController = [self viewControllerAtIndex:0];

    NSArray *viewControllers = @[startingViewController];
    [self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    // 広告表示
    [self viewAdBanners]; // SS撮影のためコメントアウト
}

-(ContentViewController *)viewControllerAtIndex:(NSUInteger)index{
    if (([captionArray count] == 0) || (index >= [captionArray count])) {
        return nil;
    }
    // create new page
    ContentViewController *contentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ContentVC"];
    contentVC.imageNames = imageNameArray[index];
    contentVC.soundName = soundNameArray[index];
    contentVC.caption = captionArray[index];
    contentVC.pageIndex = index;
    return contentVC;
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:1];
}
-(void)viewDidAppear:(BOOL)animated{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Page View Controller Data Source
// UIPageViewController上で右スワイプした時に呼ばれるメソッド
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    NSUInteger index = ((ContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
}
// UIPageViewController上で左スワイプした時に呼ばれるメソッド
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSUInteger index = ((ContentViewController*) viewController).pageIndex;
    
    if ((index >= [captionArray count]) || (index == NSNotFound)) {
        return nil;
    }
    
    index++;
    if (index == [captionArray count]) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}
- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if(completed){
        ContentViewController *vc =[self.viewControllers lastObject];
        currentPageIndex =  vc.pageIndex;
    }
}

- (void)viewAdBanners{
    {
        // Zucks Banner
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){// iPhoneの場合は１つ
            NSLog(@"Fluct");
            FluctBannerView *fluctBannerView;
            fluctBannerView  = [[FluctBannerView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 50)];
            [fluctBannerView setMediaID:FLUCT_MEDIA_ID_iPhone];
            [self.view addSubview:fluctBannerView];
            NSLog(@"Fluct.frame:%.2f,%.2f,%.2f,%.2f",fluctBannerView.frame.origin.x,fluctBannerView.frame.origin.y,fluctBannerView.frame.size.width,fluctBannerView.frame.size.height);
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
