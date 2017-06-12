//
//  ViewController.m
//  BitsoundSample
//
//  Created by wonje-soundlly on 2017. 1. 23..
//  Copyright © 2017년 wonje-soundlly. All rights reserved.
//

#import "ViewController.h"

#import <RMessage/RMessage.h>
#import <SafariServices/SafariServices.h>
#import <AudioToolbox/AudioToolbox.h>

#import <BitsoundReceiver/BitsoundReceiver.h>
#import <BitsoundShaking/BitsoundShaking.h>

@interface ViewController () <BitsoundReceiverDelegate, BitsoundShakingDelegate, NSURLConnectionDelegate, NSURLSessionDataDelegate>

@property (nonatomic, strong) IBOutlet UIButton *startDetectWithContentsAssistantYESButton;

@end

@implementation ViewController

@synthesize startDetectWithContentsAssistantYESButton = _startDetectWithContentsAssistantYESButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    // init with app key
//    [[BitsoundReceiver sharedInstance] initWithAppKey:@"your_app_key"];
    [[BitsoundReceiver sharedInstance] initWithAppKey:@"9a1d52a0-34a0-49be-b8c0-6c3078a5788a"];

    
    // set delegate
    [BitsoundReceiver sharedInstance].delegate = self;
    
    // set tag
    [[BitsoundReceiver sharedInstance] setTag:@{@"tag1": @"tag_1"}];
    
    // set UUID
    [[BitsoundReceiver sharedInstance] setUUID:@"user_1"];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)startDetectWithContentsAssistant:(id)sender {

    
    BOOL contentsAssistant = NO;
    
    if (sender == _startDetectWithContentsAssistantYESButton) {
        contentsAssistant = YES;
    }
    
    
    // start detect with contents assistant
    // ContentsAssistant을 isUsed(YES)를 한 경우, 음파 수신 실패가 발생하면 광고 스케쥴을 조회한다.
    [[BitsoundReceiver sharedInstance] startDetectWithContentsAssistant:contentsAssistant detectResult:^(BitsoundReceiverDetectResult result) {
        
        if (result == BitsoundReceiverDetectSuccess) {
            
            // 신호 감지 시작 성공적.
            [self showMessage:RMessageTypeSuccess message:[self detectResultToMsg:result]];
            
        } else {
        
            // 신호 감지 시작 실패시 아래와 같은 종류의 코드가 반환됩니다.
            /**
             *	BitsoundReceiverDetectMicPermissionDenied, // mic. permission denied
             *	BitsoundReceiverDetectAlreadyStarted, // 이미 실행중임(동시에 안됨)
             *	BitsoundReceiverDetectNotInitialized, // SDK가 초기화 되지 않음
             *  BitsoundReceiverInitCoreError, // core 모듈 에러
             */
            
            [self showMessage:RMessageTypeError message:[self detectResultToMsg:result]];
            
            
            // mic. permission denied -> getScheduledContents (광고 스케쥴 조회)
//            if (result == BitsoundReceiverDetectMicPermissionDenied) {
//                
//                [[BitsoundReceiver sharedInstance] getScheduledContents];
//                
//                [[BitsoundReceiver sharedInstance] sendCustomLog:@{@"micPerm" : [NSNumber numberWithBool:NO]}];
//            }
            
        }
    }];
    
}


- (IBAction)stopDetect:(id)sender {
 
    // stop detect
    [[BitsoundReceiver sharedInstance] stopDetect];
    
}

- (IBAction)enableShake:(id)sender {
    
    // set delegate
    [BitsoundShaking sharedInstance].delegate = self;
    
    // enable shake
    BitsoundEnableShakeResult result = [[BitsoundShaking sharedInstance] enableShake];

    if (result == BitsoundEnableShakeSuccess) {
        
        [self showMessage:RMessageTypeSuccess message:[self shakeResultToMsg:result]];
    } else {
        
        [self showMessage:RMessageTypeError message:[self shakeResultToMsg:result]];
    }
    
}

- (IBAction)disableShake:(id)sender {
    
    // disable shake
    [[BitsoundShaking sharedInstance] disableShake];
}

#pragma mark - private
- (void)showMessage:(int)type message:(NSString *)message {
    
    [RMessage showNotificationInViewController:self
                                         title:@"Bitsound"
                                      subtitle:message
                                     iconImage:nil
                                          type:type
                                customTypeName:nil
                                      duration:1.4
                                      callback:^{
        
                                    } buttonTitle:nil
                                buttonCallback:^{
                                    } atPosition:RMessagePositionTop
                          canBeDismissedByUser:YES];
    
    
}

- (NSString *)resultForInitToMsg:(BitsoundReceiverInitResult)result {
    
    NSString *msg = @"";
    switch (result) {
        case BitsoundReceiverInitSuccess:
            msg = @"init success";
            break;
        case BitsoundReceiverInitInvalidArguments:
            msg = @"init invalid arguments";
            break;
        case BitsoundReceiverInitVerifyAppKeyError:
            msg = @"init verify app key error";
            break;
        case BitsoundReceiverInitNotScheduled:
            msg = @"init not scheduled";
            break;
        case BitsoundReceiverInitCoreError:
            msg = @"init core error";
            break;
        case BitsoundReceiverInitNetworkError:
            msg = @"init network error";
            
        default:
            break;
    }
    
    return msg;
}


