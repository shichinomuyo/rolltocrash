//
//  AVAudioPlayer+CustomControllers.h
//  rollToCrash
//
//  Created by 七野祐太 on 2014/08/06.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface AVAudioPlayer (CustomControllers)

- (void)playRollStopCrash:(AVAudioPlayer *)crashPlayer setVolumeZero:(AVAudioPlayer *)rollPlayer_alt;
- (void)playCrashStopRolls:(AVAudioPlayer *)rollPlayer_tmp :(AVAudioPlayer *)rollPlayer_alt;

- (void)startAltPlayer:(AVAudioPlayer *)player setStartTime:(float)startTime setVolume:(float)volume;
- (void)crossFadePlayer:(AVAudioPlayer *)tmpPlayer :(AVAudioPlayer *)altPlayer;
- (void)stopPlayer:(AVAudioPlayer *)player;

@end
