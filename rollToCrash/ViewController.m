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
    AVAudioPlayer *_rollPlayerTmp;
    AVAudioPlayer *_rollPlayerAlt;
    AVAudioPlayer *_crashPlayer;
    ImageViewCircle *greenCircle;
    ImageViewCircle *redCircle;
    // タイマー
    NSTimer *_playTimer; // AVAudioPlayerコントロール用
    // アニメーションタイマー
    NSTimer *_rippleAnimationTimer; // rippleアニメーションコントロール用
    NSTimer *_ctrlBtnAnimationTimer; // ctrlBtnアニメーションコントロール用
    NSTimer *_textAnimationTimer; // textアニメーションコントロール用
    NSTimer *_ctrlBtnPlayingTimer; // redRipple縮小中のアニメーションタイマー
    NSTimer *_setIntervalToViewDidAppear; // crash再生後にviewDidAppearするタイミング調整用タイマー
    
    
    // 【アニメーション】ロール再生中のコマを入れる配列
    NSArray *animationSeq;
    
    BOOL _nadViewAppeared;
}

@property (weak, nonatomic) IBOutlet UIButton *ctrlBtn;
@property (weak, nonatomic) IBOutlet UIButton *pauseBtn;

@property (weak, nonatomic) IBOutlet UIImageView *altCtrlBtnForCrashAnimation; // ctrlBtnをそのまま同様のアニメーションをさせると、ctrlBtnをギュンギュンアニメーションさせている都合で、タイミングによって結果がとても大きくなることがあるため、本イメージビューをアニメーション用として準備
@property (weak, nonatomic) IBOutlet UIImageView *altCtrlBtnForScaleUp;

@property (weak, nonatomic) IBOutlet UIImageView *altCtrlBtnForScaleDown;


- (IBAction)touchUpInsideCtrlBtn:(UIButton *)sender;
- (IBAction)touchDownCtrlBtn:(UIButton *)sender;
- (IBAction)touchDragExitCtrlBtn:(UIButton *)sender;
- (IBAction)touchDragEnterCtrlBtn:(UIButton *)sender;

- (IBAction)touchUpInsidePauseBtn:(UIButton *)sender;
- (IBAction)touchDownPauseBtn:(UIButton *)sender;
- (IBAction)touchDragExitPauseBtn:(UIButton *)sender;
- (IBAction)touchDragEnterPauseBtn:(UIButton *)sender;

- (IBAction)touchDownBackgroundBtn:(UIButton *)sender;



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

- (void)initializeAVAudioPlayers{
    // (audioplayer)再生する効果音のパスを取得する
    // ロールtmp
    NSString *path_roll = [[NSBundle mainBundle] pathForResource:@"roll13" ofType:@"mp3"];
    NSURL *url_roll = [NSURL fileURLWithPath:path_roll];
    _rollPlayerTmp = [[AVAudioPlayer alloc] initWithContentsOfURL:url_roll error:NULL];
    
    // ロールalt
    _rollPlayerAlt = [[AVAudioPlayer alloc] initWithContentsOfURL:url_roll error:NULL];
    
    // クラッシュ
    NSString *path_clash = [[NSBundle mainBundle] pathForResource:@"crash13" ofType:@"mp3"];
    NSURL *url_clash = [NSURL fileURLWithPath:path_clash];
    _crashPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url_clash error:NULL];
    
    // プレイヤーを準備
    [_rollPlayerTmp prepareToPlay];
    [_rollPlayerAlt prepareToPlay];
    [_crashPlayer prepareToPlay];
}

// タイマー生成
- (void)playerControll{
    // playerControllをrollPlayerTmp.duration - 2秒の間隔で呼び出すタイマーを作る
    _playTimer = [NSTimer scheduledTimerWithTimeInterval:((float)_rollPlayerTmp.duration - 2.0f)
                                                  target:self
                                                selector:@selector(playerControllTimer)
                                                userInfo:nil
                                                 repeats:YES];
}

// _playTimerから呼び出すメソッドでプレイヤーの交換、フェードイン・アウトをコントロール
- (void)playerControllTimer{
    NSTimer *timer;
    // playerの開始位置を以下で　2.0にしているためdurfation -3 にしないと、pleyerが再生完了してしまう
    if (_rollPlayerTmp.playing) {
        // altを代替プレイヤーとして再生
        [_rollPlayerAlt startAltPlayerSetStartTime:1.0 setVolume:0.4];
        
        // クロスフェード処理
        timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                 target:self
                                               selector:@selector(crossFadePlayerTmpToAlt:)
                                               userInfo:nil
                                                repeats:YES];
    } else if(_rollPlayerAlt.playing) {
        // tmpを代替プレイヤーとして再生
        [_rollPlayerTmp startAltPlayerSetStartTime:1.0 setVolume:0.4];
        
        // クロスフェード処理
        timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                 target:self
                                               selector:@selector(crossFadePlayerAltToTmp:)
                                               userInfo:nil
                                                repeats:YES];
    }
}

