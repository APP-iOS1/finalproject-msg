//
//  AppleContentView.swift
//  MSG
//
//  Created by 전준수 on 2023/01/18.
//

import SwiftUI

struct AppleContentView: View {
    @EnvironmentObject var appleUserAuth: AppleUserAuth
    
    var body: some View {
        NavigationStack {
            if !appleUserAuth.isLogged {
                AppleLoginView()
            } else {
                AppleTestView()
            }
        }
        
    }
}

struct AppleContentView_Previews: PreviewProvider {
    static var previews: some View {
        AppleContentView()
            .environmentObject(AppleUserAuth())
    }
}
