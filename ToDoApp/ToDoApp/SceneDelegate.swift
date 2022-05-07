//
//  SceneDelegate.swift
//  ToDoApp
//
//  Created by Виктор Куля on 01.05.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let navigationVC = UINavigationController(rootViewController: CategoryViewController())
        navigationVC.modalPresentationStyle = .fullScreen
        window.rootViewController = navigationVC
        window.makeKeyAndVisible()
        self.window = window
        
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        print("sceneDidEnterBackground")
    }
    
}

