//
//  AppDelegate.swift
//  Zeat-diner
//
//  Created by Kumaresan Sankaranarayanan on 11/16/16.
//  Copyright © 2016 Zeat. All rights reserved.
//

import UIKit
import UserNotifications
//import Firebase
//import FirebaseInstanceID
//import FirebaseMessaging
import GooglePlaces
import AWSCognitoIdentityProvider
import AWSSNS
//import NVActivityIndicatorView

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var pool: AWSCognitoIdentityUserPool?
    var signInViewController: AWSLoginViewController?
    var navigationController: UINavigationController?
    var storyboard: UIStoryboard?
//    var cartView: UIView?
    
    let SNSPlatformApplicationArn = "SNSPlatformArn""
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // [START register_for_notifications]
        if #available(iOS 10.0, *) {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        
        var keySuccess = GMSPlacesClient.provideAPIKey("GMSApiKey")
        
        // Initialize NVActivityIndicator
        ZeatUtility.setupActivityIndicator()
        
        // AWS Cognito Setup
        AWSDDLog.sharedInstance.logLevel = .verbose

        self.storyboard = UIStoryboard(name: "AWSRegistration", bundle: nil)

        let serviceConfiguration = AWSServiceConfiguration(region: CognitoIdentityUserPoolRegion, credentialsProvider: nil)
        AWSServiceManager.default().defaultServiceConfiguration = serviceConfiguration
        
        let poolConfiguration = AWSCognitoIdentityUserPoolConfiguration(clientId: CognitoIdentityUserAppClientId, clientSecret: nil, poolId: CognitoIdentityUserPoolId)
        AWSCognitoIdentityUserPool.register(with: serviceConfiguration, userPoolConfiguration: poolConfiguration, forKey: AWSCognitoUserPoolsSigninProviderKey)
        pool = AWSCognitoIdentityUserPool(forKey: AWSCognitoUserPoolsSigninProviderKey)
        pool?.delegate = self

        if let user = pool?.currentUser() {
            if user.isSignedIn {
                
                let mainViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
                self.window?.rootViewController = mainViewController
                self.window?.makeKeyAndVisible()
                
            }
        }
        
        return true

        // Check if user is logged in. If yes, take them to

//        ZeatSharedData.sharedInstance.initializeSharedInstance()

    }

    
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // Print message ID.
//        print("Message ID: \(userInfo["gcm.message_id"]!)")
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // Print message ID.
//        print("Message ID: \(userInfo["gcm.message_id"]!)")
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    

    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the InstanceID token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")

        let deviceTokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("deviceTokenString : \(deviceTokenString)")
//        ZeatSharedData.sharedInstance.createSNSEndPointArn(apnsDeviceToken: deviceTokenString)

    }
    
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        ZeatSharedData.sharedInstance.saveToUserDefaults()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        ZeatSharedData.sharedInstance.saveToUserDefaults()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

        // Get User Details if he is in any active order. This will be used to make sure that the user is put back
        // in correct state when the

//        Messaging.messaging().shouldEstablishDirectChannel = true
//        ZeatSharedData.sharedInstance.initializeSharedInstance()

        //                ZeatUtility.getDinerActiveOrder() { order in
        //                    guard let tabBarController  = self.window?.rootViewController as? UITabBarController else {
        //                        return
        //                    }
        //
        //                    guard let tabBarViewController = tabBarController.selectedViewController as? ZeatTabBarViewController else {
        //                        return
        //                    }
        //
        //                    if(order != nil) {
        //                        tabBarViewController.showCurrentOrderView()
        //                    } else {
        //                        tabBarViewController.hideCurrentOrderView()
        //                    }
        //                }

        
        if let user = pool?.currentUser() {
            if user.isSignedIn {
//                let _ = ZeatUtility.getDinerActiveOrder()
            }
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        let userInfo = notification.request.content.userInfo
        // Print message ID.
//        print("Message ID: \(userInfo["gcm.message_id"]!)")
        // Print full message.
//        print(userInfo)
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        print("Message ID: \(userInfo["gcm.message_id"]!)")
        // Print full message.
        print(userInfo)
    }
}

extension AppDelegate: AWSCognitoIdentityInteractiveAuthenticationDelegate {

    func startPasswordAuthentication() -> AWSCognitoIdentityPasswordAuthentication {


        if (self.signInViewController == nil) {
            self.signInViewController = storyboard?.instantiateViewController(withIdentifier: "loginController") as? AWSLoginViewController
        }

        DispatchQueue.main.async {
            self.window?.rootViewController = self.signInViewController
            self.window?.makeKeyAndVisible()
        }
        return self.signInViewController!
    }
    
}

