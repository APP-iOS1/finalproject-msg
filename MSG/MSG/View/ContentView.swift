//
//  ContentView.swift
//  MSG
//
//  Created by kimminho on 2023/01/17.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Background")
                
                TabView {
                    HomeView()
                        .tabItem {
                            Image(systemName: "dpad.fill")
                        }
                    ChallengeRecordView()
                        .tabItem {
                            Image(systemName: "archivebox")
                        }
                    FriendSettingView()
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