// 2つのロールプレイヤーをtmp→altへクロスフェードさせるメソッド
- (void)crossFadePlayerTmpToAlt:(NSTimer *)timer{
    // tmpPlayerとaltPlayerのボリュームを0.1ずつ上げ下げ
    _rollPlayerTmp.volume = _rollPlayerTmp.volume - 0.1;
    _rollPlayerAlt.volume = _rollPlayerAlt.volume + 0.1;
    
    NSLog(@"tmp.volume %.2f",_rollPlayerTmp.volume);
    NSLog(@"alt.volume %.2f",_rollPlayerAlt.volume);
    
    if ((int)_rollPlayerAlt.volume == 1) {
        [timer invalidate];
        // tmpPlayerの再生を止めてcurrentTimeを0.0にセット
        [_rollPlayerTmp stopPlayer];
    }
}

// 2つのロールプレイヤーをalt→tmpへクロスフェードさせるメソッド
- (void)crossFadePlayerAltToTmp:(NSTimer *)timer{
    // tmpPlayerとaltPlayerのボリュームを0.1ずつ上げ下げ
    _rollPlayerTmp.volume = _rollPlayerTmp.volume + 0.1;
    _rollPlayerAlt.volume = _rollPlayerAlt.volume - 0.1;
    
    NSLog(@"tmp.volume %.2f",_rollPlayerTmp.volume);
    NSLog(@"alt.volume %.2f",_rollPlayerAlt.volume);
    
    if ((int)_rollPlayerTmp.volume == 1) {
        [timer invalidate];
        // altPlayerの再生を止めてcurrentTimeを0.0にセット
        [_rollPlayerAlt stopPlayer];
    }
}


#pragma mark rippleSetUp
- (void) greenRippleSetUp{
    // デバイスがiphoneであるかそうでないかで分岐
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        NSLog(@"iPhoneの処理");
        // ストロークカラーを緑に設定
        UIColor *color = [UIColor colorWithRed:0.20 green:0.80 blue:0.40 alpha:1.0]; // EMERALD
        // ストロークの太さを設定
        CGFloat lineWidth = 2.5f;
        // 半径を設定
        CGFloat radius = (int)self.ctrlBtn.bounds.size.width * 0.95; //224
        // インスタンスを生成
        greenCircle = [[ImageViewCircle alloc] initWithFrame:CGRectMake(0, 0, radius, radius) withColor:color withLineWidth:lineWidth];
    }
    else{
        NSLog(@"iPadの処理");
        // ストロークカラーを緑に設定
        UIColor *color = [UIColor colorWithRed:0.20 green:0.80 blue:0.40 alpha:1.0]; // EMERALD
        // ストロークの太さを設定
        CGFloat lineWidth = 10.0f;
        // 半径を設定
        CGFloat radius = (int)self.ctrlBtn.bounds.size.width * 0.95; // 448
        // インスタンスを生成
        greenCircle = [[ImageViewCircle alloc] initWithFrame:CGRectMake(0, 0, radius, radius) withColor:color withLineWidth:lineWidth];
    }
    
    
    [greenCircle setImage:[greenCircle imageFillEllipseInRect]];
    
    // イメージビューのセンターをctrlAudioPlayerBtn.centerと合わせる
    [greenCircle setCenter:self.ctrlBtn.center];
    // アニメーション再生まで隠しておく
    [greenCircle setHidden:1];
}

- (void)redRippleSetUp{
    
    // デバイスがiphoneであるかそうでないかで分岐
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        NSLog(@"iPhoneの処理");
        // ストロークカラーを赤に設定
        UIColor *color = [UIColor colorWithRed:0.80 green:0.20 blue:0.00 alpha:1]; // ALIZARIN
        // ストロークの太さを設定
        CGFloat lineWidth = 2.0f;
        // 半径を設定
        CGFloat radius = (int)self.ctrlBtn.bounds.size.width * 1.2; // 286
        // インスタンスを生成
        redCircle = [[ImageViewCircle alloc] initWithFrame:CGRectMake(0, 0, radius, radius) withColor:color withLineWidth:lineWidth];
        
    }
    else{
        NSLog(@"iPadの処理");
        // ストロークカラーを赤に設定
        UIColor *color = [UIColor colorWithRed:0.80 green:0.20 blue:0.00 alpha:1]; // ALIZARIN
        // ストロークの太さを設定
        CGFloat lineWidth = 10.0f;
        // 半径を設定
        CGFloat radius = (int)self.ctrlBtn.bounds.size.width * 1.2;// 542
        // インスタンスを生成
        redCircle = [[ImageViewCircle alloc] initWithFrame:CGRectMake(0, 0, radius, radius) withColor:color withLineWidth:lineWidth];
    }
    
    
    
    [redCircle setImage:[redCircle imageFillEllipseInRect]];
    
    // 円をctrlBtn.centerと合わせる
    [redCircle setCenter:self.ctrlBtn.center];
    // ImageViewCircleをアニメーション開始までhiddenにする
    [redCircle setHidden:1];
}

