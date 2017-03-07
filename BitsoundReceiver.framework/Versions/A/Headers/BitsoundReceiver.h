//
//  BSReceiverLib.h
//  BSReceiverLib
//
//  Created by wonje-soundlly on 2016. 12. 13..
//  Copyright © 2016년 wonje-soundlly. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BitsoundContentsModel.h"



@protocol BitsoundReceiverDelegate;


/**
 *  init result enum
 */
typedef NS_ENUM(int, BitsoundReceiverInitResult) {
    BitsoundReceiverInitSuccess = 0,	// 성공
    BitsoundReceiverInitInvalidArguments = -1, // 잘못된 appKey
    BitsoundReceiverInitVerifyAppKeyError = -2, // verify app key error
    BitsoundReceiverInitNotScheduled = -3, // check and init의 경우에 해당되며, 스케쥴에 포함되지 않은 경우 reruen.
    BitsoundReceiverInitCoreError = -4 // 음파 수신 core module init error
};


/**
 *  detect result enum
 */
typedef NS_ENUM(int, BitsoundReceiverDetectResult) {
    BitsoundReceiverDetectSuccess = 0,    // detect success
    BitsoundReceiverDetectMicPermissionDenied = -1,   // mic. permission denied
    BitsoundReceiverDetectAlreadyStarted = -2,    // detect alredy started
    BitsoundReceiverDetectNotInitialized = -3 // not initialized
};

/**
 *  receiver result enum
 */
typedef NS_ENUM(int, BitsoundReceiverResult) {
    
    BitsoundReceiverSuccess = 0,	// 사운드 비콘 및 컨텐츠 확인
    BitsoundReceiverNoSignal = -1, // 사운드 비콘 없음
    BitsoundReceiverInvalidBeacon = -2, // 사운드 비콘은  있으나 서버에 컨텐츠 없음
    BitsoundReceiverNetworkError = -3, // 사운드 비콘은  있으나 서버 접속 타임아웃
    BitsoundReceiverMicError = -4 // Device's mic error
};




@interface BitsoundReceiver : NSObject

@property (nonatomic, weak, nullable) id <BitsoundReceiverDelegate> delegate;
@property (nonatomic, readonly) BOOL isInitialized;







/**
 *  singleton BitsoundReceiver instance를 return한다.
 */
+ (nonnull BitsoundReceiver *)sharedInstance;

/**
 *  SDK 초기화
 최초 1회 서버로 init 로그 전송(로그 항목 참고)
 init 로그 전송 성공시 Preference에 init 기록을 저장해 놓은 후 다음부터는 로그를 보내지 않는다. 네트워크 오류등으로 인해 전송이 안될 경우 다음 init시에 전송
 
 *
 *  @param appKey 사운들리 App Key
 *
 */
- (void)initWithAppKey:(nonnull NSString *)appKey;


/**
 *  SDK 초기화
 스케쥴을 체크하여, 해당 스케쥴에 포함된 경우에만 init시킨다.
 최초 1회 서버로 init 로그 전송(로그 항목 참고)
 init 로그 전송 성공시 Preference에 init 기록을 저장해 놓은 후 다음부터는 로그를 보내지 않는다. 네트워크 오류등으로 인해 전송이 안될 경우 다음 init시에 전송
 
 *
 *  @param appKey 사운들리 App Key
 *
 */
- (void)checkAndInitWithAppKey:(nonnull NSString *)appKey;




/**
 *	신호감지 바로시작
 *  enableShake()와 동시에 사용할 수 없다.
 *	신호 녹음을 바로 4회 시작한다.
 *	4회 이내에 신호가 발견되면 코어에 디코딩 요청한 후 결과 값에 따라 처리한 후 앱에 알려주고, 남은 녹음 시도는 중단된다.
 *	StartDetectBlock이 호출된다. (detect result 결과 전달)
 *  ContentsAssistant을 isUsed(YES)를 한 경우, 음파 수신 실패가 발생하면 광고 스케쥴을 조회한다.
 *
 *  result
 0 : 신호 감지 시작 성공
 -1 : 마이크 퍼미션 없음
 -2 : startDetect가 이미 실행중임(동시에 안됨)
 -3 : init 실패
 */
typedef void (^StartDetectBlock)(BitsoundReceiverDetectResult result);

- (void)startDetectWithContentsAssistant:(BOOL)isUsed detectResult:(nonnull StartDetectBlock)detectResult;

/**
 *	신호 감지 바로 종료
 *  신호 감지 중이면 바로 종료한다.
 *	신호 감지 중이 아니면 아무런 동작도 안한다.
 */
- (void)stopDetect;

/**
 *  커스텀 로그 전송
 *
 *  @param customLog 사운들리로 보낼 커스텀 로그
 */
- (void)sendCustomLog:(nonnull NSDictionary *)customLog;


/**
 *  광고 스케쥴 컨텐츠 조회
 *  광고 스케쥴을 조회하여, 스케쥴에 해당되면 광고 컨텐트를 return한다.
 *
 */
- (void)getScheduledContents;

@end

/**
 *	BSReceiverDelegate는 singleton BitsoundReceiver의 동작과정에서의, 중요한 이벤트 발생시, 응답하기 위한 메소드를 정의한다
 *
 */
@protocol BitsoundReceiverDelegate <NSObject>

/**
 *	init 결과를 전달한다.
 *  @param initResult BSReceiverInitResult
 *  @param error NSError
 */
- (void)receiverDidReceiveInitResult:(BitsoundReceiverInitResult)initResult error:(nullable NSError *)error;

/**
 *	수신 신호 처리 결과를 전달한다.
 *  @param result BSReceiverResult
 *  @param contents BitsoundContentsModel
 */
- (void)receiverDidReceiveResult:(BitsoundReceiverResult)result contents:(nullable BitsoundContentsModel *)contents;

/**
 *	start detect 직후에 호출된다.
 */
- (void)receiverDidStartDetect;

/**
 *	stop detect 직후에 호출된다.
 */
- (void)receiverDidStopDetect;



@end
