//
//  Utils.swift
//  MSG
//
//  Created by sehooon on 2023/01/27.
//

import Foundation
import UIKit

func getRootView() -> UIViewController?{
    guard let firstScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
        return nil
    }

    guard let firstWindow = firstScene.windows.first else {
        return nil
    }

   return firstWindow.rootViewController
}
