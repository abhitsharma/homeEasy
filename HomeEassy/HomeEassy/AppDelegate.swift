//
//  AppDelegate.swift
//  HomeEassy
//
//  Created by Swatantra singh on 26/07/23.
//

import UIKit
import CoreData
import Firebase
import FirebaseMessaging
import UserNotifications
let kStoreAPIURL = "kAPIURL"
enum  TabTypes : Int {
  //case home = 0 ,wishlist=1, wishlist = 4, cart = 3, account = 2
  case home = 0 , categories = 1, account = 2,wishlist = 3,cart = 4
}
@main
class AppDelegate: UIResponder, UIApplicationDelegate ,MessagingDelegate,UNUserNotificationCenterDelegate{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        _ = CartController.shared
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options:[.alert,.sound,.badge]){ success,_ in
            guard success else{
                return
            }
           print("Success in Apns Registry")
        }
        application.registerForRemoteNotifications()
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: AppColor.appNormalColor], for: .normal)
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -6)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: AppColor.appNormalColor], for: .selected)
        UITableView.appearance().showsVerticalScrollIndicator = false
        UITableView.appearance().showsHorizontalScrollIndicator = false
        return true
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
       
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let application = UIApplication.shared
        if(application.applicationState == .active){
            print("user tapped the notification bar when the app is in foreground")
        }
        if(application.applicationState == .inactive)
        {
            print("user tapped the notification bar when the app is in background")
        }
        
        print("got active scene")
        let res = response.notification.request.content.body
        AppHelper.sceneDelegate.openNewsDtls(res)
        completionHandler()
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        messaging.token(){token ,_ in
            guard let token = token else{
                return
            }
            print("Token:\(token)")
        }
    }
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "HomeEassy")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
        
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
   
    func saveContext () {
       let   context = persistentContainer.viewContext
               if context.hasChanges {
            do {
                try context.save()
            } catch {
               
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        CLGLog.debug("deviceToken: \(token)")
        Messaging.messaging().apnsToken = deviceToken
        //AppHelper.saveToUserDefaults(value: token, withKey: CacheKey.KEY_DEVICETOKEN)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
    }
        
    func openNotificationInformation (remoteNotification:[AnyHashable: Any]) {
        CLGLog.debug(remoteNotification)
        let res = remoteNotification["Collection"]
        //AppHelper.sceneDelegate.openNewsDtls(res)
        UIApplication.shared.applicationIconBadgeNumber = 0
//        if let type = remoteNotification[Constants.notifictaionType] as? String,
//           let newsId = remoteNotification[Constants.notifictaionID] as? String,
//           type == Constants.notifictaionNews {
//            AppHelper.sceneDelegate.openNewsDtls(newsId)
//        }
    }
    
   
    func application(_ application: UIApplication, handleActionWithIdentifier identifier:
                        String?, forRemoteNotification userInfo: [AnyHashable : Any], withResponseInfo
                            responseInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        self.openNotificationInformation(remoteNotification: userInfo as! [String : AnyObject])
        
    }
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([])
    }
}
