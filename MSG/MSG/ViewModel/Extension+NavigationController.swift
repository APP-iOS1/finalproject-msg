//
//  Extension+NavigationController.swift
//  MSG
//
//  Created by zooey on 2023/01/18.
//

import Foundation
import UIKit

extension UINavigationController {

  open override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    navigationBar.topItem?.backButtonDisplayMode = .minimal
  }

}
