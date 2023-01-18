//
//  UserAuth.swift
//  MSG
//
//  Created by 전준수 on 2023/01/18.
//

import Combine

class AppleUserAuth: ObservableObject {
    
    @Published var isLogged: Bool = false
    
    func login() {
        self.isLogged = true
    }
}
