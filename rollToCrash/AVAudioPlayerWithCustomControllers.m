//
//  AVAudioPlayerWithCustomControllers.m
//  rollToCrash
//
//  Created by 七野祐太 on 2014/08/05.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import "AVAudioPlayerWithCustomControllers.h"

@implementation AVAudioPlayerWithCustomControllers{

}
- (void)initializeAVAudioPlayers{
    // (audioplayer)再生する効果音のパスを取得する
    // ドラムロール
    NSString *path_roll = [[NSBundle mainBundle] pathForResource:@"roll" ofType:@"aiff"];
    NSURL *url_roll = [NSURL fileURLWithPath:path_roll];
    _rollPlayerTmp = [[AVAudioPlayer alloc] initWithContentsOfURL:url_roll error:NULL];
    
    // ロールalt
    _rollPlayerAlt = [[AVAudioPlayer alloc] initWithContentsOfURL:url_roll error:NULL];
    
    
    // クラッシュ
    NSString *path_clash = [[NSBundle mainBundle] pathForResource:@"crash" ofType:@"aif"];
    NSURL *url_clash = [NSURL fileURLWithPath:path_clash];
    _crashPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url_clash error:NULL];
    
    // ドラムロールだけループさせるのでデリゲートに指定
    // audioPlayer を作ったあとにデリゲート指定しないと機能しない
    [_rollPlayerTmp setDelegate:self];
    [_rollPlayerAlt setDelegate:self];
    
    // プレイヤーを準備
    [_rollPlayerTmp prepareToPlay];
    [_rollPlayerAlt prepareToPlay];
    [_crashPlayer prepareToPlay];
}

// Crashを止めてRollを再生
- (void)playRollStopCrash:(AVAudioPlayer *)crashPlayer setVolumeZero:(AVAudioPlayer *)rollPlayer_alt{
    NSLog(@"playRoll!");
    // 再生位置を最初に設定
    self.currentTime = 0.0;
    
    // スネアスプラッシュを停止し最初まで戻す
    [crashPlayer stop];
    crashPlayer.currentTime = 0.0;
    
    // ドラムロールを再生する
    self.volume = 1.0;
    [self play];
    
    // alt.volumeを0に設定
    rollPlayer_alt.volume = 0.0;
}
// クラッシュを再生するメソッドを実装
-(void)playCrashStopRolls:(AVAudioPlayer *)rollPlayer_tmp :(AVAudioPlayer *)rollPlayer_alt
{
    // ループしているドラムロールを止める
    [rollPlayer_tmp stop];
    rollPlayer_tmp.currentTime = 0.0;
    [rollPlayer_alt stop];
    rollPlayer_alt.currentTime = 0.0;
    
    // クラッシュを再生する
    [self play];
}

// ロールをループさせるためにaltPlayerを再生しクロスフェード管理用フラグをアクティブにするメソッドを実装
- (void)startAltPlayer:(AVAudioPlayer *)player setStartTime:(float)startTime setVolume:(float)volume{
    // altPlayerのボリュームと開始位置を設定し再生
    player.volume = volume;
    player.currentTime = startTime;
    [player play];
}

// 2つのロールプレイヤーをクロスフェードさせるメソッド
- (void)crossFadePlayer:(AVAudioPlayer *)tmpPlayer :(AVAudioPlayer *)altPlayer{
    // tmpPlayerとaltPlayerのボリュームを0.1ずつ上げ下げ
    tmpPlayer.volume = tmpPlayer.volume - 0.1;
    altPlayer.volume = altPlayer.volume + 0.1;
    
}

// プレイヤーの再生を止めてcurrentTimeを0.0にセット
- (void)stopPlayer:(AVAudioPlayer *)player{
    // playerをストップしplayer.currentTimeを0.0に戻す
    [player stop];
    player.currentTime = 0.0;
    
}


+ (BOOL)tmpIsPlaying{
    return _rollPlayerTmp.isPlaying;
}

+ (BOOL)altIsPlaying{
    return _rollPlayerAlt.isPlaying;
}


@end
