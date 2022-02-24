//
//  ExtensionDelegate.swift
//  LifeStoneWatch Extension
//
//  Created by Wajih Invotyx on 10/02/2020.
//  Copyright © 2020 Invotyx. All rights reserved.
//

import WatchKit
import UserNotifications

class ExtensionDelegate: NSObject, WKExtensionDelegate {

  
        func applicationDidFinishLaunching() {
            // Perform any final initialization of your application.
            configureNotification()
            backgroundRefresher()
        }

        
        func applicationDidBecomeActive() {
            // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        }

        func applicationWillResignActive() {
            // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
            // Use this method to pause ongoing tasks, disable timers, etc.
        }

        func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>)
        {
            // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
            for task in backgroundTasks
            {
                // Use a switch statement to check the task type
                switch task
                {
                case let backgroundTask as WKApplicationRefreshBackgroundTask:
                    // Be sure to complete the background task once you’re done.
                    backgroundTask.setTaskCompletedWithSnapshot(false)
                case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                    // Snapshot tasks have a unique completion call, make sure to set your expiration date
                    snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
                case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                    // Be sure to complete the connectivity task once you’re done.
                    connectivityTask.setTaskCompletedWithSnapshot(false)
                case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                    // Be sure to complete the URL session task once you’re done.
                    urlSessionTask.setTaskCompletedWithSnapshot(false)
    //            case let relevantShortcutTask as WKRelevantShortcutRefreshBackgroundTask:
    //                // Be sure to complete the relevant-shortcut task once you're done.
    //                relevantShortcutTask.setTaskCompletedWithSnapshot(false)
    //            case let intentDidRunTask as WKIntentDidRunRefreshBackgroundTask:
    //                // Be sure to complete the intent-did-run task once you're done.
    //                intentDidRunTask.setTaskCompletedWithSnapshot(false)
                default:
                    // make sure to complete unhandled task types
                    task.setTaskCompletedWithSnapshot(false)
                }
            }
        }

    }
    extension ExtensionDelegate
    {
        func backgroundRefresher()
        {
            
            WKExtension.shared().scheduleSnapshotRefresh(withPreferredDate: Date(), userInfo: nil)
            { (error) in
                print("scheduleSnapshotRefresh")
            }
            
            WKExtension.shared().scheduleBackgroundRefresh(withPreferredDate: Date(), userInfo: nil)
            { (error) in
                print("scheduleBackgroundRefresh")
            }
        }
    }

    extension ExtensionDelegate: UNUserNotificationCenterDelegate {
        
        func configureNotification() {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
                if granted {
                    print("notification success")
                    
                    let obj = Notification_Handler()
                    obj.tiggerNoti()
                    
                } else {
                    print("notification failure")
                }
            }
        }
        
        func userNotificationCenter(_ center: UNUserNotificationCenter,
                                    willPresent notification: UNNotification,
                                    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            // Update the app interface directly.
            print("willPresentNotification")
            
            // Play a sound.
            completionHandler(UNNotificationPresentationOptions.sound)
        }
        
        func userNotificationCenter(_ center: UNUserNotificationCenter,
                                    didReceive response: UNNotificationResponse,
                                    withCompletionHandler completionHandler: @escaping () -> Void) {
            handleNotificationResponse(response: response)
        }
        
        func handleNotificationResponse(response: UNNotificationResponse) {
            // CustomCategory
            if response.notification.request.content.categoryIdentifier == "customCategoryIdentifier" {
                
                // 根据Action的ID区分
                if response.actionIdentifier == "KonwID" {
                    print("Konw Action")
                } else if response.actionIdentifier == "NotCareID" {
                    print("Don't Care Action")
                } else if response.actionIdentifier == "NotPushID" {
                    print("Don't Push Action")
                } else if response.actionIdentifier == UNNotificationDefaultActionIdentifier {
                    print("Default Action: Did Not Specify Custom ActionID")
                } else if response.actionIdentifier == UNNotificationDismissActionIdentifier {
                    print("Dismiss Action: Specify A Dismiss Action")
                } else {
                    
                }
            } else if response.notification.request.content.categoryIdentifier.isEmpty {
                // Default Category
            }
        }
        
    }
