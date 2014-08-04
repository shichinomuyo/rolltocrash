//
//  ViewController.m
//  rollToCrash
//
//  Created by 七野祐太 on 2014/07/20.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface ViewController ()<AVAudioPlayerDelegate>
{
    // オーディオプレイヤー
    RollToCrashPlayer *_rollPlayer_tmp;
    RollToCrashPlayer *_rollPlayer_alt;
    RollToCrashPlayer *_crashPlayer;
    
    // タイマー
    NSTimer *_playTimer; // オーディオコントロール用
    NSTimer *_circleAnimationTimer; // サークルアニメーションコントロール用
    NSTimer *_btnAnimationTimer; // ボタンアニメーションコントロール用
    
    // プレイヤーのdurationを格納
    int duration; // オーディオコントロール用
    
    // 【アニメーション】ロール再生中のコマを入れる配列
    NSArray *animationSeq;
    
    // 【debug】ループ回数確認用
    int i;
    int p;

}

@property (weak, nonatomic) IBOutlet UIButton *ctrlBtn;
- (IBAction)ctrlBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *pauseBtn;
- (IBAction)pauseBtn:(UIButton *)sender;

@end

@implementation ViewController



// ctrlBtnは繰り返しアニメーションさせる必要があるため、scaleUpBtn、scaleDownBtnを別クラスに抽出することができなかった。
// ctrlBtnアニメーション　ロール停止時
- (void)scaleUpBtn{
    // transform初期化
    self.ctrlBtn.imageView.transform = CGAffineTransformIdentity;
    
    CGAffineTransform t1 = CGAffineTransformMakeScale(1.05, 1.05);
    self.ctrlBtn.imageView.transform = t1;
    
    // 【アニメーション】ロール再生ボタンが押されるまで緑のサークルの拡大、alpha減少を繰り返す
    [UIView animateWithDuration:1.0f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.ctrlBtn.imageView.transform = t1;
                     }
                     completion:nil];

}

// ctrlBtnアニメーション　ロール停止時
- (void)scaleDownBtn{
    // transform初期化
    self.ctrlBtn.imageView.transform = CGAffineTransformIdentity;
    
    CGAffineTransform t1 = CGAffineTransformMakeScale(0.98, 0.98);
    self.ctrlBtn.imageView.transform = t1;
    // 【アニメーション】ロール再生ボタンが押されるまで緑のサークルの拡大、alpha減少を繰り返す
    [UIView animateWithDuration:0.7f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.ctrlBtn.imageView.transform = t1;
                     } completion:nil];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
