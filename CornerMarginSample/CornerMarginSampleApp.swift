//
//  CornerMarginSampleApp.swift
//  CornerMarginSample
//
//  Created by juniperphoton on 9/28/25.
//

import SwiftUI

class UISceneDelegation: NSObject, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(
                rootView: ContentView().injectSafeAreaInsetsDetector()
            )
            window.makeKeyAndVisible()
            self.window = window
        }
    }
    
    func preferredWindowingControlStyle(
        for windowScene: UIWindowScene
    ) -> UIWindowScene.WindowingControlStyle {
        .automatic
    }
}

@main
class UIAppDelegataion: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfig.delegateClass = UISceneDelegation.self
        return sceneConfig
    }
}

struct CornerMarginSampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .injectSafeAreaInsetsDetector()
        }
    }
}
