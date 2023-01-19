//
//  SystemThemeManager.swift
//  MSG
//
//  Created by zooey on 2023/01/18.
//

import Foundation
import UIKit

final class SystemThemeManager {
    
    static let shared = SystemThemeManager()
    
    private init() {}
    
    func handleTheme(darkMode: Bool) {
        
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        let window = windowScenes?.windows.first
        
       window?.overrideUserInterfaceStyle = darkMode ? .dark : .light
    }
}
