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
    AVAudioPlayer *_rollPlayer_tmp;
    AVAudioPlayer *_rollPlayer_alt;
    AVAudioPlayer *_crashPlayer;
    
    // タイマー
    NSTimer *_playTimer; // オーディオコントロール用
    NSTimer *_circleAnimationTimer; // サークルアニメーションコントロール用
    
    // プレイヤーのdurationを格納
    int duration; // オーディオコントロール用
    
    // 【アニメーション】ロール再生中のコマを入れる配列
    NSArray *animationSeq;
    
    // 【アニメーション】円を描画用のUIImageview
    UIImageView *imgViewCircle;
    UIImageView *imgViewCircle_small;
    

    
    // 【debug】ループ回数確認用
    int i;
    int p;

}

@property (weak, nonatomic) IBOutlet UIButton *ctrlBtn;
- (IBAction)ctrlBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *startStopBtn;
- (IBAction)startStopBtn:(UIButton *)sender;


// _playTimerから呼び出す:プレイヤーの交換、フェードイン・アウトをコントロール
- (void)playerControll;

// 最初にロールを再生するメソッド
- (void)playRoll;
// クラッシュを再生するメソッド
- (void)playCrash;

// ロールをループさせるために別のPlayerを再生するメソッド
- (void)startAltPlayer:(AVAudioPlayer *)player :(float)startTime;

// 2つのロールプレイヤーをクロスフェードさせるメソッド
- (void)crossFadePlayer:(AVAudioPlayer *)tmpPlayer :(AVAudioPlayer *)altPlayer;

// プレイヤーの再生を止めるメソッド
- (void)stopPlayer:(AVAudioPlayer *)player;
@end

@implementation ViewController
// _playTimerから呼び出す:プレイヤーの交換、フェードイン・アウトをコントロール
- (void)playerControll{
    // debugログを出力
    ++p;
    NSLog(@"%d回目:playerControll", p);
    NSLog(@"duration:%d",(int)duration);
    
    // playerの開始位置を以下で　2.0にしているためdurfation -3 にしないと、pleyerが再生完了してしまう
    
    if (_rollPlayer_tmp.playing) {
        [self startAltPlayer:_rollPlayer_alt :2.0];
        NSLog(@"クロスフェード");
        NSLog(@"alt start!!");
        // クロスフェード処理
        while ((int)_rollPlayer_alt.volume !=1) {
            [self crossFadePlayer:_rollPlayer_tmp :_rollPlayer_alt];
        }
        NSLog(@"プレイヤーの停止とフラグの更新");
        // プレイヤーを止める。フラグを更新
        [self stopPlayer:_rollPlayer_tmp];
        NSLog(@"_rollPlayer_tmp 止まったお");
    } else if(_rollPlayer_alt.playing) {
        [self startAltPlayer:_rollPlayer_tmp :2.0];
        NSLog(@"クロスフェード");
        NSLog(@"tmp start!!");
        // クロスフェード処理
        while ((int)_rollPlayer_tmp.volume !=1) {
            [self crossFadePlayer:_rollPlayer_alt :_rollPlayer_tmp];
        }
        NSLog(@"プレイヤーの停止とフラグの更新");
        // プレイヤーを止める。フラグを更新
        [self stopPlayer:_rollPlayer_alt];
        NSLog(@"_rollPlayer_alt 止まったお");
    }
}

// 最初にロールを再生するメソッドを実装
- (void)playRoll{
    NSLog(@"playRoll!");
    // 再生位置を最初に設定
    _rollPlayer_tmp.currentTime = 0.0;
    // スネアスプラッシュを停止し最初まで戻す
    [_crashPlayer stop];
    _crashPlayer.currentTime = 0.0;
    
    // ドラムロールを再生する
    _rollPlayer_tmp.volume = 1.0;
    [_rollPlayer_tmp play];
    
    // alt.volumeを0に設定
    _rollPlayer_alt.volume = 0.0;
    
    // playerControllを1.0秒間隔で呼び出すタイマーを作る
    _playTimer = [NSTimer scheduledTimerWithTimeInterval:(duration - 3)
                                                  target:self
                                                selector:@selector(playerControll)
                                                userInfo:nil
                                                 repeats:YES];
    
    // 【アニメーション】ロールのアニメーションを再生する
    [self.ctrlBtn.imageView startAnimating];
    // サークルアニメーションタイマーを破棄する
    [_circleAnimationTimer invalidate];
    // アニメーションが再生されるまでボタンを無効化
    [self.ctrlBtn setEnabled:0];
    
    // ボタンをデフォルトの画像に戻す
    [self.startStopBtn setImage:[UIImage imageNamed:@"pause_v07.png"] forState:UIControlStateDisabled]; // startstopbtnがdisableのときに色を薄くしない

}

