//
//  FluctSDK.h
//  FluctSDK ver. 3.0.2
//
//  Fluct SDK
//  Copyright 2011-2014 VOYAGE GROUP, Inc. All rights reserved.
//

/*
 * SDKの各処理を行う
 * ・広告表示設定 (表示処理はFluctBannerViewにて行われる)
 * ・コンバージョン通知処理
 */

#import <UIKit/UIKit.h>

@interface FluctSDK : NSObject

@property (nonatomic, copy) NSString* applicationId;
+ (FluctSDK *)sharedInstance;

/*
 * setBannerConfiguration
 * 広告表示設定を行う
 * FluctBannerViewのインスタンス生成前にコールします
 *
 * arguments:
 * (NSString*)mediaId : メディアID
 * (NSString*)orientationType : 未使用(v2.0.0未満との互換性用)
 */
-(void)setBannerConfiguration:(NSString*)mediaId orientationType:(NSString*)orientationType;

/*
 * setBannerConfiguration
 * 広告表示設定を行う
 * FluctBannerViewのインスタンス生成前にコールします
 *
 * arguments:
 * (NSString*)mediaId : メディアID
 */
-(void)setBannerConfiguration:(NSString*)mediaId;

/*
 * [コンバージョン通知処理]
 * アプリケーション起動時に実行します
 *
 * arguments:
 * (NSString*)mediaId : メディアID
 */
-(void)setConversion:(NSString*)mediaId;

@end