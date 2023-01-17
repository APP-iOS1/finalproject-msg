//
//  KakaoAppDelegate.swift
//  MSG
//
//  Created by zooey on 2023/01/17.
//

import Foundation
import UIKit
import KakaoSDKCommon
import KakaoSDKAuth

class KakaoAppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        let kakaoAppkey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] ?? ""
        
        // Kakao SDK 초기화
        KakaoSDK.initSDK(appKey: kakaoAppkey as! String)
        
        print("kakaoAppKey: \(kakaoAppkey)")
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.handleOpenUrl(url: url)
        }
        
        return false
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        let sceneConfiguration = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        
        sceneConfiguration.delegateClass = KakaoSceneDelegate.self
        
        return sceneConfiguration
    }
}
