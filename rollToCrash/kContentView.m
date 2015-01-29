//
//  kPageView.m
//  rollToCrash
//
//  Created by 七野祐太 on 2015/01/23.
//  Copyright (c) 2015年 shichino yuta. All rights reserved.
//

#import "kContentView.h"

@implementation kContentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id) initWithCoder:(NSCoder*)coder {
    NSLog(@"initwithcoder");
    self = [super initWithCoder:coder];
    if(self) {
        if (!self.subviews.count) {
            NSLog(@"coder");
            [self _init];
        }
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // initialization code
    }
    return self;
}

-(void)_init{
    NSLog(@"_init");
    NSString *className = NSStringFromClass([self class]);
    [[NSBundle mainBundle] loadNibNamed:className owner:self options:nil];
//    NSLog(@"className:%@",className);
    // ロードしたViewのframeをSuperviewのサイズと合わせる
    __contentView.frame = self.bounds;
    NSLog(@"contentView.frame:%.2f,%.2f",__contentView.frame.size.width,__contentView.frame.size.height);
    // Superviewのサイズが変わった時に一緒に引き伸ばされれるように設定。
    // 以下は明示的に設定しなくてもデフォルトでそうなっているが念のため。
    // こういう場合は、Visual Format Languageを使うよりAutoresizingMaskを使ったほうが手軽。
    __contentView.translatesAutoresizingMaskIntoConstraints = YES;
    __contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    // ドラムのtopとsuperViewのbottomの距離をスクリーンサイズにより調整
    CGRect rect = [[UIScreen mainScreen]bounds];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        NSLog(@"iPhoneの処理");
        if (rect.size.height <= 568) {
            // heights
            // 4s 480
            // 5/5s 568
            self.constraintVerticalSpaceBFVtoSuperView.constant = 108.0;
            
            if (rect.size.height <= 480) {
                NSLog(@"4s");
                self.constraintVerticalSpaceBFVtoSuperView.constant = 98.0;
                [_bugFixContainerViewForPuseBtn setHidden:1];
                [_pauseBtn setHidden:1];
                self.constraintVerticalSpaceBFVPauseBtntoSuperView.constant = 320;
            }
            NSLog(@"AdjustConstraint");
        } else if (rect.size.height <= 736){
            // heights
            // 6 667
            // 6Plus 736
            self.constraintVerticalSpaceBFVtoSuperView.constant = 160.0;
            self.constraintVerticalSpaceBFVPauseBtntoSuperView.constant = 420;

            
        }
    }
    else{
        NSLog(@"iPadの処理");
        // heights
        // iPad2/iPad Air/iPad Retina 1024
        // storyBoard上で212に設定
        self.constraintVerticalSpaceBFVtoSuperView.constant = 216.0;
        self.constraintVerticalSpaceBFVPauseBtntoSuperView.constant = 680;
    }

    _greenCircle = nil;
    _redCircle = nil;

    [self addSubview:__contentView];

        NSLog(@"bfcvPause.frame:%.2f,%.2f,%.2f,%.2f",_bugFixContainerViewForPuseBtn.frame.origin.x,_bugFixContainerViewForPuseBtn.frame.origin.y,_bugFixContainerViewForPuseBtn.frame.size.width,_bugFixContainerViewForPuseBtn.frame.size.height);
    
}

+ (instancetype)view
{
    NSString *className = NSStringFromClass([self class]);
    return [[[NSBundle mainBundle] loadNibNamed:className owner:nil options:0] firstObject];
}