- (void) ctrlBtnGrennRippleAnimationStart{
    // サークルアニメーションタイマーを破棄する
    [self animationTimerInvalidate];
    
    // ctrlBtnの画像を差し替える
    [self.ctrlBtn setImage:[UIImage imageNamed:@"ctrlBtnDF.png"] forState:UIControlStateNormal];
    [self.ctrlBtn setImage:[UIImage imageNamed:@"ctrlBtnDF.png"] forState:UIControlStateHighlighted];
    [self.ctrlBtn setImage:[UIImage imageNamed:@"ctrlBtnDF.png"] forState:UIControlStateDisabled];
    
    
    // 円とctrlBtnのふわふわアニメーション
    // 【アニメーション】円の拡大アニメーションを3.0秒間隔で呼び出すタイマーを作る
    _rippleAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f
                                                             target:greenCircle
                                                           selector:@selector(rippleAnimation)
                                                           userInfo:nil
                                                            repeats:YES];
    _ctrlBtnAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f
                                                              target:self.ctrlBtn
                                                            selector:@selector(scaleUpBtn)
                                                            userInfo:nil
                                                             repeats:YES];
    
}

- (void) ctrlBtnRedRippleAnimationStart:(NSTimer *)timer{
    // サークルアニメーションタイマーを破棄する
    [_rippleAnimationTimer invalidate];
    [_ctrlBtnAnimationTimer invalidate];
    [_textAnimationTimer invalidate];
    
    // touchDown時のtransformとdisabelにしたのを戻す
    [self.ctrlBtn clearTransformBtnSetEnable];
    
    
    // 【アニメーション】円の縮小アニメーションを0.6秒間隔で呼び出すタイマーを作る
    _rippleAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:0.6f
                                                             target:redCircle
                                                           selector:@selector(rippleAnimationReverse)
                                                           userInfo:nil
                                                            repeats:YES];
    _ctrlBtnAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:0.6f
                                                              target:self.ctrlBtn
                                                            selector:@selector(scaleDownBtn)
                                                            userInfo:nil
                                                             repeats:YES];
    
    
    
    
    
    [timer invalidate];
    
}

// ctrlBtnのハイライトアニメーション
- (void)ctrlBtnHighlightedAnimationStart {
    [self.ctrlBtn setEnabled:0];
    
    if (_rollPlayerTmp.isPlaying || _rollPlayerAlt.isPlaying) {
        // ここにctrlBtnのぷるぷるアニメーション（強)を書く
        [self.ctrlBtn highlightedAnimation];
        _ctrlBtnAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:0.5f
                                                                  target:self.ctrlBtn
                                                                selector:@selector(strongVibeAnimationKeepTransform)
                                                                userInfo:nil
                                                                 repeats:YES];
    } else{
        // ここにctrlBtnのぷるぷるアニメーション(弱)を書く
        [self.ctrlBtn highlightedAnimation];
        // ぷるぷるアニメーション(弱)はやめた
        //        _ctrlBtnAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:1.5f
        //                                                                  target:self.ctrlBtn
        //                                                                selector:@selector(vibeAnimationKeepTransform)
        //                                                                userInfo:nil
        //                                                                 repeats:YES];
    }
}

// アニメーションタイマーをまとめて破棄
- (void)animationTimerInvalidate {
    [_rippleAnimationTimer invalidate];
    [_ctrlBtnAnimationTimer invalidate];
    [_textAnimationTimer invalidate];
    [_ctrlBtnPlayingTimer invalidate];
}

