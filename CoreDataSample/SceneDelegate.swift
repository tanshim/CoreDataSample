//
//  SceneDelegate.swift
//  CoreDataSample
//
//  Created by Sultan on 24.09.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let viewController = ViewController()
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }

    func changeViewController(viewController: UIViewController, animated: Bool = true, animationOptions: UIView.AnimationOptions) {
        guard let window = window else { return }

        window.rootViewController = viewController
        let options: UIView.AnimationOptions = [animationOptions]

        UIView.transition(with: window,
                          duration: 0.5,
                          options: options,
                          animations: nil,
                          completion: nil)
    }

}