// クラッシュを再生するメソッドを実装
-(void)playCrash{
    // ループしているドラムロールを止める
    [_rollPlayer_tmp stop];
    _rollPlayer_tmp.currentTime = 0.0;
    [_rollPlayer_alt stop];
    _rollPlayer_alt.currentTime = 0.0;
    
    // クラッシュを再生する
    [_crashPlayer play];
    // プレイヤータイマーを破棄する
    [_playTimer invalidate];
    
    // 【アニメーション】ロールのアニメーションを停止する
    [self.ctrlBtn.imageView stopAnimating];
    
    // アニメーションタイマーを破棄する
    [_circleAnimationTimer invalidate];
    // アニメーションが再生されるまでボタンを無効化
    [self.ctrlBtn setEnabled:0];
    // ボタンをデフォルトの画像に戻す
    [self.ctrlBtn setImage:[UIImage imageNamed:@"default_v07.png"] forState:UIControlStateDisabled]; // ctrlBtnがdisableのときに色を薄くしない
    

    //debug用ログを出力
    NSLog(@"splash!-------------------------------------");
    NSLog(@"タイマー破棄");
    NSLog(@"--------------------------------------------");
    
}

// ロールをループさせるためにaltPlayerを再生しクロスフェード管理用フラグをアクティブにするメソッドを実装
- (void)startAltPlayer:(AVAudioPlayer *)player :(float)startTime{
    // debug用変数
    ++i;
    // debug用ログを出力
    NSLog(@"----------------------");
    NSLog(@"%d回目:交換用Player再生開始", i);
    
    // altPlayerのボリュームと開始位置を設定し再生
    player.volume = 0.2;
    player.currentTime = startTime;
    [player play];
    
    //クロスフェード管理フラグをアクティブに変更
    NSLog(@"rollPlayer_tmp.volume %f", _rollPlayer_tmp.volume);
    NSLog(@"rollPlayer_alt.volume %f", _rollPlayer_alt.volume);
}

// 2つのロールプレイヤーをクロスフェードさせるメソッド
- (void)crossFadePlayer:(AVAudioPlayer *)tmpPlayer :(AVAudioPlayer *)altPlayer{
    // tmpPlayerとaltPlayerのボリュームを0.1ずつ上げ下げ
    tmpPlayer.volume = tmpPlayer.volume - 0.1;
    altPlayer.volume = altPlayer.volume + 0.1;
/*
    // debug用ログを出力
    NSLog(@"rollPlayer_tmp.volume %f", _rollPlayer_tmp.volume);
    NSLog(@"rollPlayer_alt.volume %f", _rollPlayer_alt.volume);
*/
}

// プレイヤーの再生を止めてクロスフェード管理用フラグを非アクティブにするメソッド
- (void)stopPlayer:(AVAudioPlayer *)player{
    // playerをストップしplayer.currentTimeを0.0に戻す
    [player stop];
    player.currentTime = 0.0;
    
    // debug用ログを出力
    NSLog(@"[stopPlayer]--------------------------------");
    NSLog(@"rollPlayer_tmp.volume %f", _rollPlayer_tmp.volume);
    NSLog(@"rollPlayer_alt.volume %f", _rollPlayer_alt.volume);
    NSLog(@"_rollPlayer_tmp.playing:%d _rollPlayer_alt.playing:%d", _rollPlayer_tmp.playing, _rollPlayer_alt.playing);
    NSLog(@"--------------------------------------------");
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
    _rollPlayer_tmp = [[AVAudioPlayer alloc] initWithContentsOfURL:url_roll error:NULL];
    
    // ロールalt
    _rollPlayer_alt = [[AVAudioPlayer alloc] initWithContentsOfURL:url_roll error:NULL];
    
    
    // クラッシュ
    NSString *path_clash = [[NSBundle mainBundle] pathForResource:@"crash" ofType:@"aif"];
    NSURL *url_clash = [NSURL fileURLWithPath:path_clash];
    _crashPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url_clash error:NULL];
    
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

