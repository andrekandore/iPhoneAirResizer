iPhoneAirResizer
================

For Testing UI Layout on Multiple iPhone Sizes (on iPad)

1. Duplicate your iPhone target and convert it to a universal app, this duplicated target will be refered as "Host App" from here on...
2. Make sure you copy "Main_iPad.storyboard" to your iPhone project
3. Link your iPhone app with either the embedded framework or static lib (make sure to specify -Objc in your linker flags)
4. If you are using a XIB based root view controller, make sure to specify "Main nib file base name" in the Info.plist for the host app...
5. ...or if you are loading the XIB manually in the app delegate, check for the existence of UIWindow first, as the testing app will load a window automatically from storyboard when launching on iPad, so you can skip manuall initiailization in this case (this is probably the only source change you will need).
6. If you are already using storyboard for iPhone, simply make sure Main storyboard file base name (iPhone) is explicitly set. 
7. Set the "Main storyboard file base name (iPad)" in your host iPhone app to "Main_iPad"
8. In Main_iPad.storyboard, select "Testi PhoneUX View Controller" and open the inspector to "User Defined Runtime Attributes"
9. For XIB based iPhone apps, set "hostViewControllerNibName" as key and the name of your root xib file as value
10. For Storyboard based iPhone apps, set "hostViewControllerStoryboardName" as key, and the name of your root storyboard file as value
11. Launch your Host App on iPad / iPad Simulator, if your app is well-behaved, it should launch without crashing...

Most of the interesting code is in iPhoneAirResizer/iPhoneAirResizer/Public/APPTestiPhoneUXViewController.m

As always, make sure to see the sample app located in iPhoneAirResizerExample/TestiPhoneApp.xcworkspace for a working example!