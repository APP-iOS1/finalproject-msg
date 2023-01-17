//
//  ContentView.swift
//  MSG
//
//  Created by kimminho on 2023/01/17.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        
        ZStack {
            Color("Background")
            
            TabView {
                LoginView()
                    .tabItem {
                        Image(systemName: "dpad.fill")
                    }
                PrivacyPolicyView()
                    .tabItem {
                        Image(systemName: "archivebox")
                    }
                MakeProfileView()
                    .tabItem {
                        Image(systemName: "person.2.fill")
                    }
                LoginView()
                    .tabItem {
                        Image(systemName: "ellipsis.bubble.fill")
                    }
            }
            .foregroundColor(Color("Font"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
