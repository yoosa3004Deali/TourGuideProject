//
//  SceneDelegate.swift
//  TourGuideProject
//
//  Created by hyunndy on 2020/07/07.
//  Copyright © 2020 hyunndy. All rights reserved.
//
//  delegate를 사용하여 일반적으로 모든 장면에 응답한다. 즉, 하나의 델리게이트를 정의하여 앱의 모든 scene에서 사용한다.
//

import UIKit
import ESTabBarController_swift
import KYDrawerController
import FirebaseCore

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        // 파이어베이스
        FirebaseApp.configure()
        
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        
        // 루트 뷰 컨트롤러가 될 뷰 컨트롤러를 생성한다.
        let tabBarVC = ESTabBarController()
        
        let vcTourSpot = TourSpotListViewController()
        let vcFestival = FestivalListViewController()
        let vcAccount = AccountViewController()
        
        vcTourSpot.tabBarItem.title = "관광지"
        vcFestival.tabBarItem.title = "행사"
        vcAccount.tabBarItem.title = "나의 계정"
        
        tabBarVC.viewControllers = [vcTourSpot,vcFestival,vcAccount]
        tabBarVC.tabBar.tintColor = UIColor.red
        
        vcTourSpot.tabBarItem.image = UIImage(named: "tour_guide.png")?.withRenderingMode(.alwaysOriginal)
        vcFestival.tabBarItem.image = UIImage(named: "festival.png")?.withRenderingMode(.alwaysOriginal)
        vcAccount.tabBarItem.image = UIImage(named: "user.png")?.withRenderingMode(.alwaysOriginal)
        
        // 위에서 생성한 뷰 컨트롤러로 내비게이션 컨트롤러를 생성한다.
        let navigationVC = UINavigationController(rootViewController: tabBarVC)
        
        let drawerViewController = DrawerViewController()
        let drawerController = KYDrawerController(drawerDirection: .left, drawerWidth: window?.frame.width ?? 0)
        drawerController.mainViewController = navigationVC
        drawerController.drawerViewController = drawerViewController
        
        // 윈도우의 루트 뷰 컨트롤러로 내비게이션 컨트롤러를 설정한다.
        window?.rootViewController = drawerController
        window?.makeKeyAndVisible()
    }
    
    // scene의 연결이 해제될 때 호출된다. 연결은 다시 연결될수도 있음
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    // app switcher에서 선택되는 등 scene과의 상호작용이 시작될 때 호출한다.
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    // 사용자가 scene과의 상호작용을 중지할 때 호출된다. (ex. 다른 화면으로의 전환)
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    // scene이 포그라운드로 진입할 때 호출된다.
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    // scene이 백그라운드로 진입할 때 호출된다.
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}

