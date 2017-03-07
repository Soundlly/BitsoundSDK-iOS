//
//  ViewController.swift
//  BitsoundSampleForSwift
//
//  Created by wonje-soundlly on 2017. 2. 1..
//  Copyright © 2017년 wonje-soundlly. All rights reserved.
//

import UIKit

import TSMessages
import AudioToolbox
import SafariServices

class ViewController: UIViewController {

    
    @IBOutlet var startDetectWithContentsAssistantTrueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // init with app key
        
//        BitsoundReceiver.sharedInstance().initWithAppKey("your_app_key")
        
        BitsoundReceiver.sharedInstance().initWithAppKey("2af56e31-d2dd-40ef-80b3-d9e505759e4f")
        
        // set delegate
        BitsoundReceiver.sharedInstance().delegate = self
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    @IBAction func startDetectWithContentsAssistant(_ sender: AnyObject?) {
    
        var contentsAssistant = false
        
        if let button = sender as? UIButton {
            if button == self.startDetectWithContentsAssistantTrueButton {
            
                contentsAssistant = true;
            }
            
        }
        
        
        // start detect with contents assistant
        // ContentsAssistant을 isUsed(YES)를 한 경우, 음파 수신 실패가 발생하면 광고 스케쥴을 조회한다.
        BitsoundReceiver.sharedInstance().startDetect(withContentsAssistant: contentsAssistant) { (detectResult: BitsoundReceiverDetectResult) in
            
            if detectResult == BitsoundReceiverDetectResult.success {
            
                // 신호 감지 시작 성공적.
                self.showMessage(type: TSMessageNotificationType.success, message: self.detectResultToMsg(result: detectResult))
            
            } else {
                
                // 신호 감지 시작 실패시 아래와 같은 종류의 코드가 반환됩니다.
                /**
                 *	BitsoundReceiverDetectMicPermissionDenied, // mic. permission denied
                 *	BitsoundReceiverDetectAlreadyStarted, // 이미 실행중임(동시에 안됨)
                 *	BitsoundReceiverDetectNotInitialized, // SDK가 초기화 되지 않음
                 *  BitsoundReceiverInitCoreError, // core 모듈 에러
                 */
                
                self.showMessage(type: TSMessageNotificationType.error, message: self.detectResultToMsg(result: detectResult))
                
                // mic. permission denied -> getScheduledContents (광고 스케쥴 조회)
//                if detectResult == BitsoundReceiverDetectResult.micPermissionDenied {
//                
//                    BitsoundReceiver.sharedInstance().getScheduledContents()
//                    
//                    // user가 mic. permission denied를 한 경우, 그에 대한 로깅.
//                    BitsoundReceiver.sharedInstance().sendCustomLog(["micPerm" : false])
//                    
//                }
                
            
            }
        }
        
    }
    
    @IBAction func stopDetect(_ sender: Any?) {
        
        BitsoundReceiver.sharedInstance().stopDetect()
    }
    
    @IBAction func enableShake(_ sender: Any?) {
        
        // BitsoundShaking set delegate
        BitsoundShaking.sharedInstance().delegate = self
        
        // BitsoundShaking enable shake
        BitsoundShaking.sharedInstance().enableShake()
        
    }
    
    @IBAction func disableShake(_ sender: Any?) {
        
        BitsoundShaking.sharedInstance().disableShake()
    }
    
    
 
    // MARK: - private
    func showMessage(type: TSMessageNotificationType, message: String) {
    
        TSMessage.showNotification(in: self.navigationController,
                                   title: "Bitsound",
                                   subtitle: message,
                                   image: nil,
                                   type: type,
                                   duration: 1.4,
                                   callback: nil,
                                   buttonTitle: nil,
                                   buttonCallback: { 
                                    
                                    print("User tapped the button");
                                    },
                                   at: TSMessageNotificationPosition.top,
                                   canBeDismissedByUser: true)
    }
    
    func detectResultToMsg(result: BitsoundReceiverDetectResult) -> String {
    
        var msg = ""
        
        switch result {
        case .success:
            msg = "detect success"
            
        case .micPermissionDenied:
            msg = "detect mic. permission denied"
            
        case .alreadyStarted:
            msg = "detect already started"
            
        case .notInitialized:
            msg = "detect not initialized"
            
        }
        
        return msg
    }
    
    func resultForInitToMsg(result: BitsoundReceiverInitResult) -> String {
    
        var msg = ""
        
        switch result {
        case .success:
            msg = "init success"
            
        case .invalidArguments:
            msg = "init invalid arguments"
            
        case .verifyAppKeyError:
            msg = "init verify app key error"
            
        case .notScheduled:
            msg = "init not scheduled"
            
        case .coreError:
            msg = "init core error"
            
        }
        
        return msg
    }
    