#pragma mark -
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    _nadViewAppeared = NO;
    
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
    
    //NADViewの作成
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        NSLog(@"iPhoneの処理");
        self.nadView = [[NADView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        [self.nadView setCenter:CGPointMake(self.view.bounds.size.width/2, self.nadView.bounds.size.height/2)];
        // (3) ログ出力の指定
        [self.nadView setIsOutputLog:YES];
        // (4) set apiKey, spotId.
        [self.nadView setNendID:@"a6eca9dd074372c898dd1df549301f277c53f2b9" spotID:@"3172"]; // テスト用
        //     [self.nadView setNendID:@"139154ca4d546a7370695f0ba43c9520730f9703" spotID:@"208229"];
        
    }
    else{
        NSLog(@"iPadの処理");
        self.nadView = [[NADView alloc] initWithFrame:CGRectMake(0, 0, 728, 90)];
        [self.nadView setCenter:CGPointMake(self.view.bounds.size.width/2, self.nadView.bounds.size.height/2)]; // ヘッダー
        // (3) ログ出力の指定
        [self.nadView setIsOutputLog:NO];
        // (4) set apiKey, spotId.
        [self.nadView setNendID:@"2e0b9e0b3f40d952e6000f1a8c4d455fffc4ca3a" spotID:@"70999"]; // テスト用
        //        [self.nadView setNendID:@"19d17a40ad277a000f27111f286dc6aaa0ad146b" spotID:@"220604"];
        
    }
    [self.nadView setDelegate:self]; //(5)
    [self.nadView load]; //(6)
    [self.view addSubview:self.nadView]; // 最初から表示する場合
    NSLog(@"viewDidLoad");
    NSLog(@"view.bounds.size %@",NSStringFromCGSize(self.view.bounds.size));
    NSLog(@"nad.size %@",NSStringFromCGSize(self.nadView.bounds.size));
    NSLog(@"nad.center %@",NSStringFromCGPoint(self.nadView.center));
    
    
    
    // (audioplayer)再生する効果音のパスを取得しインスタンス生成
    [self initializeAVAudioPlayers];
    
    // 【アニメーション】ロール再生中の各コマのイメージを配列に入れる
    animationSeq = @[[UIImage imageNamed:@"hitR2.png"],
                     [UIImage imageNamed:@"hitR1.png"],
                     [UIImage imageNamed:@"hitR2.png"],
                     
                     [UIImage imageNamed:@"hitL2.png"],
                     [UIImage imageNamed:@"hitL1.png"],
                     [UIImage imageNamed:@"hitL2.png"]
                     
                     ];
    
    
    // ボタンのイメージビューにアニメーションの配列を設定する
    self.ctrlBtn.imageView.animationImages = animationSeq;
    // アニメーションの長さを設定する
    self.ctrlBtn.imageView.animationDuration = 1.2;//1.35
    // 無限の繰り返し回数
    self.ctrlBtn.imageView.animationRepeatCount = 0;
    
    
    
    // ctrlBtnを起動時だけ回転拡大で出現するために隠す
    [self.ctrlBtn setAlpha:0];
    [self.ctrlBtn setHidden:0];
    [self.ctrlBtn setEnabled:0];
    [self.altCtrlBtnForCrashAnimation setHidden:1];
    
    // pauseBtnがdisableのときに色を薄くしないために画像設定
    [self.pauseBtn setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateDisabled];
}

- (void)viewWillDisappear:(BOOL)animated{
    // 画面が隠れたらNend定期ロード中断
    [self.nadView pause];
}


- (void)viewWillAppear:(BOOL)animated{
    // 画面が表示されたら定期ロード再開
    [self.nadView resume];
}

