//
//  BSShaking.h
//  BitsoundShakingLib
//
//  Created by wonje-soundlly on 2017. 1. 16..
//  Copyright © 2017년 wonje-soundlly. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  shake result enum
 */
typedef NS_ENUM(int, BitsoundEnableShakeResult) {
    
    BitsoundEnableShakeSuccess = 0,	// enable shake success
    BitsoundEnableShakeReceiverNotInitialized = -1, // receiver not initialized
    BitsoundEnableShakeAlreadyEnabled = -2, // already enabled
};

@protocol BitsoundShakingDelegate;

@interface BitsoundShaking : NSObject

@property (nonatomic, weak, nullable) id<BitsoundShakingDelegate> delegate;

@property (nonatomic, readonly) BOOL isEnabled;


/**
 *  singleton BitsoundShaking instance를 return한다.
 */
+ (nonnull BitsoundShaking *)sharedInstance;

/**
 *	shaking 감지 시작
 *  이 메소드를 실행하면 shaking 감지 시작상태가 된다.
 *	shaking해도 녹음을 시작 안한다.
 *  shaking 감지시, shakingDidDetect delegate method가 호출된다.
 
 
 */
- (BitsoundEnableShakeResult)enableShake;

/**
 *	shaking 감지 종료
 *  이 메소드를 실행하면 shaking 감지 상태가 종료 된다.
 */
- (void)disableShake;

@end


/**
 *	BitsoundShakingDelegate는 singleton BitsoundShaking의 동작과정에서의, 중요한 이벤트 발생시, 응답하기 위한 메소드를 정의한다
 *
 */
@protocol BitsoundShakingDelegate <NSObject>


/**
 *	shaking detect 직후에 호출된다.
 */
- (void)shakingDidDetect;

@end
