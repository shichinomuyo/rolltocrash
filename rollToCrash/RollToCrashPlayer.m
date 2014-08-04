//
//  RollToCrashPlayer.m
//  rollToCrash
//
//  Created by 七野祐太 on 2014/08/03.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import "RollToCrashPlayer.h"

@implementation RollToCrashPlayer
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
+ (void)startAltPlayer:(AVAudioPlayer *)player setStartTime:(float)startTime setVolume:(float)volume{
    // altPlayerのボリュームと開始位置を設定し再生
    player.volume = volume;
    player.currentTime = startTime;
    [player play];
}

// 2つのロールプレイヤーをクロスフェードさせるメソッド
+ (void)crossFadePlayer:(AVAudioPlayer *)tmpPlayer :(AVAudioPlayer *)altPlayer{
    // tmpPlayerとaltPlayerのボリュームを0.1ずつ上げ下げ
    tmpPlayer.volume = tmpPlayer.volume - 0.1;
    altPlayer.volume = altPlayer.volume + 0.1;
    
}

// プレイヤーの再生を止めてcurrentTimeを0.0にセット
+ (void)stopPlayer:(AVAudioPlayer *)player{
    // playerをストップしplayer.currentTimeを0.0に戻す
    [player stop];
    player.currentTime = 0.0;
    
}

@end
