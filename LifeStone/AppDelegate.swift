//
//  AppDelegate.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 04/07/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//
internal let kMapsAPIKey = "AIzaSyBBereZkX2xb8F5VuLfnETjxrWe_qcuhpo"

import UIKit
import CoreData
import GoogleSignIn
import FBSDKCoreKit
//import TwitterKit
//import TwitterCore
import Stripe
import OneSignal
import SwiftyJSON
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {

    var window: UIWindow?
    static var NotificationCount = -1
    static var firsTime = ""
    static var baseurl = "https://app.yourlifestone.com/"
    static var personalInfo = UserInfo()
    static var linecolor = #colorLiteral(red: 0.3921568627, green: 0.7294117647, blue: 0.8352941176, alpha: 1)
    static var devToken = ""
    static var oneSignalToken = ""
    static var notiOrderId = ""
   
    //219AD3
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        
        // Override point for customization after application launch.
//        GIDSignIn.sharedInstance().clientID = "417670616800-ucreuar5go0fqob4rsbg5c2pev61su5e.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().clientID = "417670616800-j8ij7pi7675rcnn4o6jahue8hu2uc5gp.apps.googleusercontent.com"
        GMSPlacesClient.provideAPIKey("AIzaSyDmmF5juY_4UfJtQpygtUIyHjrV9WO2D_s")
        GMSServices.provideAPIKey("AIzaSyDmmF5juY_4UfJtQpygtUIyHjrV9WO2D_s")
        
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //////////Stripe /////////////
        STPPaymentConfiguration.shared().publishableKey = "pk_test_Fj4NX0iQpkKkC7NQTKLoIIBy"
        STPPaymentConfiguration.shared().appleMerchantIdentifier = "your apple merchant identifier"
        
//        TWTRTwitter.sharedInstance().start(withConsumerKey:"zDzrbI5k8Ef68ERaSswzpnFHP", consumerSecret:"rUmxAazf3T3wBj0FEwMaYW169EcJN3BLKcXTDvg2Di7tKQkzvP")
//
//        ////////// Google maps ////
//        GMSPlacesClient.provideAPIKey(kMapsAPIKey)
//        GMSServices.provideAPIKey(kMapsAPIKey)
        self.refresh(launchOptions: launchOptions)
        
//         UserDefaults.standard.set(-1, forKey: "NotificationCount")
        
       updateRootView()
        return true
    }
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
      withError error: NSError!) {
        if (error == nil) {
          // Perform any operations on signed in user here.
          // ...
        } else {
          print("\(error.localizedDescription)")
        }
    }
    
    public func refresh(launchOptions:[UIApplication.LaunchOptionsKey : Any]?)  {
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
        
        // Replace 'YOUR_APP_ID' with your OneSignal App ID.
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: "24514e80-e551-4de8-8a2a-e7284c735f5b",
                                        handleNotificationAction: nil,
                                        settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        
        // Recommend moving the below line to prompt for push after informing the user about
        //   how your app will use them.
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
        
        
        // [END set_messaging_delegate]
        // Register for remote notifications. This shows a permission dialog on first run, to
        // show the dialog at a more appropriate time move this registration accordingly.
        // [START register_for_notifications]
        if #available(iOS 11.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_,_ in })
        }
        else
        {
            
        }
        
        UIApplication.shared.registerForRemoteNotifications()
        
        // [END register_for_notifications]
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "LifeStone")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
  ///////////////////// FB integration  functions /////////////////
extension AppDelegate{
    private func application1(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let appId: String = Settings.appID!
        if url.scheme != nil && url.scheme!.hasPrefix("fb\(appId)") && url.host ==  "authorize" {
            return ApplicationDelegate.shared.application(app, open: url, options: options)
        }
        return false
    }
}



extension AppDelegate{


    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {

        let googleDidHandle = GIDSignIn.sharedInstance()!.handle(url as URL?)
//        ,
//        sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
//        annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        
        var facebookDidHandle: Bool = false
        let appId: String = Settings.appID!
        if url.scheme != nil && url.scheme!.hasPrefix("fb\(appId)") && url.host ==  "authorize" {
            facebookDidHandle = ApplicationDelegate.shared.application(app, open: url, options: options)
        }
        
//        var valueTwitter: Bool = true
//        valueTwitter =  TWTRTwitter.sharedInstance().application(app, open: url, options: options)
        
        return googleDidHandle ||  facebookDidHandle// || valueTwitter //googleDidHandle ||
    }
    
    private func application(application: UIApplication,
                             openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        let _: [String: AnyObject] = [UIApplication.OpenURLOptionsKey.sourceApplication.rawValue: sourceApplication as AnyObject,
                                            UIApplication.OpenURLOptionsKey.annotation.rawValue: annotation!]
        return GIDSignIn.sharedInstance().handle(url as URL)
//        ,
//        sourceApplication: sourceApplication,
//        annotation: annotation
    }
    
    func application(_ application: UIApplication, shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplication.ExtensionPointIdentifier) -> Bool {
        if (extensionPointIdentifier == UIApplication.ExtensionPointIdentifier.keyboard) {
            return false
        }
        return true
    }
    
//    func application(_ application: UIApplication,
//                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//        var handle: Bool = true
//        let options: [String: AnyObject] = [UIApplication.OpenURLOptionsKey.sourceApplication.rawValue: sourceApplication as AnyObject, UIApplication.OpenURLOptionsKey.annotation.rawValue: annotation as AnyObject]
//        handle = TWTRTwitter.sharedInstance().application(application, open: url, options: options)
//        return handle
//    }
    
}



///////////////// for remote notification service /////////////

extension AppDelegate{
    
    //    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    //
    //    }
    
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        
        // Print full message.
        print(userInfo)
        let dic = JSON(userInfo)
        AppDelegate.notiOrderId = dic["custom"]["a"]["order_id"].stringValue
        completionHandler(UIBackgroundFetchResult.newData)
        
    }
    
    // [END receive_message]
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        AppDelegate.devToken = "\(deviceToken.hexString)"
        print(AppDelegate.oneSignalToken)
        print(AppDelegate.devToken)
        
    }
    
    static func returnImg(imgString:String) -> String
    {
        if imgString.contains("https://app.yourlifestone.com/images/lifestones/")
        {
            return imgString
        }
        else
        {
            var img = "https://app.yourlifestone.com/images/lifestones/\(imgString)"
            return img
        }
    }
    
}