- (void)setImages:(NSArray *)imageNames soundName:(NSString *)soundName capcion:(NSString *)caption{
    NSLog(@"setImages soundName caption");
    // (audioplayer)再生する効果音のパスを取得しインスタンス生成
    [self initializeAVAudioPlayers:soundName];
    { // UIButtonに画像配列を設定
        NSString *imageNameDefault = imageNames[0];
        _imageBtnDefault =  [UIImage imageNamed:imageNameDefault];
        [self.ctrlBtn setImage:_imageBtnDefault forState:UIControlStateNormal];
        [self.ctrlBtn setImage:_imageBtnDefault forState:UIControlStateHighlighted];
        [self.ctrlBtn setImage:_imageBtnDefault forState:UIControlStateDisabled];
  
        // 【アニメーション】ロール再生中の各コマのイメージを配列に入れる
        animationSeq = @[[UIImage imageNamed:imageNames[4]],
                         [UIImage imageNamed:imageNames[3]],
                         [UIImage imageNamed:imageNames[4]],
    
                         [UIImage imageNamed:imageNames[2]],
                         [UIImage imageNamed:imageNames[1]],
                         [UIImage imageNamed:imageNames[2]]
                         ];
    NSLog(@"imageNames[0]:%@",imageNames[0]);
    NSLog(@"ctlrBtn.image%@",_ctrlBtn.imageView.image.images[0]);
    // ボタンのイメージビューにアニメーションの配列を設定する
    self.ctrlBtn.imageView.animationImages = animationSeq;
    // アニメーションの長さを設定する
    self.ctrlBtn.imageView.animationDuration = 1.2;//1.35
    // 無限の繰り返し回数
    self.ctrlBtn.imageView.animationRepeatCount = 0;
    }
    
    { // キャプション設定
        self.labelCaption.text = caption;
    }

    // ctrlBtnを起動時だけ回転拡大で出現するために隠す
    [self.ctrlBtn setAlpha:0];
    [self.ctrlBtn setHidden:1];
    [self.ctrlBtn setEnabled:1];
    [self.altCtrlBtnForCrashAnimation setHidden:1];
    
    // pauseBtnがdisableのときに色を薄くしないために画像設定
    [self.pauseBtn setHidden:1];

    NSLog(@"bfcvPause.frame:%.2f,%.2f,%.2f,%.2f",_bugFixContainerViewForPuseBtn.frame.origin.x,_bugFixContainerViewForPuseBtn.frame.origin.y,_bugFixContainerViewForPuseBtn.frame.size.width,_bugFixContainerViewForPuseBtn.frame.size.height);
    
    // 最初の１回だけ
    if (self.altCtrlBtnForScaleUp.hidden == YES) {
        [self.altCtrlBtnForScaleUp appearEmeraldWithScaleUp:_imageBtnDefault completion:^{
            NSLog(@"completionBlock");
            [_ctrlBtn appearAfterInterval:nil];
           
            [self greenRippleSetUp];

           
            [self ctrlBtnGrennRippleAnimationStart];
        }]; // 0.4sec
        
    }
    
    
}


