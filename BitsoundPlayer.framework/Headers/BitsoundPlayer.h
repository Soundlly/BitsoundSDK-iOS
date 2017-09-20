//
//  BitsoundPlayerLib.h
//  BitsoundPlayerLib
//
//  Created by wonje-soundlly on 2017. 7. 21..
//  Copyright © 2017년 wonje-soundlly. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol BitsoundPlayerDelegate;

@interface BitsoundPlayer : NSObject

@property (nonatomic, weak, nullable) id <BitsoundPlayerDelegate> delegate;

/**
 *  singleton BitsoundPlayer instance를 return한다.
 */
+ (nonnull BitsoundPlayer *)sharedInstance;

/**
 * 해당 소리 신호(Sound Beacon)를, volume 크기로 play한다.
 * BitsoundPlayerDelegate protocol method를 통해, play에 대한 이벤트가 전달된다.
 * beacon : 소리 신호(Sound Beacon) 아이디 (사운들리 Portal에서 발급할 수 있습니다.)
 * volume : 소리 크기 (최대 0 dbFs ~ 최소 -32 dbFs 설정 가능)
 */

- (void)playWithBeacon:(unsigned int)beacon volume:(int)volume;

/**
 * 해당 소리 신호(Sound Beacon)를, volume 크기로 duration동안 play하고, stop된다.
 * BitsoundPlayerDelegate protocol method를 통해, play에 대한 이벤트가 전달된다.
 * beacon : 소리 신호(Sound Beacon) 아이디 (사운들리 Portal에서 발급할 수 있습니다.)
 * volume : 소리 크기 (최대 0 dbFs ~ 최소 -32 dbFs 설정 가능)
 * duration : play 되는 시간으로, 초 단위로 설정 가능
 */
- (void)playWithBeacon:(unsigned int)beacon volume:(int)volume duration:(NSTimeInterval)duration;

/**
 * stop 시킨다.
 * BitsoundPlayerDelegate protocol method를 통해, stop에 대한 이벤트가 전달된다.
 */
- (void)stop;

@end

/**
 * BitsoundPlayerDelegate protocol은 소리 신호(Sound Beacon) play/stop시 발생하는, 이벤트 정보 전달해주는 메소드를 정의한다.
 */
@protocol BitsoundPlayerDelegate <NSObject>

/**
 *	player play 직후에 호출된다.
 */
- (void)playerDidStart;

/**
 *	player stop 직후에 호출된다.
 */
- (void)playerDidStop;

/**
 *	receiver with app key로 초기화 되지 않음.
 *  BitsoundReceiver initWithAppKey: 로 초기화를 해야함.
 */
- (void)receiverWithAppKeyDidNotInitialize;

@optional
/**
 *	play시, 오류가 발생될때 호출된다.
 */
- (void)playWithError:(NSError *_Nullable)error;

/**
 *	stop시, 오류가 발생될때 호출된다.
 */
- (void)stopWithError:(NSError *_Nullable)error;

@end