/*
    // 【Ad】サイズを指定してAdMobインスタンスを生成
    bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    
    // 【Ad】AdMobのパブリッシャーIDを指定
    bannerView_.adUnitID = MY_BANNER_UNIT_ID;
    
    
    // 【Ad】AdMob広告を表示するViewController(自分自身)を指定し、ビューに広告を追加
    bannerView_.rootViewController = self;
    [self.view addSubview:bannerView_];
    
    // ビューの一番下に表示
    [bannerView_ setCenter:CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height - bannerView_.bounds.size.height/2)];
    NSLog(@"self.view.bounds.size.height %.2f /n bannerView_.bounds.size.height %.2f",self.view.bounds.size.height, bannerView_.bounds.size.height);
    // 【Ad】AdMob広告データの読み込みを要求
    [bannerView_ loadRequest:[GADRequest request]];
    
    // 【Ad】インタースティシャル広告の表示
    interstitial_ = [[GADInterstitial alloc] init];
    interstitial_.adUnitID = MY_INTERSTITIAL_UNIT_ID;
    [interstitial_ loadRequest:[GADRequest request]];
    

    //NADViewの作成
    self.nadView = [[NADView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    // (3) ログ出力の指定 [self.nadView setIsOutputLog:NO];
    // (4) set apiKey, spotId.
    [self.nadView setNendID:@"139154ca4d546a7370695f0ba43c9520730f9703" spotID:@"208229"];
    [self.nadView setDelegate:self]; //(5)
    [self.nadView load]; //(6)
    [self.view addSubview:self.nadView]; // 最初から表示する場合
*/
    // debug
    NSLog(@"viewdidload ctrl.Btn.state:%d",self.ctrlBtn.state);
 
    // (audioplayer)再生する効果音のパスを取得する
    // ドラムロール
    NSString *path_roll = [[NSBundle mainBundle] pathForResource:@"roll" ofType:@"aiff"];
    NSURL *url_roll = [NSURL fileURLWithPath:path_roll];
    _rollPlayer_tmp = [[RollToCrashPlayer alloc] initWithContentsOfURL:url_roll error:NULL];
    
    // ロールalt
    _rollPlayer_alt = [[RollToCrashPlayer alloc] initWithContentsOfURL:url_roll error:NULL];
    
    
    // クラッシュ
    NSString *path_clash = [[NSBundle mainBundle] pathForResource:@"crash" ofType:@"aif"];
    NSURL *url_clash = [NSURL fileURLWithPath:path_clash];
    _crashPlayer = [[RollToCrashPlayer alloc] initWithContentsOfURL:url_clash error:NULL];
    
    // ドラムロールだけループさせるのでデリゲートに指定
    // audioPlayer を作ったあとにデリゲート指定しないと機能しない
    [_rollPlayer_tmp setDelegate:self];
    [_rollPlayer_alt setDelegate:self];
    
    // プレイヤーを準備
    [_rollPlayer_tmp prepareToPlay];
    [_rollPlayer_alt prepareToPlay];
    [_crashPlayer prepareToPlay];
    
    // tmpPlayerとaltPlayerを相互にクロスフェードさせて繰り返すための時間を条件式とするために_rollPlayer_tmop.durationを格納
    duration = _rollPlayer_tmp.duration;
    
    // デバッグ用変数初期化
    i = 0;
    p = 0;
    
    // 【アニメーション】ロール再生中の各コマのイメージを配列に入れる
    animationSeq = @[/*
                     [UIImage imageNamed:@"hit_R2.png"],
                     [UIImage imageNamed:@"hit_R1.png"],
                     [UIImage imageNamed:@"hit_R2.png"],
                     [UIImage imageNamed:@"hit_R1.png"],
                     [UIImage imageNamed:@"hit_R2.png"],
                     
                     [UIImage imageNamed:@"hit_L2.png"],
                     [UIImage imageNamed:@"hit_L1.png"],
                     [UIImage imageNamed:@"hit_L2.png"],
                     [UIImage imageNamed:@"hit_L1.png"],
                     [UIImage imageNamed:@"hit_L2.png"]
                      */

                     [UIImage imageNamed:@"hit_R2v07.png"],
                     [UIImage imageNamed:@"hit_R1v07.png"],
                     [UIImage imageNamed:@"hit_R2v07.png"],
                     [UIImage imageNamed:@"hit_R1v07.png"],
                     [UIImage imageNamed:@"hit_R2v07.png"],
                     [UIImage imageNamed:@"hit_L2v07.png"],
                     [UIImage imageNamed:@"hit_L1v07.png"],
                     [UIImage imageNamed:@"hit_L2v07.png"],
                     [UIImage imageNamed:@"hit_L1v07.png"],
                     [UIImage imageNamed:@"hit_L2v07.png"]];
    
    // ボタンのイメージビューにアニメーションの配列を設定する
    self.ctrlBtn.imageView.animationImages = animationSeq;
    // アニメーションの長さを設定する
    self.ctrlBtn.imageView.animationDuration = 1.35;
    // 無限の繰り返し回数
    self.ctrlBtn.imageView.animationRepeatCount = 0;
    self.ctrlBtn.imageView.image = [UIImage imageNamed:@"default_v07.png"];
    

    
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
    // ctrlBtn.image をdefault_v07.pngに設定
    [self.ctrlBtn setImage:[UIImage imageNamed:@"default_v07.png"] forState:UIControlStateNormal];

    
    // ストロークカラーを緑に設定
    UIColor *color = [UIColor greenColor];
    // ストロークの太さを設定
    CGFloat lineWidth = 2.0f;
    // 半径を設定
    CGFloat radius = 250;
    // インスタンスを差k性
    ImageViewCircle *greenCircle = [[ImageViewCircle alloc] initWithFrame:CGRectMake(0, 0, radius, radius) withColor:color withLineWidth:lineWidth];
    [greenCircle setImage:[greenCircle imageFillEllipseInRect]];
    
    // イメージビューのセンターをctrlAudioPlayerBtn.centerと合わせる
    [greenCircle setCenter:self.ctrlBtn.center];
    // ImageViewCircleをアニメーション開始までhiddenにする
    greenCircle.hidden = 1;
    // ビューにimgViewCircleを描画
    [self.view addSubview:greenCircle];
    
    

/*
    // イメージビューの外枠を描画
    imgViewCircle.layer.borderColor = [UIColor blackColor].CGColor;
    imgViewCircle.layer.borderWidth = 1.0f;
*/

    
    // タイマーを破棄する
    [_circleAnimationTimer invalidate];
    [_btnAnimationTimer invalidate];
    
    // 【アニメーション】円の拡大アニメーションを2.0秒間隔で呼び出すタイマーを作る

    _circleAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:2.0f
                                                             target:greenCircle
                                                           selector:@selector(scaleUpAnimation)
                                                           userInfo:nil
                                                            repeats:YES];
    
    _btnAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:2.0f
                                                          target:self
                                                        selector:@selector(scaleUpBtn)
                                                        userInfo:nil
                                                         repeats:YES];


}

