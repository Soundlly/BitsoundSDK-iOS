//
//  ViewController.swift
//  BitsoundSampleForSwift
//
//  Created by wonje-soundlly on 2017. 3. 7..
//  Copyright © 2017년 wonje-soundlly. All rights reserved.
//


import UIKit

import AudioToolbox
import SafariServices

class ViewController: UIViewController {
    
    
    @IBOutlet var startDetectWithContentsAssistantTrueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // init with app key
//        BitsoundReceiver.sharedInstance().initWithAppKey("your_app_key")
        BitsoundReceiver.sharedInstance().initWithAppKey("75d97ae5-0e2d-4322-82cd-9770d129cd04")
        
        // receiver set delegate
        BitsoundReceiver.sharedInstance().delegate = self
        
        // player set delegate
        BitsoundPlayer.sharedInstance().delegate = self
        
        // set tag (optional)
        BitsoundReceiver.sharedInstance().setTag(["tag1": "tag_1"])
        
        // set UUID (optional)
        BitsoundReceiver.sharedInstance().setUUID("user_1")
        
        
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
                self.showMessage(type: RMessageType.success, message: self.detectResultToMsg(result: detectResult))
                
            } else {
                
                // 신호 감지 시작 실패시 아래와 같은 종류의 코드가 반환됩니다.
                /**
                 *	BitsoundReceiverDetectMicPermissionDenied, // mic. permission denied
                 *	BitsoundReceiverDetectAlreadyStarted, // 이미 실행중임(동시에 안됨)
                 *	BitsoundReceiverDetectNotInitialized, // SDK가 초기화 되지 않음
                 *  BitsoundReceiverInitCoreError, // core 모듈 에러
                 */
                
                self.showMessage(type: RMessageType.error, message: self.detectResultToMsg(result: detectResult))
                
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
    
    @IBAction func play(_ sender: Any?) {
        // play with beacon
        BitsoundPlayer.sharedInstance().play(withBeacon: 230, volume: -6)
    }
    
    @IBAction func stop(_ sender: Any?) {
        // stop
        BitsoundPlayer.sharedInstance().stop()
    }
    
    
    // MARK: - private
    func showMessage(type: RMessageType, message: String) {

        
        RMessage.showNotification(in: self.navigationController,
                            title: "Bitsound",
                            subtitle: message,
                            iconImage: nil,
                            type: type,
                            customTypeName: nil,
                            duration: 1.4,
                            callback: {
                
                            }, buttonTitle: nil, buttonCallback: {
            
                            }, at: RMessagePosition.top, canBeDismissedByUser: true)
        
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
            
        case .networkError:
            msg = "init network error"
            
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
            
            self.showMessage(type: RMessageType.success, message: self.resultForInitToMsg(result: initResult))
            
            
            // BitsoundShaking set delegate
            BitsoundShaking.sharedInstance().delegate = self
            
            // BitsoundShaking enable shake
            BitsoundShaking.sharedInstance().enableShake()
        } else {
            
            self.showMessage(type: RMessageType.error, message: self.resultForInitToMsg(result: initResult))
        }
        
        
    }
    
    
    // 고주파 수신 결과
    func receiverDidReceive(_ result: BitsoundReceiverResult, contents: BitsoundContentsModel?) {
        
        if result == .success {
            
            self.showMessage(type: RMessageType.success, message: self.resultToMsg(result: result))
            
            if let unwrappedUrlString = contents?.getStrValue("url"), let unwrappedName = contents?.name, let unwrappedComment = contents?.getStrValue("comment") {
                
                print("contents name : \(unwrappedName), comment : \(unwrappedComment)")
                
                
                if unwrappedUrlString.hasPrefix("http://") || unwrappedUrlString.hasPrefix("https://") {
                 
                    if #available(iOS 9.0, *) {
                        
                        let safariViewController = SFSafariViewController(url: URL(string: unwrappedUrlString)!)
                        self.present(safariViewController, animated: true, completion: {
                            
                        })
                    } else {
                        
                        UIApplication.shared.openURL(URL(string: unwrappedUrlString)!)
                    }
                }
            }
            
        } else {
            
            self.showMessage(type: RMessageType.error, message: self.resultToMsg(result: result))
        }
    }
    
    // start detect 되었다는 noti.
    func receiverDidStartDetect() {
        
        self.showMessage(type: RMessageType.normal, message: "did start detect")
    }
    
    // stop detect 되었다는 noti.
    func receiverDidStopDetect() {
        
        self.showMessage(type: RMessageType.normal, message: "did stop detect")
    }
    
}

// MARK: - BitsoundShakingDelegate
extension ViewController: BitsoundShakingDelegate {
    
    // shaking detect 되었다는 noti.
    func shakingDidDetect() {
        
        self.showMessage(type: RMessageType.normal, message: "shakingDidDetect")
        
        // shaking detect시 진동
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        
        
        // start detect with contents assistant
        // withContentsAssistant : true를 한 경우, 음파 수신 실패가 발생하면 광고 스케쥴을 조회한다.
        BitsoundReceiver.sharedInstance().startDetect(withContentsAssistant: false) { (detectResult: BitsoundReceiverDetectResult) in
            
            if detectResult == BitsoundReceiverDetectResult.success {
                
                // 신호 감지 시작 성공적.
                
                self.showMessage(type: RMessageType.success, message: self.detectResultToMsg(result: detectResult))
            } else {
                
                // 신호 감지 시작 실패시 아래와 같은 종류의 코드가 반환됩니다.
                /**
                 *	BitsoundReceiverDetectMicPermissionDenied, // mic. permission denied
                 *	BitsoundReceiverDetectAlreadyStarted, // 이미 실행중임(동시에 안됨)
                 *	BitsoundReceiverDetectNotInitialized, // SDK가 초기화 되지 않음
                 */
                
                self.showMessage(type: RMessageType.error, message: self.detectResultToMsg(result: detectResult))
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

// MARK: - BitsoundPlayerDelegate
extension ViewController: BitsoundPlayerDelegate {

    func playerDidStart() {
        self.showMessage(type: RMessageType.normal, message: "player did start")
    }
    
    func playerDidStop() {
        self.showMessage(type: RMessageType.normal, message: "player did stop")
    }
    
    func playWithError(_ error: Error?) {
        self.showMessage(type: RMessageType.error, message: "play with error : \(String(describing: error))")
    }
    
    func stopWithError(_ error: Error?) {
        self.showMessage(type: RMessageType.error, message: "stop with error : \(String(describing: error))")
    }
    
    func receiverWithAppKeyDidNotInitialize() {
        self.showMessage(type: RMessageType.error, message: "receiverWithAppKeyDidNotInitialize")
        // init BitsoundReceiver init with app key
        BitsoundReceiver.sharedInstance().initWithAppKey("6bcb0c2c-376d-4db7-93cb-4b978d3e9ff7")
    }
}