- (void)initializeAVAudioPlayers:(NSString *)soundName{
    // (audioplayer)再生する効果音のパスを取得する
    // ロールtmp
    NSString *path_roll = [[NSBundle mainBundle] pathForResource:soundName ofType:@"mp3"];
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

#pragma mark -
#pragma mark touchAction
// ctrlBtnのtouchUpInside時に実行される処理を実装
- (IBAction)touchUpInsideCtrlBtn:(UIButton *)sender {
    
    if (_rollPlayerTmp.isPlaying || _rollPlayerAlt.isPlaying) {
        // ドラムロール再生中にctrlBtnが押されたときクラッシュ再生
        
        // _redCircleをビューから削除
        [_redCircle removeFromSuperview];
        
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
        [lastCircle setCenter:self.bugFixContainerViewForSnare.center];
        // ImageViewCircleをアニメーション開始までhiddenにする
        [lastCircle setHidden:1];
        // ビューにimgViewCircleを描画
        [self addSubview:lastCircle];
        
        
        // touchDown時のtransformとdisabelにしたのを戻す
        [self.ctrlBtn clearTransformBtnSetEnable];
        [self.ctrlBtn setHidden:1];  // altCtrlBtnForCrashAnimationをそのまま拡大アニメーションすると拡大されすぎる問題があったのでctrlBtn.aphaを0にする。hiddenにするとviewDidAppearでの拡大アニメーションが再生されてしまう問題あり
        
        // 円のクラッシュ再生時のアニメーション
        [lastCircle circleAnimationFinish:0.4 completion:^{
            [lastCircle removeFromSuperview];
        }];
        
        // defaultの画像が回転しながら大きくなってくるアニメーション
        [self.altCtrlBtnForCrashAnimation crashUIImageViewAnimationCompletion:^{
            [self.altCtrlBtnForScaleUp appearEmeraldWithScaleUp:_imageBtnDefault completion:^{
                    [self.ctrlBtn appearAfterInterval:nil];
                [self greenRippleSetUp];
                
                [self ctrlBtnGrennRippleAnimationStart];
                [[kADMOBInterstitialSingleton sharedInstans] interstitialControll]; // 生成、表示の判断含め全部この中でやる
                
            }];
        
        }]; // (1.09sec)ctrlBtnをそのまま同様のアニメーションをさせると、ctrlBtnをギュンギュンアニメーションさせている都合で、タイミングによって結果がとても大きくなることがあるため、本イメージビューをアニメーション用として準備
        
        //pauseBtnの消失アニメーション
        [self.pauseBtn disappearWithRotateScaleDownSetDisableCompletion:^{
            
        }];
        
    } else {
        // ドラムロール停止中にctrlBtnが押されたとき
        [_greenCircle removeFromSuperview];
        // ドラムロールを再生する
        [_rollPlayerTmp playRollStopCrash:_crashPlayer setVolumeZero:_rollPlayerAlt ];
        // playerControllを1.0秒間隔で呼び出すタイマーを作る
        [self playerControll];
        
        
        // redCircle準備
        [self redRippleSetUp];
        
        // ctrlBtnRedRippleAnimationStartするまでctrlBtnを隠す
        [self.ctrlBtn setHidden:1];
        
        // 赤いctrlBtnの拡大
        [self.altCtrlBtnForScaleUp appearALIZARINWithScaleUp:nil completion:^{
            [self.ctrlBtn appearAfterInterval:nil];
            [self ctrlBtnRedRippleAnimationStart:nil];
            // 【アニメーション】ロールのアニメーションを再生する
            [self.ctrlBtn.imageView startAnimating];
        }]; // 0.4sec
        
        
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
    [self ctrlBtnHighlightedAnimationStart];
    
}


/* PauseBtnのハイライト処理 */
// タッチしたとき
- (IBAction)touchDownPauseBtn:(UIButton *)sender {
    [self.pauseBtn highlightedAnimation]; // ハイライトアニメーション実行
}

// ctrlBtnの下のpauseBtnを押した時に実行される処理を実装
- (IBAction)touchUpInsidePauseBtn:(UIButton *)sender {
    NSLog(@"touchUpInsidePauseBtn");
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

    // ctrlBtnをhiddenかつ無効にする
    [self.ctrlBtn setEnabled:0];
    [self.ctrlBtn setHidden:1];
    // 赤いUIImageView消える
    [self.altCtrlBtnForScaleDown disappearALIZARINWithScaleUp:_imageBtnDefault completion:^{
        [self.altCtrlBtnForScaleUp appearEmeraldWithScaleUp:_imageBtnDefault completion:^{
            [self.ctrlBtn appearAfterInterval:nil];
        }];
    }]; // 0.3f
    
    //pauseBtnの消失アニメーション
    [self.pauseBtn disappearWithRotateScaleDownSetDisableCompletion:^{
        
    }];
    
    // 初期画面を呼び出す
    [self greenRippleSetUp];
    
    [self ctrlBtnGrennRippleAnimationStart];
    
    
}

- (void)stopAudioResetAnimation{
    if (_rollPlayerTmp.isPlaying || _rollPlayerAlt.isPlaying){
        NSLog(@"stopAudioResetAnimationTrue");
        [self touchUpInsidePauseBtn:nil];
    }else{
        NSLog(@"stopAudioResetAnimationFalse");
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
        [self greenRippleSetUp];
        [self ctrlBtnGrennRippleAnimationStart];
    }
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
    NSLog(@"backgroundBtn");
    [_crashPlayer stopPlayer];
    
}

#pragma mark rippleSetUp
- (void) greenRippleSetUp{
    NSLog(@"greenRippleSetUp");
    // デバイスがiphoneであるかそうでないかで分岐
    UIColor *color;
    CGFloat lineWidth;
    CGFloat radius;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        NSLog(@"iPhoneの処理");
        // ストロークカラーを緑に設定
        color = [UIColor colorWithRed:0.20 green:0.80 blue:0.40 alpha:1.0]; // EMERALD
        // ストロークの太さを設定
        lineWidth = 2.5f;
        // 半径を設定
        radius = (int)self.ctrlBtn.bounds.size.width * 0.95; //224
        // インスタンスを生成
//        _greenCircle = [[ImageViewCircle alloc] initWithFrame:CGRectMake(0, 0, radius, radius) withColor:color withLineWidth:lineWidth];
    }
    else{
        NSLog(@"iPadの処理");
        // ストロークカラーを緑に設定
        color = [UIColor colorWithRed:0.20 green:0.80 blue:0.40 alpha:1.0]; // EMERALD
        // ストロークの太さを設定
        lineWidth = 10.0f;
        // 半径を設定
        radius = (int)self.ctrlBtn.bounds.size.width * 0.95; // 448
        // インスタンスを生成
        if (_greenCircle == nil) {
//                   _greenCircle = [[ImageViewCircle alloc] initWithFrame:CGRectMake(0, 0, radius, radius) withColor:color withLineWidth:lineWidth];

        }
    }
    _greenCircle = [[ImageViewCircle alloc] initWithFrame:CGRectMake(0, 0, radius, radius) withColor:color withLineWidth:lineWidth];
    
    [_greenCircle setImage:[_greenCircle imageFillEllipseInRect]];
    
    // イメージビューのセンターをctrlAudioPlayerBtn.centerと合わせる
    [_greenCircle setCenter:self.bugFixContainerViewForSnare.center];

    // アニメーション再生まで隠しておく
    [_greenCircle setHidden:1];
    
    [self addSubview:_greenCircle];
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
        _redCircle = [[ImageViewCircle alloc] initWithFrame:CGRectMake(0, 0, radius, radius) withColor:color withLineWidth:lineWidth];
        
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
        _redCircle = [[ImageViewCircle alloc] initWithFrame:CGRectMake(0, 0, radius, radius) withColor:color withLineWidth:lineWidth];
    }
    
    
    
    [_redCircle setImage:[_redCircle imageFillEllipseInRect]];
    
    // 円をctrlBtn.centerと合わせる
    [_redCircle setCenter:self.bugFixContainerViewForSnare.center];
    // ImageViewCircleをアニメーション開始までhiddenにする
    [_redCircle setHidden:1];
    
    [self addSubview:_redCircle];
}

- (void) ctrlBtnGrennRippleAnimationStart{
    // サークルアニメーションタイマーを破棄する
    [self animationTimerInvalidate];
    
    
    // 円とctrlBtnのふわふわアニメーション
    // 【アニメーション】円の拡大アニメーションを3.0秒間隔で呼び出すタイマーを作る
    _rippleAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f
                                                             target:_greenCircle
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
    [self animationTimerInvalidate];
    
    // touchDown時のtransformとdisabelにしたのを戻す
    [self.ctrlBtn clearTransformBtnSetEnable];
    
    
    // 【アニメーション】円の縮小アニメーションを0.6秒間隔で呼び出すタイマーを作る
    _rippleAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:0.6f
                                                             target:_redCircle
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
    
    
    // ctrl、rippleアニメーションタイマー破棄
    if (_ctrlBtnAnimationTimer != nil) {
        [_ctrlBtnAnimationTimer invalidate];
    }
    if (_rippleAnimationTimer != nil) {
        [_rippleAnimationTimer invalidate];
    }
    if (_animationWaitTimer != nil) {
        [_animationWaitTimer invalidate];
    }
}


@end