- (void)dealloc{
    [self.nadView setDelegate:nil];//delegateにnilをセット
    self.nadView = nil; // プロパティ経由でrelease,nilをセット
    
    // [super dealloc]; // MRC(非アーク時には必要)
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// ボタンを押したときに実行される処理を実装
- (IBAction)ctrlBtn:(UIButton *)sender {
    
    // ドラムロールの再生 or クラッシュの再生
    if (_rollPlayer_tmp.playing || _rollPlayer_alt.playing) {
        // ドラムロールが再生中にctrlBtnが押されたとき
        
        // 【アニメーション】ロールのアニメーションを停止する
        [self.ctrlBtn.imageView stopAnimating];
        // ドラムロールを止めcrash再生
        [_crashPlayer playCrashStopRolls:_rollPlayer_tmp :_rollPlayer_alt];

        // プレイヤータイマーを破棄する
        [_playTimer invalidate];
        // アニメーションタイマーを破棄する
        [_circleAnimationTimer invalidate];
        [_btnAnimationTimer invalidate];
        // アニメーションが再生されるまでボタンを無効化
        [self.ctrlBtn setEnabled:0];
        // ボタンをデフォルトの画像に戻す
        [self.ctrlBtn setImage:[UIImage imageNamed:@"default_v07.png"] forState:UIControlStateDisabled]; // ctrlBtnがdisableのときに色を薄くしない
        
        // ストロークカラーを赤に設定
        UIColor *color = [UIColor redColor];
        // ストロークの太さを設定
        CGFloat lineWidth = 3.0f;
        // 半径を設定
        CGFloat radius = 256;
        // インスタンスを差k性
        ImageViewCircle *lastCircle = [[ImageViewCircle alloc] initWithFrame:CGRectMake(0, 0, radius, radius) withColor:color withLineWidth:lineWidth];
        [lastCircle setImage:[lastCircle imageFillEllipseInRect]];
        
        // イメージビューのセンターをctrlAudioPlayerBtn.centerと合わせる
        [lastCircle setCenter:self.ctrlBtn.center];
        // ImageViewCircleをアニメーション開始までhiddenにする
        lastCircle.hidden = 1;
        // ビューにimgViewCircleを描画
        [self.view addSubview:lastCircle];
   /*
        // 小さい円の描画サイズを設定
        CGSize size_small = CGSizeMake(240, 240); // 256 + 16
        // ストロークカラーを赤に設定
        UIColor *color_small = [UIColor redColor];
        // ストロークの太さを設定
        CGFloat lineWidth_small = 1.5f;
        // 円のイメージでUIImageview imgViewCircleを初期化
        imgViewCircle_small =[[UIImageView alloc]initWithImage:[self imageFillEllipseInRect:color_small size:size_small lineWidth:lineWidth_small]];
        // イメージビューのセンターをctrlBtn.centerと合わせる
        [imgViewCircle_small setCenter:self.ctrlBtn.center];
        // imgViewCircleをアニメーション開始までhiddenにする
        imgViewCircle_small.hidden = 1;
        // ビューにimgViewCircleを描画
        [self.view addSubview:imgViewCircle_small];
    */
        
        /*
         // イメージビューの外枠を描画
         imgViewCircle.layer.borderColor = [UIColor blackColor].CGColor;
         imgViewCircle.layer.borderWidth = 1.0f;
         */
        
        // crash再生時のアニメーション再生
        [lastCircle circleAnimationFinish:0.17 secondDuration:0.17];
        
        // pauseBtnをhiddenかつ無効にする
        [UIButtonAnimation btnToHiddenDisable:self.pauseBtn];
        
        // ctrlBtnを有効にする
        [self.ctrlBtn setEnabled:1];

            [self viewDidAppear:1];

        // debug
        NSLog(@"Crash ctrl.Btn.state:%d",self.ctrlBtn.state);
        
    } else {
        // ドラムロールが停止中にctrlBtnが押されたとき
        NSDictionary *dictionary =[NSDictionary dictionaryWithObjectsAndKeys:
                                   @"_rollPlayer_tmp",      @"_rollPlayer_alt",nil];
        // ドラムロールを再生する
        [_rollPlayer_tmp playRollStopCrash:_crashPlayer setVolumeZero:_rollPlayer_alt ];
        // playerControllを1.0秒間隔で呼び出すタイマーを作る
        _playTimer = [NSTimer scheduledTimerWithTimeInterval:(duration - 3)
                                                      target:_rollPlayer_tmp
                                                    selector:@selector(playerControll: :)
                                                    userInfo:dictionary
                                                     repeats:YES];
        // 【アニメーション】ロールのアニメーションを再生する
        [self.ctrlBtn.imageView startAnimating];
        // サークルアニメーションタイマーを破棄する
        [_circleAnimationTimer invalidate];
        [_btnAnimationTimer invalidate];
        
        // アニメーションが再生されるまでボタンを無効化
        [self.ctrlBtn setEnabled:0];
        
        // ボタンをデフォルトの画像に戻す
        [self.pauseBtn setImage:[UIImage imageNamed:@"pause_v07.png"] forState:UIControlStateDisabled]; // pauseBtnがdisableのときに色を薄くしない
        
        // ストロークカラーを赤に設定
        UIColor *color = [UIColor redColor];
        // ストロークの太さを設定
        CGFloat lineWidth = 2.0f;
        // 半径を設定
        CGFloat radius = 280;
        // インスタンスを差k性
        ImageViewCircle *redCircle = [[ImageViewCircle alloc] initWithFrame:CGRectMake(0, 0, radius, radius) withColor:color withLineWidth:lineWidth];
        [redCircle setImage:[redCircle imageFillEllipseInRect]];
        
        // イメージビューのセンターをctrlAudioPlayerBtn.centerと合わせる
        [redCircle setCenter:self.ctrlBtn.center];
        // ImageViewCircleをアニメーション開始までhiddenにする
        redCircle.hidden = 1;
        // ビューにimgViewCircleを描画
        [self.view addSubview:redCircle];
/*
        // イメージビューの外枠を描画
        imgViewCircle.layer.borderColor = [UIColor blackColor].CGColor;
        imgViewCircle.layer.borderWidth = 1.0f;
*/

        // transform初期化
        self.ctrlBtn.imageView.transform = CGAffineTransformIdentity;
        
        // 【アニメーション】円の縮小アニメーションを0.7秒間隔で呼び出すタイマーを作る
        _circleAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:0.7f
                                                                 target:redCircle
                                                               selector:@selector(scaleDownAnimation)
                                                               userInfo:nil
                                                                repeats:YES];
        _btnAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:0.7f
                                                                 target:self
                                                               selector:@selector(scaleDownBtn)
                                                               userInfo:nil
                                                                repeats:YES];
        // statStopBtn がhiddenのときだけ実行
        if (self.pauseBtn.hidden == 1) {
            // 【アニメーション】pauseBtnを拡大/回転しながら表示
            [UIButtonAnimation appearWithRotate:self.pauseBtn];
            [self.ctrlBtn setEnabled:1];
        }

        
        // debug
        NSLog(@"Roll ctrl.Btn.state:%d",self.ctrlBtn.state);
        
    }

}