// 円を描画するメソッド
-(UIImage *)imageFillEllipseInRect:(UIColor *)color size:(CGSize)size lineWidth:(CGFloat)lineWidth{
    
    UIImage *img = nil;
    CGRect rect;
    
    
    // ビットマップ形式のコンテキストの生成
    UIGraphicsBeginImageContextWithOptions(size, NO, 0); // (scale)は 0 を指定することで使用デバイスに適した倍率が自動的に採用される
    
    // 現在のコンテキストを取得する
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    rect = CGRectMake(lineWidth, lineWidth, (int)(size.width - 2*lineWidth), (int)(size.height - 2*lineWidth));

    // 線の太さを決める
    CGContextSetLineWidth(context, lineWidth);
    
    // 円を描画する
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextStrokeEllipseInRect(context, rect);
    
    // 現在のグラフィックコンテクストの内容を取得する
    img = UIGraphicsGetImageFromCurrentImageContext();

    /*
    CGContextSetRGBStrokeColor(context, 0, 0, 1, 1);
    CGContextStrokeEllipseInRect(context, CGRectMake(200, 200, 250, 250));
     */
    
    // 現在のグラフィックコンテクストの編集を終了する
    UIGraphicsEndImageContext();
    
    return img;
}

// 円の1.25倍拡大アニメーション
-(void)circleAnimationZoomIn{
    // transform初期化
    imgViewCircle.transform = CGAffineTransformIdentity;
    self.ctrlBtn.imageView.transform = CGAffineTransformIdentity;
    // アルファ値初期化
    imgViewCircle.alpha = 1;

    CGAffineTransform t1 = CGAffineTransformMakeScale(0.98, 0.98);
    CGAffineTransform t2 = CGAffineTransformMakeScale(1.25, 1.25);

    // 【アニメーション】ロール再生ボタンが押されるまで緑のサークルの拡大、alpha減少を繰り返す
    [UIView animateWithDuration:1.25f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.ctrlBtn.imageView.transform = t1;
                         imgViewCircle.hidden = 0;
                         imgViewCircle.alpha = 0;
                         imgViewCircle.transform = t2;
                     } completion:nil];
    
}

// 0.9倍への縮小アニメーション
-(void)circleAnimationZoomOut{
    // transform初期化
    imgViewCircle.transform = CGAffineTransformIdentity;
    self.ctrlBtn.imageView.transform = CGAffineTransformIdentity;
    // アルファ値初期化
    imgViewCircle.alpha = 1;
    
    CGAffineTransform t1 = CGAffineTransformMakeScale(1.05, 1.05);
    CGAffineTransform t2 = CGAffineTransformMakeScale(0.9, 0.9);
    // 【アニメーション】クラッシュ再生ボタンが押されるまで赤のサークルの縮小、alpha減少を繰り返す
    [UIView animateWithDuration:0.3f // ロールアニメーションが1.5秒
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.ctrlBtn.imageView.transform = t1;
                         imgViewCircle.hidden = 0;
                         imgViewCircle.alpha = 0;
                         imgViewCircle.transform = t2;

                     } completion:nil];
    // アニメーションが再生されるまでボタンを無効化
    [self.ctrlBtn setEnabled:1];
    [self.startStopBtn setEnabled:1];
    
}