    func resultToMsg(result: BitsoundReceiverResult) -> String {
    
        var msg = ""
        
        switch result {
        case .success:
            msg = "success" // 정상 수신
            
        case .noSignal:
            msg = "no signal"   // 신호 없음
            
        case .invalidBeacon:    //  다른 신호
            msg = "invalid beacon"
        
        case .networkError:
            msg = "network error"
            
        case .micError:
            msg = "mic. code error"
        }
        
        return msg
    }
    
}


// MARK: - BitsoundReceiverDelegate
extension ViewController: BitsoundReceiverDelegate {

    // init 결과
    func receiverDidReceive(_ initResult: BitsoundReceiverInitResult, error: Error?) {
        
        if initResult == BitsoundReceiverInitResult.success {
            
            self.showMessage(type: TSMessageNotificationType.success, message: self.resultForInitToMsg(result: initResult))
    
            
            // BitsoundShaking set delegate
            BitsoundShaking.sharedInstance().delegate = self
            
            // BitsoundShaking enable shake
            BitsoundShaking.sharedInstance().enableShake()
        } else {
            
            self.showMessage(type: TSMessageNotificationType.error, message: self.resultForInitToMsg(result: initResult))
        }
    
        
    }
    
    
    // 고주파 수신 결과
    func receiverDidReceive(_ result: BitsoundReceiverResult, contents: BitsoundContentsModel?) {
        
        if result == .success {
        
            self.showMessage(type: TSMessageNotificationType.success, message: self.resultToMsg(result: result))
            
            if let unwrappedUrlString = contents?.getStrValue("url"), let unwrappedName = contents?.name, let unwrappedComment = contents?.getStrValue("comment") {
            
                print("contents name : \(unwrappedName), comment : \(unwrappedComment)")
                
                if #available(iOS 9.0, *) {
                
                    let safariViewController = SFSafariViewController(url: URL(string: unwrappedUrlString)!)
                    self.present(safariViewController, animated: true, completion: { 
                        
                    })
                } else {
                
                    UIApplication.shared.openURL(URL(string: unwrappedUrlString)!)
                }
                
            }
            
        } else {
        
            self.showMessage(type: TSMessageNotificationType.error, message: self.resultToMsg(result: result))
            
        }
        
    }
    
    // start detect 되었다는 noti.
    func receiverDidStartDetect() {
     
        self.showMessage(type: TSMessageNotificationType.message, message: "did start detect")
    }
    
    // stop detect 되었다는 noti.
    func receiverDidStopDetect() {
        
        self.showMessage(type: TSMessageNotificationType.message, message: "did stop detect")
    }
    
}

// MARK: - BitsoundShakingDelegate
extension ViewController: BitsoundShakingDelegate {

    // shaking detect 되었다는 noti.
    func shakingDidDetect() {
        
        self.showMessage(type: TSMessageNotificationType.message, message: "shakingDidDetect")
        
        // shaking detect시 진동
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        
        
        // start detect with contents assistant
        // withContentsAssistant : true를 한 경우, 음파 수신 실패가 발생하면 광고 스케쥴을 조회한다.
        BitsoundReceiver.sharedInstance().startDetect(withContentsAssistant: false) { (detectResult: BitsoundReceiverDetectResult) in
            
            if detectResult == BitsoundReceiverDetectResult.success {
        
                // 신호 감지 시작 성공적.
                
                self.showMessage(type: TSMessageNotificationType.success, message: self.detectResultToMsg(result: detectResult))
            } else {
                
                // 신호 감지 시작 실패시 아래와 같은 종류의 코드가 반환됩니다.
                /**
                 *	BitsoundReceiverDetectMicPermissionDenied, // mic. permission denied
                 *	BitsoundReceiverDetectAlreadyStarted, // 이미 실행중임(동시에 안됨)
                 *	BitsoundReceiverDetectNotInitialized, // SDK가 초기화 되지 않음
                 */
            
                self.showMessage(type: TSMessageNotificationType.error, message: self.detectResultToMsg(result: detectResult))
            }
            
            
            // mic. permission denied -> getScheduledContents (광고 스케쥴 조회)
//            if detectResult == BitsoundReceiverDetectResult.micPermissionDenied {
//                
//                BitsoundReceiver.sharedInstance().getScheduledContents()
//                
//                // user가 mic. permission denied를 한 경우, 그에 대한 로깅.
//                BitsoundReceiver.sharedInstance().sendCustomLog(["micPerm" : false])
//            }
            
        }
    }
}


