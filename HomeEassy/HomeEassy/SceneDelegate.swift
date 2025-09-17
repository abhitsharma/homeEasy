//
//  SceneDelegate.swift
//  HomeEassy
//
//  Created by Swatantra singh on 26/07/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var tabbarController: CLGTabBarViewController?
    var lanchScren:UIViewController!
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window=windowScene.windows.first
        tabbarController=window?.rootViewController as? CLGTabBarViewController
        _ = CartController.shared
        checkForConnectivity()
    }
    
    func checkForConnectivity() {
        if let splash = StoryBoardHelper.controller(.main, type: SplashScreenVC.self) {
            lanchScren = splash
                DispatchQueue.main.asyncAfter(deadline: .now()+2.5) { [weak self] in
                    self?.lanchScren?.view.removeFromSuperview()
            }
            tabbarController?.view.addSubview(splash.view)
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        persistentStorage.Shared.saveContext()
    }

    func openNewsDtls(_ newsId: String){
            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            if let nav=self.tabbarController?.viewControllers?.first as? UINavigationController,
               let home=nav.viewControllers.first as? HomeViewController {
                self.tabbarController?.selectedIndex = 0
                home.openNewsDetailsWithNewsID(newsId: newsId)
            }
            }
        }
}

