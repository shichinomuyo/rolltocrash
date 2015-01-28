//
//  kPageView.h
//  rollToCrash
//
//  Created by 七野祐太 on 2015/01/23.
//  Copyright (c) 2015年 shichino yuta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <QuartzCore/QuartzCore.h>
#import "ImageViewCircle.h"
#import "UIButton+Animation.h"
#import "UIImageView+Animation.h"
#import "AVAudioPlayer+CustomControllers.h"
#import "BugFixContainerView.h"

#import "kADMOBInterstitialSingleton.h"

@interface kContentView : UIView{
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
    NSTimer *_animationWaitTimer; // 拡大/縮小アニメーション終了待ちタイマー
    
    // 【アニメーション】ロール再生中のコマを入れる配列
    NSArray *animationSeq;
    
    NSCoder *kCoder;
    
    UIImage *_imageBtnDefault;
}
@property (strong, nonatomic) IBOutlet UIView* _contentView;
@property (weak, nonatomic) IBOutlet UILabel *labelCaption;
@property (weak, nonatomic) IBOutlet UIButton *ctrlBtn;
@property (weak, nonatomic) IBOutlet UIButton *pauseBtn;

@property NSString *soundName;
@property NSArray *imageNames;

@property (weak, nonatomic) IBOutlet UIImageView *altCtrlBtnForCrashAnimation; // ctrlBtnをそのまま同様のアニメーションをさせると、ctrlBtnをギュンギュンアニメーションさせている都合で、タイミングによって結果がとても大きくなることがあるため、本イメージビューをアニメーション用として準備
@property (weak, nonatomic) IBOutlet UIImageView *altCtrlBtnForScaleUp;

@property (weak, nonatomic) IBOutlet UIImageView *altCtrlBtnForScaleDown;

//@property (weak, nonatomic) IBOutlet UIButton *btnSetting;

- (IBAction)touchUpInsideCtrlBtn:(UIButton *)sender;
- (IBAction)touchDownCtrlBtn:(UIButton *)sender;
- (IBAction)touchDragExitCtrlBtn:(UIButton *)sender;
- (IBAction)touchDragEnterCtrlBtn:(UIButton *)sender;

- (IBAction)touchUpInsidePauseBtn:(UIButton *)sender;
- (IBAction)touchDownPauseBtn:(UIButton *)sender;
- (IBAction)touchDragExitPauseBtn:(UIButton *)sender;
- (IBAction)touchDragEnterPauseBtn:(UIButton *)sender;

- (IBAction)touchDownBackgroundBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet BugFixContainerView *bugFixContainerViewForSnare;
@property (weak, nonatomic) IBOutlet BugFixContainerView *bugFixContainerViewForPuseBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintVerticalSpaceBFVtoSuperView;
//-(id)initWithImageName:(NSArray *)imageNames soundName:(NSString *)soundName caption:(NSString *)caption;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintCenterXAlignmentBFCVPauseBtn;

- (void)_init;
+ (instancetype)view;
- (void)setImages:(NSArray *)images soundName:(NSString *)soundName capcion:(NSString *)caption;
- (void)stopAudioResetAnimation;
@end