// ビューが表示されたときに実行される
- (void)viewDidAppear:(BOOL)animated
{
    // crash再生後にviewDidAppearするタイミング調整用タイマーの破棄
    [_setIntervalToViewDidAppear invalidate];
    // ctrl、rippleアニメーションタイマー破棄
    if (_ctrlBtnAnimationTimer != nil) {
        [_ctrlBtnAnimationTimer invalidate];
    }
    if (_rippleAnimationTimer != nil) {
        [_rippleAnimationTimer invalidate];
    }
    // 最初の１回だけ
    if (self.ctrlBtn.alpha == 0) {
        [self.altCtrlBtnForScaleUp appearEmeraldWithScaleUp:nil]; // 0.4sec
        
        NSTimer *setIntervalToCtrlBtnAppear; // appearEmeraldWithScaleUpのアニメーション(0.4sec)待ち
        setIntervalToCtrlBtnAppear = [NSTimer scheduledTimerWithTimeInterval:0.4f
                                                                      target:self.ctrlBtn
                                                                    selector:@selector(appearAfterInterval:)
                                                                    userInfo:setIntervalToCtrlBtnAppear
                                                                     repeats:NO];
    }
    
    [self greenRippleSetUp];
    
    // ビューにimgViewCircleを描画
    [self.view addSubview:greenCircle];
    [self ctrlBtnGrennRippleAnimationStart];
    
    // crashPlayerの再生回数が5の倍数かつインタースティシャル広告の準備ができていればインタースティシャル広告表示
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger i = [defaults integerForKey:@"KEY_countUpCrashPlayed"];
    BOOL b = [defaults boolForKey:@"KEY_ADMOBinterstitialRecieved"];
    NSLog(@"countUpCrashPlayed %ld", (long)i);
    
    if (b == NO) {
        [self interstitialLoad];
    }
    
    if (((i % 5) == 0) && (b == YES)) {
        [interstitial_ presentFromRootViewController:self];
    }
    
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

#pragma mark -
#pragma mark touchAction
// ctrlBtnのtouchUpInside時に実行される処理を実装
- (IBAction)touchUpInsideCtrlBtn:(UIButton *)sender {
    
    if (_rollPlayerTmp.isPlaying || _rollPlayerAlt.isPlaying) {
        // ドラムロール再生中にctrlBtnが押されたときクラッシュ再生
        
        // crash再生する度に再生回数を+1してNSUserDefaultsに保存
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSInteger i = [defaults integerForKey:@"KEY_countUpCrashPlayed"];
        i = i +1;
        [defaults setInteger:i forKey:@"KEY_countUpCrashPlayed"];
        [defaults synchronize];
        
        // 【アニメーション】ロールのアニメーションを停止
        [self.ctrlBtn.imageView stopAnimating];
        // アニメーションタイマーを破棄する
        [self animationTimerInvalidate];
        // ALIZARINのimageviewをhiddenにする。appearALIZARINWithScaleUpが再生完了前にtouchUpInsideされたとき用
        [self.altCtrlBtnForScaleUp setHidden:1];
        
        // ドラムロールを止めcrash再生
        [_crashPlayer playCrashStopRolls:_rollPlayerTmp :_rollPlayerAlt];
        // プレイヤータイマーを破棄する
        [_playTimer invalidate];
        
        // ストロークカラーを赤に設定
        UIColor *color = [UIColor colorWithRed:0.906 green:0.298 blue:0.235 alpha:1]; // ALIZARIN
        // ストロークの太さを設定
        CGFloat lineWidth = 4.0f;
        // 半径を設定
        CGFloat radius = 224;
        // インスタンスを生成
        ImageViewCircle *lastCircle = [[ImageViewCircle alloc] initWithFrame:CGRectMake(0, 0, radius, radius) withColor:color withLineWidth:lineWidth];
        [lastCircle setImage:[lastCircle imageFillEllipseInRect]];
        
        // イメージビューのセンターをctrlAudioPlayerBtn.centerと合わせる
        [lastCircle setCenter:self.ctrlBtn.center];
        // ImageViewCircleをアニメーション開始までhiddenにする
        [lastCircle setHidden:1];
        // ビューにimgViewCircleを描画
        [self.view addSubview:lastCircle];
        
        
        // touchDown時のtransformとdisabelにしたのを戻す
        [self.ctrlBtn clearTransformBtnSetEnable];
        [self.ctrlBtn setHidden:1];  // altCtrlBtnForCrashAnimationをそのまま拡大アニメーションすると拡大されすぎる問題があったのでctrlBtn.aphaを0にする。hiddenにするとviewDidAppearでの拡大アニメーションが再生されてしまう問題あり
        
        // 円のクラッシュ再生時のアニメーション
        [lastCircle circleAnimationFinish:0.4];
        
        // defaultの画像が回転しながら大きくなってくるアニメーション
        [self.altCtrlBtnForCrashAnimation crashUIImageViewAnimation]; // (1.09sec)ctrlBtnをそのまま同様のアニメーションをさせると、ctrlBtnをギュンギュンアニメーションさせている都合で、タイミングによって結果がとても大きくなることがあるため、本イメージビューをアニメーション用として準備
        
        NSTimer *setIntervalToCtrlBtnAppear; // crashUIImageViewAnimationのアニメーション(1.09sec)が終わったらctrlBtnを表示
        setIntervalToCtrlBtnAppear = [NSTimer scheduledTimerWithTimeInterval:1.09f
                                                                      target:self.ctrlBtn
                                                                    selector:@selector(appearAfterInterval:)
                                                                    userInfo:setIntervalToCtrlBtnAppear
                                                                     repeats:NO];
        // crash再生後にviewDidAppearするタイミング調整用タイマー
        _setIntervalToViewDidAppear = [NSTimer scheduledTimerWithTimeInterval:1.09f
                                                                       target:self
                                                                     selector:@selector(viewDidAppear:) // 初期画面を表示
                                                                     userInfo:nil
                                                                      repeats:NO];
        //pauseBtnの消失アニメーション
        [self.pauseBtn disappearWithRotateScaleDownSetDisable];
        
    } else {
        // ドラムロール停止中にctrlBtnが押されたとき
        
        // ドラムロールを再生する
        [_rollPlayerTmp playRollStopCrash:_crashPlayer setVolumeZero:_rollPlayerAlt ];
        // playerControllを1.0秒間隔で呼び出すタイマーを作る
        [self playerControll];
        
        
        // redCircle準備
        [self redRippleSetUp];
        // ビューにimgViewCircleを描画
        [self.view addSubview:redCircle];
        
        // ctrlBtnRedRippleAnimationStartするまでctrlBtnを隠す
        [self.ctrlBtn setHidden:1];
        
        // 赤いctrlBtnの拡大
        [self.altCtrlBtnForScaleUp appearALIZARINWithScaleUp:nil]; // 0.4sec
        
        
        // appearALIZARINWithScaleUp(0.4sec)待ちでctrlBtnとrippleアニメーション開始
        _ctrlBtnPlayingTimer = [NSTimer scheduledTimerWithTimeInterval:0.4f // appearAILZARINWithScaleUp終わり待ち
                                                                target:self
                                                              selector:@selector(ctrlBtnRedRippleAnimationStart:)
                                                              userInfo:_ctrlBtnPlayingTimer
                                                               repeats:NO];
        
        // 【アニメーション】ロールのアニメーションを再生する
        [self.ctrlBtn.imageView startAnimating];
        
        
        // statStopBtn がhiddenのときだけ実行
        if (self.pauseBtn.hidden == 1) {
            // 【アニメーション】pauseBtnを拡大/回転しながら表示
            [self.pauseBtn appearWithRotateScaleUpSetEnable];
        }
    }
    
}


/* ctrlBtnのハイライト処理 */
// タッチしたとき
- (IBAction)touchDownCtrlBtn:(UIButton *)sender {
    [_ctrlBtnAnimationTimer invalidate];
    
    [self ctrlBtnHighlightedAnimationStart]; // プルプルアニメーション
    
}
// ドラッグして外に出たとき
- (IBAction)touchDragExitCtrlBtn:(UIButton *)sender {
    [self.ctrlBtn clearTransformBtnSetEnable];
    if (_rollPlayerTmp.isPlaying || _rollPlayerAlt.isPlaying) {
        // あかを復活
        [self ctrlBtnRedRippleAnimationStart:nil];
    } else{
        // みどりをふっかつ
        [self ctrlBtnGrennRippleAnimationStart];
    }
}
// ドラッグして中に入ったとき
- (IBAction)touchDragEnterCtrlBtn:(UIButton *)sender {
    [_ctrlBtnAnimationTimer invalidate];
    [_textAnimationTimer invalidate];
    [self ctrlBtnHighlightedAnimationStart];
    
}


/* PauseBtnのハイライト処理 */
// タッチしたとき
- (IBAction)touchDownPauseBtn:(UIButton *)sender {
    [self.pauseBtn highlightedAnimation]; // ハイライトアニメーション実行
}

// ctrlBtnの下のpauseBtnを押した時に実行される処理を実装
- (IBAction)touchUpInsidePauseBtn:(UIButton *)sender {
    // ドラムロールが再生中にpauseBtnが押されたとき
    // ループしているドラムロールを止める
    [_rollPlayerTmp stop];
    _rollPlayerTmp.currentTime = 0.0;
    [_rollPlayerAlt stop];
    _rollPlayerAlt.currentTime = 0.0;
    
    // プレイヤータイマーを破棄する
    [_playTimer invalidate];
    // アニメーションタイマーをまとめて破棄
    [self animationTimerInvalidate];
    
    // 【アニメーション】ロールのアニメーションを停止
    [self.ctrlBtn.imageView stopAnimating];
    
    
    
    // ctrlBtnの画像を一旦クリア
    self.ctrlBtn.imageView.image = nil; // ctrlBtnのパラパラアニメーション終わりにhighlightedの画像が表示される対策
    // ctrlBtnの画像をデフォルトの画像に設定
    self.ctrlBtn.imageView.image = [UIImage imageNamed:@"ctrlBtnDF.png"];
    // ctrlBtnをhiddenかつ無効にする
    [self.ctrlBtn setEnabled:0];
    [self.ctrlBtn setHidden:1];
    // 赤いUIImageView消える
    [self.altCtrlBtnForScaleDown disappearALIZARINWithScaleUp:nil]; // 0.3f
    
    //pauseBtnの消失アニメーション
    [self.pauseBtn disappearWithRotateScaleDownSetDisable];
    
    
    
    // 初期画面を呼び出す
    NSTimer *setIntervalToCtrlBtnEmeraldAppear;
    setIntervalToCtrlBtnEmeraldAppear = [NSTimer scheduledTimerWithTimeInterval:0.25f // disappearALIZARINWithScaleUpのアニメーションの途中から再生
                                                                         target:self.altCtrlBtnForScaleUp
                                                                       selector:@selector(appearEmeraldWithScaleUp:) // 0.4sec
                                                                       userInfo:setIntervalToCtrlBtnEmeraldAppear
                                                                        repeats:NO];
    
    NSTimer *setIntervalToCtrlBtnAppear; // altCtrlBtnForCrashAnimationのアニメーション(0.33sec)が終わったらctrlBtn.hiddenを0にする
    setIntervalToCtrlBtnAppear = [NSTimer scheduledTimerWithTimeInterval:0.65f
                                                                  target:self.ctrlBtn
                                                                selector:@selector(appearAfterInterval:)
                                                                userInfo:setIntervalToCtrlBtnAppear
                                                                 repeats:NO];
    [self greenRippleSetUp];
    
    // ビューにimgViewCircleを描画
    [self.view addSubview:greenCircle];
    [self ctrlBtnGrennRippleAnimationStart];
    
    
}

// ドラッグして中に入った時
- (IBAction)touchDragEnterPauseBtn:(UIButton *)sender {
    [self.pauseBtn highlightedAnimation]; // ハイライトアニメーション実行
}

// ドラッグして外に出たとき
- (IBAction)touchDragExitPauseBtn:(UIButton *)sender {
    [self.pauseBtn clearTransformBtnSetEnable]; // 元に戻す
}

- (IBAction)touchDownBackgroundBtn:(UIButton *)sender {
    [_crashPlayer stopPlayer];
    
}

#pragma mark -
#pragma mark interface rotated


// デバイス回転時に広告の表示位置を調整
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    // デバイスが横になっているかどうか
    UIDeviceOrientation orientation = [[UIDevice currentDevice]orientation];
    BOOL landscaped; // 横になったかどうか
    switch (orientation) {
        case 0://            UIDeviceOrientationUnknown,
        case 1://            UIDeviceOrientationPortrait,            // Device oriented vertically, home button on the bottom
        case 2://            UIDeviceOrientationPortraitUpsideDown,  // Device oriented vertically, home button on the top
        case 5://            UIDeviceOrientationFaceUp,              // Device oriented flat, face up
        case 6://            UIDeviceOrientationFaceDown             // Device oriented flat, face down
            landscaped = NO;
            break;
        case 3://            UIDeviceOrientationLandscapeLeft,       // Device oriented horizontally, home button on the right
        case 4://            UIDeviceOrientationLandscapeRight,      // Device oriented horizontally, home button on the left
            landscaped = YES;
            break;
            
        default:
            break;
    }
    // デバイスがiphoneであるかそうでないかで分岐
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        NSLog(@"iPhoneの処理"); // GeneralからiPhoneのデバイス回転対応は無効にしてるいるが調整が必要なときに備えて残しておく
        switch (fromInterfaceOrientation) {
                
                // ポートレイトから回転しランドスケープになったときの処理
            case UIInterfaceOrientationPortrait:
                // nend位置調整
                [self.nadView setCenter:CGPointMake(self.view.bounds.size.width/2, self.nadView.bounds.size.height/2)];
                // ctrlBtn自身と同座標のUIImageViewの位置調整
                int adjustX = 180;
                [self.ctrlBtn setCenter:CGPointMake(adjustX, self.view.bounds.size.height/2)];
                [self.altCtrlBtnForScaleDown setCenter:self.ctrlBtn.center];
                [self.altCtrlBtnForScaleUp setCenter:self.ctrlBtn.center];
                [self.altCtrlBtnForCrashAnimation setCenter:self.ctrlBtn.center];
                [greenCircle setCenter:self.ctrlBtn.center];
                [redCircle setCenter:self.ctrlBtn.center];
                
                // pauseBtnの回転後の位置調整
                [self.pauseBtn setCenter:CGPointMake(self.ctrlBtn.center.x + 200,self.view.bounds.size.height/2 )];
                break;
                
                
                // ランドスケープから回転しポートレイトになったときの処理
            case UIInterfaceOrientationLandscapeLeft:
            case UIInterfaceOrientationLandscapeRight:
                // nend位置調整
                [self.nadView setCenter:CGPointMake(self.view.bounds.size.width/2, self.nadView.bounds.size.height/2)];
                if (!landscaped) {
                    // ctrlBtn自身と同座標のUIImageViewの位置調整
                    int adjustY = 220;
                    [self.ctrlBtn setCenter:CGPointMake(self.view.bounds.size.width/2, adjustY)];
                    [self.altCtrlBtnForScaleDown setCenter:self.ctrlBtn.center];
                    [self.altCtrlBtnForScaleUp setCenter:self.ctrlBtn.center];
                    [self.altCtrlBtnForCrashAnimation setCenter:self.ctrlBtn.center];
                    [greenCircle setCenter:self.ctrlBtn.center];
                    [redCircle setCenter:self.ctrlBtn.center];
                    // pauseBtnの回転後の位置調整
                    [self.pauseBtn setCenter:CGPointMake(self.view.bounds.size.width/2, self.ctrlBtn.center.y + 164)];
                }
                
                break;
                
            default:
                break;
        }

    }
    else{
        NSLog(@"iPadの処理");
        switch (fromInterfaceOrientation) {
                
                // ポートレイトから回転しランドスケープになったときの処理
            case UIInterfaceOrientationPortrait:
                // nend位置調整
                [self.nadView setCenter:CGPointMake(self.view.bounds.size.width/2, self.nadView.bounds.size.height/2)];
                // ctrlBtn自身と同座標のUIImageViewの位置調整
                int adjustX = 360;
                [self.ctrlBtn setCenter:CGPointMake(adjustX, self.view.bounds.size.height/2)];
                [self.altCtrlBtnForScaleDown setCenter:self.ctrlBtn.center];
                [self.altCtrlBtnForScaleUp setCenter:self.ctrlBtn.center];
                [self.altCtrlBtnForCrashAnimation setCenter:self.ctrlBtn.center];
                [greenCircle setCenter:self.ctrlBtn.center];
                [redCircle setCenter:self.ctrlBtn.center];
                
                // pauseBtnの回転後の位置調整
                [self.pauseBtn setCenter:CGPointMake(self.ctrlBtn.center.x + 380,self.view.bounds.size.height/2 )];
                break;
                
                
                // ランドスケープから回転しポートレイトになったときの処理
            case UIInterfaceOrientationLandscapeLeft:
            case UIInterfaceOrientationLandscapeRight:
                // nend位置調整
                [self.nadView setCenter:CGPointMake(self.view.bounds.size.width/2, self.nadView.bounds.size.height/2)];
                if (!landscaped) {
                    // ctrlBtn自身と同座標のUIImageViewの位置調整
                    int adjustY = 396;
                    [self.ctrlBtn setCenter:CGPointMake(self.view.bounds.size.width/2, adjustY)];
                    [self.altCtrlBtnForScaleDown setCenter:self.ctrlBtn.center];
                    [self.altCtrlBtnForScaleUp setCenter:self.ctrlBtn.center];
                    [self.altCtrlBtnForCrashAnimation setCenter:self.ctrlBtn.center];
                    [greenCircle setCenter:self.ctrlBtn.center];
                    [redCircle setCenter:self.ctrlBtn.center];
                    // pauseBtnの回転後の位置調整
                    [self.pauseBtn setCenter:CGPointMake(self.view.bounds.size.width/2, self.ctrlBtn.center.y + 340)]; // ストーリーボード上でのctrlBtn.centerからの距離
                }
                
                break;
                
            default:
                break;
        }

    }
    
    
}