// 1倍の円から2倍への拡大アニメーション
-(void)circleAnimationFinish{
    // transform初期化
    imgViewCircle.transform = CGAffineTransformIdentity;
    imgViewCircle_small.transform = CGAffineTransformIdentity;
    self.ctrlBtn.imageView.transform = CGAffineTransformIdentity;
    // アルファ値初期化
    imgViewCircle.alpha = 1;
    imgViewCircle_small.alpha = 1;
    
    CGAffineTransform t1 = CGAffineTransformMakeScale(0.5, 0.5);
    CGAffineTransform t2 = CGAffineTransformMakeScale(2, 2);

    // 【アニメーション】赤のサークルの拡大、alpha減少
    [UIView animateWithDuration:0.17f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.ctrlBtn.imageView.transform = t1;
                         
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.17f
                                               delay:0.0f
                                             options:UIViewAnimationOptionCurveEaseInOut
                                          animations:^{
                                              imgViewCircle.hidden = 0;
                                              imgViewCircle.alpha = 0;
                                              imgViewCircle.transform = t2;
                                              
                                              imgViewCircle_small.hidden = 0;
                                              imgViewCircle_small.alpha = 0;
                                              imgViewCircle_small.transform = t2;
                                              
                                          }
                                          completion:^(BOOL finished){
                                              imgViewCircle.transform = CGAffineTransformIdentity;
                                              imgViewCircle_small.transform = CGAffineTransformIdentity;
                                              self.ctrlBtn.imageView.transform = CGAffineTransformIdentity;
                                              [self viewDidAppear:1];
                                                  [self.ctrlBtn setEnabled:1];
                                          }];
                     }];

}

// pauseBtnの出現アニメーション
- (void)pauseBtnAnimation_appear{
    self.startStopBtn.imageView.alpha = 0;
    self.startStopBtn.hidden = 0;
    self.startStopBtn.imageView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    CGAffineTransform t1 = CGAffineTransformMakeRotation(M_PI/2.0f);
    CGAffineTransform t2 = CGAffineTransformRotate(t1, M_PI/2.0f);
    CGAffineTransform t3 = CGAffineTransformRotate(t2, M_PI/2.0f);
    CGAffineTransform t4 = CGAffineTransformRotate(t3, M_PI/2.0f);
    CGAffineTransform t5 = CGAffineTransformMakeScale(1.25, 1.25);
    CGAffineTransform t6 = CGAffineTransformScale(t5, 1.25, 1.25);
    CGAffineTransform t7 = CGAffineTransformScale(t6, 1.25, 1.25);
    CGAffineTransform t8 = CGAffineTransformScale(t7, 1.25, 1.25);


    
    [UIView animateWithDuration:0.12f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.startStopBtn.imageView.alpha = 0.5;
                         self.startStopBtn.imageView.transform =  CGAffineTransformConcat(t1, t5);
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.12f
                                               delay:0.0f
                                             options:UIViewAnimationOptionCurveLinear
                                          animations:^{
                                              self.startStopBtn.imageView.alpha = 1;
                                              self.startStopBtn.imageView.transform =  CGAffineTransformConcat(t2, t6);
                                          }
                                          completion:^(BOOL finished){
                                              [UIView animateWithDuration:0.12f
                                                                    delay:0.0f
                                                                  options:UIViewAnimationOptionCurveLinear
                                                               animations:^{
                                                                   self.startStopBtn.imageView.alpha = 1;
                                                                   self.startStopBtn.imageView.transform =  CGAffineTransformConcat(t3, t7);
                                                               }
                                                               completion:^(BOOL finished){
                                                                   [UIView animateWithDuration:0.12f
                                                                                         delay:0.0f
                                                                                       options:UIViewAnimationOptionCurveEaseOut
                                                                                    animations:^{
                                                                                        self.startStopBtn.imageView.alpha = 1;
                                                                                        self.startStopBtn.imageView.transform =  CGAffineTransformConcat(t4, t8);
                                                                     
                                                                                    }
                                                                                    completion:nil];
                                                                   
                                                               }];
                                              
                                          }];
                     }];
}