- (NSString *)detectResultToMsg:(BitsoundReceiverDetectResult)result {
    
    NSString *msg = @"";
    switch (result) {
        case BitsoundReceiverDetectSuccess:
            msg = @"detect success";
            break;
        case BitsoundReceiverDetectMicPermissionDenied:
            msg = @"detect mic. permission denied";
            break;
        case BitsoundReceiverDetectAlreadyStarted:
            msg = @"detect already started";
            break;
            
        case BitsoundReceiverDetectNotInitialized:
            msg = @"detect not initialized";
            break;
        default:
            break;
    }
    return msg;
}


- (NSString *)resultToMsg:(BitsoundReceiverResult)result {
    NSString *msg = @"";
    switch (result) {
        case BitsoundReceiverSuccess:
            msg = @"sucess"; //정상수신중
            break;
        case BitsoundReceiverNoSignal:
            msg = @"no signal"; //미등록 신호
            break;
        case BitsoundReceiverInvalidBeacon:
            msg = @"invalid beacon";
            break;
        case BitsoundReceiverNetworkError:
            msg = @"network error";
            break;
        case BitsoundReceiverMicError:
            msg = @"mic. code error";
            break;
        default:
            break;
    }
    return msg;
}

- (NSString *)shakeResultToMsg:(BitsoundEnableShakeResult)result {
    
    NSString *msg = @"";
    switch (result) {
        case BitsoundEnableShakeSuccess:
            msg = @"enable shake success";
            break;
        case BitsoundEnableShakeReceiverNotInitialized:
            msg = @"receiver not initialized";
            break;
        case BitsoundEnableShakeAlreadyEnabled:
            msg = @"already enabled";
            break;
            
        default:
            break;
    }
    return msg;
}

#pragma mark - BitsoundReceiverDelegate
- (void)receiverDidReceiveInitResult:(BitsoundReceiverInitResult)initResult error:(NSError *)error {

    NSString *message = [self resultForInitToMsg:initResult];
    
    
    if (initResult == BitsoundReceiverInitSuccess) {
        
        // init이 성공이면, startDetect가 가능합니다. startDetect 또는 enableShake + startDetect를 통해 신호를 감지합니다.
        
        [self showMessage:RMessageTypeSuccess message:message];
        
        
        // set delegate
        [BitsoundShaking sharedInstance].delegate = self;
        
        // enable shake
        BitsoundEnableShakeResult result = [[BitsoundShaking sharedInstance] enableShake];
        
        if (result == BitsoundEnableShakeSuccess) {
            
            [self showMessage:RMessageTypeSuccess message:[self shakeResultToMsg:result]];
        } else {
            
            [self showMessage:RMessageTypeError message:[self shakeResultToMsg:result]];
        }
        
        
        
    } else {
    
        [self showMessage:RMessageTypeError message:message];
    }

}

- (void)receiverDidReceiveResult:(BitsoundReceiverResult)result contents:(BitsoundContentsModel *)contents {

    
    if (result == BitsoundReceiverSuccess) {
    
        [self showMessage:RMessageTypeSuccess message:[self resultToMsg:result]];
        
        NSLog(@"#########################################");
        NSLog(@"contentsModel.name : %@",contents.name);
        NSLog(@"    - contents url : %@", [contents getStrValue:@"url"]);
        NSLog(@"    - contents comment : %@", [contents getStrValue:@"comment"]);
        NSLog(@"#########################################");
        
        if (NSClassFromString(@"SFSafariViewController")) {
            
//            if ([[contents getStrValue:@"url"] hasPrefix:@"http://"] || [[contents getStrValue:@"url"] hasPrefix:@"htts://"]) {
            
            NSLog(@"url : %@", [contents getStrValue:@"url"]);
            
                SFSafariViewController *safariViewController = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString: [contents getStrValue:@"url"]]];
                [self presentViewController:safariViewController animated:YES completion:^{
                    
                }];
//            }
            
            
        } else {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: [[contents getStrValue:@"url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        }
        
    } else {
    
        [self showMessage:RMessageTypeError message:[self resultToMsg:result]];
    }
    
}

- (void)receiverDidStartDetect {

    [self showMessage:RMessageTypeNormal message:@"did start detect"];
}

- (void)receiverDidStopDetect {

    [self showMessage:RMessageTypeNormal message:@"did stop detect"];
}


#pragma mark - BitsoundShakingDelegate
- (void)shakingDidDetect {

    // 사용자에게 진동을 통해, shaking 되었다는것을 알려줍니다.
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    // start detect with contents assistant
    [[BitsoundReceiver sharedInstance] startDetectWithContentsAssistant:NO detectResult:^(BitsoundReceiverDetectResult result) {
        
        if (result == BitsoundReceiverSuccess) {
            
            // 신호 감지 시작 성공적.
            [self showMessage:RMessageTypeSuccess message:[self detectResultToMsg:result]];
            
        } else {
            
            // 신호 감지 시작 실패시 아래와 같은 종류의 코드가 반환됩니다.
            /**
             *	BitsoundReceiverDetectMicPermissionDenied, // mic. permission denied
             *	BitsoundReceiverDetectAlreadyStarted, // 이미 실행중임(동시에 안됨)
             *	BitsoundReceiverDetectNotInitialized, // SDK가 초기화 되지 않음
             */
            
            [self showMessage:RMessageTypeError message:[self detectResultToMsg:result]];
            
//            // mic. permission denied -> getScheduledContents (광고 스케쥴 조회)
//            if (result == BitsoundReceiverDetectMicPermissionDenied) {
//                
//                [[BitsoundReceiver sharedInstance] getScheduledContents];
//            }
            
        }
        
    }];
}

@end