// ctrlBtnの下のボタンを押した時に実行される処理を実装
- (IBAction)pauseBtn:(UIButton *)sender {
    NSLog(@"pauseBtnLabel tapped!");
    if (_rollPlayer_tmp.playing || _rollPlayer_alt.playing) {
        // ドラムロールが再生中にpauseBtnが押されたとき
        // ループしているドラムロールを止める
        [_rollPlayer_tmp stop];
        _rollPlayer_tmp.currentTime = 0.0;
        [_rollPlayer_alt stop];
        _rollPlayer_alt.currentTime = 0.0;
        
        // プレイヤータイマーを破棄する
        [_playTimer invalidate];
        
        // アニメーションタイマーを破棄する
        [_circleAnimationTimer invalidate];
        [_btnAnimationTimer invalidate];
        
        // 【アニメーション】ロールのアニメーションを停止する
        [self.ctrlBtn.imageView stopAnimating];
        
        
        // ctrlBtnの画像を一旦クリア
        self.ctrlBtn.imageView.image = nil; // ctrlBtnのパラパラアニメーション終わりにhighlightedの画像が表示される対策
        // ctrlBtnの画像をデフォルトの画像に設定
        self.ctrlBtn.imageView.image = [UIImage imageNamed:@"default_v07.png"];
        
        //pauseBtnの消失アニメーション
        
        // pauseBtnをhiddenかつ無効にする
        [UIButtonAnimation btnToHiddenDisable:self.pauseBtn];
        // 初期画面を呼び出す
        [self viewDidAppear:1];
        

    } else {
            }
}

// AdMobのloadrequestが失敗したとき
-(void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error{
    NSLog(@"adView:didFailToReceiveAdWithError:%@", [error localizedDescription]);
    
    // 他の広告ネットワークの広告を表示させるなど。
}

/// AdMobインタースティシャルのloadrequestが失敗したとき
-(void)interstitial:(GADInterstitial *)interstitial didFailToReceiveAdWithError:(GADRequestError *)error{
    NSLog(@"interstitial:didFailToReceiveAdWithError:%@", [error localizedDescription]);
    
    // 他の広告ネットワークの広告を表示させるなど。
}

@end