// startStopBtnをhiddenかつ無効にする
-(void)btnToHiddenDisable:(UIButton *)btn{
    btn.hidden = 1;
    [btn setEnabled:0];
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

    // アニメーションする円の素材を描画する
    // 円の描画サイズを設定
    CGSize size = CGSizeMake(256, 256); // 256 + 16
    // ストロークカラーを緑に設定
    UIColor *color = [UIColor greenColor];
    // ストロークの太さを設定
    CGFloat lineWidth = 2.0f;
    // 円のイメージでUIImageview imgViewCircleを初期化
    imgViewCircle =[[UIImageView alloc]initWithImage:[self imageFillEllipseInRect:color size:size lineWidth:lineWidth]];
    // imgViewCircleのセンターをctrlBtn.centerと合わせる
    [imgViewCircle setCenter:self.ctrlBtn.center];
    // imgViewCircleをアニメーション開始までhiddenにする
    imgViewCircle.hidden = 1;
    // ビューにimgViewCircleを描画
    [self.view addSubview:imgViewCircle];

/*
    // イメージビューの外枠を描画
    imgViewCircle.layer.borderColor = [UIColor blackColor].CGColor;
    imgViewCircle.layer.borderWidth = 1.0f;
*/

    
    // タイマーを破棄する
    [_circleAnimationTimer invalidate];
    
    // 【アニメーション】円の拡大アニメーションを2.0秒間隔で呼び出すタイマーを作る
    _circleAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:2.0f
                                                  target:self
                                                selector:@selector(circleAnimationZoomIn)
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
    
    // ドラムロールの再生
    if (_rollPlayer_tmp.playing || _rollPlayer_alt.playing) {
        // ドラムロールが再生中にctrlBtnが押されたとき

        // ドラムロールを止めcrash再生
        [self playCrash];
        
        // アニメーションする円の素材を描画する
        // 円の描画サイズを設定
        CGSize size = CGSizeMake(256, 256); // 256 + 16
        // ストロークカラーを赤に設定
        UIColor *color = [UIColor redColor];
        // ストロークの太さを設定
        CGFloat lineWidth = 2.0f;
        // 円のイメージでUIImageview imgViewCircleを初期化
        imgViewCircle =[[UIImageView alloc]initWithImage:[self imageFillEllipseInRect:color size:size lineWidth:lineWidth]];
        // イメージビューのセンターをctrlBtn.centerと合わせる
        [imgViewCircle setCenter:self.ctrlBtn.center];
        // imgViewCircleをアニメーション開始までhiddenにする
        imgViewCircle.hidden = 1;
        // ビューにimgViewCircleを描画
        [self.view addSubview:imgViewCircle];
   
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
        
        /*
         // イメージビューの外枠を描画
         imgViewCircle.layer.borderColor = [UIColor blackColor].CGColor;
         imgViewCircle.layer.borderWidth = 1.0f;
         */
        
        // crash再生時のアニメーション再生
        [self circleAnimationFinish];
        
        // startStopBtnをhiddenかつ無効にする
        [self btnToHiddenDisable:self.startStopBtn];
        
        // debug
        NSLog(@"Crash ctrl.Btn.state:%d",self.ctrlBtn.state);
        
    } else {
        // ドラムロールが停止中にctrlBtnが押されたとき
        // ドラムロールを再生する
        [self playRoll];
        
        // アニメーションする円の素材を描画する
        // 円の描画サイズを設定
        CGSize size = CGSizeMake(280, 280); // 256 + 16
        // ストロークカラーを赤に設定
        UIColor *color = [UIColor redColor];
        // ストロークの太さを設定
        CGFloat lineWidth = 2.0f;
        // 円のイメージでUIImageview imgViewCircleを初期化
        imgViewCircle =[[UIImageView alloc]initWithImage:[self imageFillEllipseInRect:color size:size lineWidth:lineWidth]];
        // イメージビューのセンターをctrlBtn.centerと合わせる
        [imgViewCircle setCenter:self.ctrlBtn.center];
        // imgViewCircleをアニメーション開始までhiddenにする
        imgViewCircle.hidden = 1;
        // ビューにimgViewCircleを描画
        [self.view addSubview:imgViewCircle];
/*
        // イメージビューの外枠を描画
        imgViewCircle.layer.borderColor = [UIColor blackColor].CGColor;
        imgViewCircle.layer.borderWidth = 1.0f;
*/

        // transform初期化
        imgViewCircle.transform = CGAffineTransformIdentity;
        self.ctrlBtn.imageView.transform = CGAffineTransformIdentity;
        
        // 【アニメーション】円の縮小アニメーションを0.7秒間隔で呼び出すタイマーを作る
        _circleAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:0.7f
                                                                 target:self
                                                               selector:@selector(circleAnimationZoomOut)
                                                               userInfo:nil
                                                                repeats:YES];
        // statStopBtn がhiddenのときだけ実行
        if (self.startStopBtn.hidden == 1) {
            // 【アニメーション】startStopBtnを拡大/回転しながら表示
            [self pauseBtnAnimation_appear];
        }

        
        // debug
        NSLog(@"Roll ctrl.Btn.state:%d",self.ctrlBtn.state);
        
    }

}

