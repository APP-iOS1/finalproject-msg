//
//  ContentView.swift
//  MSG
//
//  Created by kimminho on 2023/01/17.
//
import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var kakaoAuthViewModel: KakaoViewModel
    @Environment(\.colorScheme) var colorScheme
    @StateObject var fireStoreViewModel = FireStoreViewModel()
    var body: some View {
        ZStack {
            Color("Background")
            NavigationStack {
                Group {
                    if kakaoAuthViewModel.isLoggedIn {
                        if kakaoAuthViewModel.userNicName.isEmpty {
                            MakeProfileView()
                        } else {
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
                            }
                        }
                    } else {
                        LoginView()
                    }
                }
            }
            .accentColor(Color("Font"))
        }.task {
//            try! await fireStoreViewModel.getGameHistory()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
