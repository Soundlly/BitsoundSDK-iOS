# BitsoundSDK-iOS
Bitsound iOS SDK repo.

If you are seeing an error like the following:

diff: /../Podfile.lock: No such file or directory 
diff: /Manifest.lock: No such file or directory 
error: The sandbox is not in sync with the Podfile.lock. Run 'pod install' or update your CocoaPods installation.

Then there's a problem with Cocoapods in your project.  Sometimes cocoapods can get out of sync and you need to re-initiate cocoapods. You should be able to resolve this error by:

Deleting the Podfile.lock file in your project folder
Deleting the Pods folder in your project folder
Execute 'pod install' in your project folder
Do a "Clean" in Xcode
Rebuild your project