// ctrlBtnの下のボタンを押した時に実行される処理を実装
- (IBAction)startStopBtn:(UIButton *)sender {
    NSLog(@"startStopBtnLabel tapped!");
    if (_rollPlayer_tmp.playing || _rollPlayer_alt.playing) {
        // ドラムロールが再生中にstartStopBtnが押されたとき
        // ループしているドラムロールを止める
        [_rollPlayer_tmp stop];
        _rollPlayer_tmp.currentTime = 0.0;
        [_rollPlayer_alt stop];
        _rollPlayer_alt.currentTime = 0.0;
        
        // プレイヤータイマーを破棄する
        [_playTimer invalidate];
        
        // アニメーションタイマーを破棄する
        [_circleAnimationTimer invalidate];
        
        // 【アニメーション】ロールのアニメーションを停止する
        [self.ctrlBtn.imageView stopAnimating];
        
        
        // ctrlBtnの画像を一旦クリア
        self.ctrlBtn.imageView.image = nil; // ctrlBtnのパラパラアニメーション終わりにhighlightedの画像が表示される対策
        // ctrlBtnの画像をデフォルトの画像に設定
        self.ctrlBtn.imageView.image = [UIImage imageNamed:@"default_v07.png"];
      
        // startStopBtnをhiddenかつ無効にする
        [self btnToHiddenDisable:self.startStopBtn];
        // 初期画面を呼び出す
        [self viewDidAppear:1];
        

    } else {
        /* ドラムロールが再生されていないときはstartStopBtnはhiddenなので押されることはない
        // ドラムロールを再生する
        [self playRoll];
        
        // 【アニメーション】ロールのアニメーションを再生する
        [self.ctrlBtn.imageView startAnimating];
        
        // 円のアニメーション
        
        // タイマーを破棄する
        [_circleAnimationTimer invalidate];
        
        // 素材の描画
        // 円の描画サイズを設定
        CGSize size = CGSizeMake(280, 280); // 256 + 16
        // ストロークカラーを赤に設定
        UIColor *color = [UIColor redColor];
        // ストロークの太さを設定
        CGFloat lineWidth = 2.0f;
        // 円のイメージでUIImageview imgViewCircleを初期化
        imgViewCircle =[[UIImageView alloc]initWithImage:[self imageFillEllipseInRect:color size:size lineWidth:lineWidth]];
        // イメージビューのセンターをctrlBtn.centerと合わせる
        [imgViewCircle setCenter:self.ctrlBtn.center];
        // imgViewCircleをアニメーション開始までhiddenにする
        imgViewCircle.hidden = 1;
        // ビューにimgViewCircleを描画
        [self.view addSubview:imgViewCircle];
        

        
        // イメージビューのセンターをctrlBtn.centerと合わせる
        [imgViewCircle setCenter:self.ctrlBtn.center];
        // imgViewCircleをアニメーション開始までhiddenにする
        imgViewCircle.hidden = 1;
        // ビューにimgViewCircleを描画
        [self.view addSubview:imgViewCircle_small];
        
        
         // イメージビューの外枠を描画
         imgViewCircle.layer.borderColor = [UIColor blackColor].CGColor;
         imgViewCircle.layer.borderWidth = 1.0f;
         
        
        // 【アニメーション】円の縮小アニメーションを0.7秒間隔で呼び出すタイマーを作る
        _circleAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:0.7f
                                                                 target:self
                                                               selector:@selector(circleAnimationZoomOut)
                                                               userInfo:nil
                                                                repeats:YES];
         */
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