#pragma mark -
#pragma mark AdMobDelegate
// AdMobバナーのloadrequestが失敗したとき
-(void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error{
    NSLog(@"adView:didFailToReceiveAdWithError:%@", [error localizedDescription]);
    
    // 他の広告ネットワークの広告を表示させるなど。
}

/// AdMobインタースティシャルのloadrequestが失敗したとき
-(void)interstitial:(GADInterstitial *)interstitial didFailToReceiveAdWithError:(GADRequestError *)error{
    NSLog(@"interstitial:didFailToReceiveAdWithError:%@", [error localizedDescription]);
    
    // 他の広告ネットワークの広告を表示させるなど。
    // フラグ更新
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:@"KEY_ADMOBinterstitialRecieved"];
    [defaults synchronize];
    
}

// AdMobのインタースティシャル広告表示
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
    // フラグ更新
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"KEY_ADMOBinterstitialRecieved"];
    [defaults synchronize];
    NSLog(@"adfrag:%d",[defaults boolForKey:@"KEY_ADMOBinterstitialRecieved"]);
}

// AdMobインタースティシャルの再ロード
- (void)interstitialLoad{
    // 【Ad】インタースティシャル広告の表示
    interstitial_ = [[GADInterstitial alloc] init];
    interstitial_.adUnitID = MY_INTERSTITIAL_UNIT_ID;
    interstitial_.delegate = self;
    [interstitial_ loadRequest:[GADRequest request]];
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
@end