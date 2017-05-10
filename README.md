# BitsoundSDK-iOS

[![N|Bitsound](https://daks2k3a4ib2z.cloudfront.net/580f2a6962cf032f7b75c078/5812f9cb4c0e119f5c2d04b6_overview_reduced-p-800x487.png)](http://bitsound.io/)

Bitsound iOS SDK는 비가청 음파를 수신하고, decoding하여 beacon 정보를 가져온다. 해당 beacon으로 등록된 컨텐츠 정보를 조회한다.
또한 shaking 감지 기능을 제공하여, shaking이 감지되면 음파를 수신하는 방식을 사용할 수 있다.
두 개의 framework이 존재하며 BitsoundReceiver.framework은 비가청 음파를 수신하는 기능을, BitsoundShaking.framework은 shaking 감지 기능을 제공한다. [Bitsound Documentation](https://docs.bitsound.io/v1.0/docs/introduction)

  - 비가청 음파 수신 
  - 음파 데이타 decoding하여, beacon 정보 조회
  - beacon으로 동록된, 컨텐츠 정보 조회하여 전달
  - shaking 감지 기능

You can also:
  - 광고 스케쥴 조회하여, 광고 컨텐츠 전달
  - 스케쥴 체크하여 동작하는 기능
  - Custom 로그 전송

> Sample project는 pod install or pod update를 실행한 후 빌드해주세요.

## Requirements
iOS Deployment Target 7.0+, Xcode 7+

## Installation

install은 cocoapods과, manual한 방식을 지원한다.

### Installation with CocoaPods
이미 CocoaPods이 설치되어 있다면, Podfile의 target..do..end block에 pod 'BitsoundReceiver', pod 'BitsoundShaking' 항목을 추가합니다.

Podfile
```sh
target '<your_project_target>' do
  pod 'BitsoundReceiver'
  pod 'BitsoundShaking'
end
```

pod install 또는 pod update 명령어를 실행하여 설치합니다.

```sh
$ pod install --verbose OR
$ pod update --verbose
```
Cocoapods이 설치되어 있지 않다면, 다음의 가이드(https://guides.cocoapods.org/using/getting-started.html#getting-started)를 통해 설치한 후, 위의 항목을 실행합니다.

### Installation Manual

1. App.의 Xcode Project를 오픈합니다.
2. BitsoundReceiver.framework, BitsoundShaking.framework 파일을 Xcode의 Project Navigator의 Frameworks 그룹으로 drag하여 추가합니다.(Frameworks 그룹이 없으면, 생성한 후 추가합니다.) 표시된 대화 상자에서 Create groups을 선택하고, Copy items if needed 선택하지 않습니다.(기본 설정)
3. Project에서 Xcode의 Build Settings 탭을 오픈하여, Framework Search Paths 설정에 BitsoundReceiver.framework, BitsoundShaking.framework 파일의 경로를 추가합니다. (이미 추가되어 있으면, 추가하지 않아도 됩니다.)
4. iOS frameworks 추가
. libstdc++.tbd
5. Project에서 Xcode의 Build Settings 탭을 오픈하여, Other Linker Flags 설정에 -all_load 또는 -ObjC를 추가합니다.

## Configuraion
> iOS 10 변경 사항
> 기존의 optional이던 NSMicrophoneUsageDescription이 iOS 10으로 업데이트 되면서 필수 항목으로 변경되었습니다. 이 내용은 mic. permission alert 창 노출시 보여지는 문구입니다.

> Xcode에서 Project의 .plist 파일을 보조 클릭하고 Open As -> Source Code를 선택하여, 다음의 XML 코드를 추가합니다.
> ```sh
> <?xml version="1.0" encoding="UTF-8"?>
> <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
> <plist version="1.0">
> <dict>
>  .
>  .
>  <key>NSMicrophoneUsageDescription</key>
>  <string>광고 속 혜택 제공 기능(고주파 서비스)에 사용 됩니다.</string>
>  .
>  .
> </dict>
> </plist>
> ```

## Usage
### init with app key
```sh
// init
[[BitsoundReceiver sharedInstance] initWithAppKey:@"your_app_key"];
// set delegate
[BitsoundReceiver sharedInstance].delegate = self;
```
### enable shaking
```sh
#pragma mark - BitsoundReceiverDelegate
- (void)receiverDidReceiveInitResult:(BitsoundReceiverInitResult)initResult error:(NSError *)error {
    if (initResult == BitsoundReceiverInitSuccess) {
        // init이 성공이면, startDetect가 가능합니다. startDetect 또는 enableShake + startDetect를 통해 신호를 감지합니다.
        // set delegate
        [BitsoundShaking sharedInstance].delegate = self;
        // enable shaking
        [[BitsoundShaking sharedInstance] enableShake];
    }
}
```
### start detect with contents assistant
```sh
#pragma mark - BitsoundShakingDelegate
- (void)shakingDidDetect {
    // 사용자에게 진동을 통해, shaking 되었다는것을 알려줍니다.
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    // start detect with contents assistant -> YES : 음파 수신 실패하면, 광고 컨텐츠 조회, NO : 음파 수신 시도하고 종료
    [[BitsoundReceiver sharedInstance] startDetectWithContentsAssistant:NO detectResult:^(BitsoundReceiverDetectResult result) {
        if (result == BitsoundReceiverSuccess) {
            // 신호 감지 시작 성공적.
        } else {
            // 신호 감지 시작 실패시 아래와 같은 종류의 코드가 반환됩니다.
            /**
             *	BitsoundReceiverDetectMicPermissionDenied, // mic. permission denied
             *	BitsoundReceiverDetectAlreadyStarted, // 이미 실행중임(동시에 안됨)
             *	BitsoundReceiverDetectNotInitialized, // SDK가 초기화 되지 않음
             */
        }
    }];
}
```
### receiver did reeceive result
```sh
#pragma mark - BitsoundReceiverDelegate
- (void)receiverDidReceiveResult:(BitsoundReceiverResult)result contents:(BitsoundContentsModel *)contents {
    if (result == BitsoundReceiverSuccess) {
        if (NSClassFromString(@"SFSafariViewController")) {
            SFSafariViewController *safariViewController = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString: [contents getStrValue:@"url"]]];
            [self presentViewController:safariViewController animated:YES completion:^{
            }];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: [[contents getStrValue:@"url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        }
    }
}
```
License
----

Commercial
