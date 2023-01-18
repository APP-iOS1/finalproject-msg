//
//  UserAuth.swift
//  MSG
//
//  Created by 전준수 on 2023/01/18.
//

import Combine

class AppleUserAuth: ObservableObject {
    
    @Published var isLoggedIn: Bool = false
    @Published var userNicName: String = ""
    
    func login() {
        self.isLoggedIn = true
    }
}
