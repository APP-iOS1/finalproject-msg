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
    @EnvironmentObject var fireStoreViewModel: FireStoreViewModel
    @StateObject var realtimeViewModel = PostitStore()
    @AppStorage("DarkModeEnabled") private var darkModeEnabled: Bool = false
    
    // 탭바
    init() {
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().isTranslucent = true
        UITabBar.appearance().backgroundColor = UIColor(Color("Background"))
    }

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
                                HomeView(darkModeEnabled: $darkModeEnabled)
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
        .onAppear {
            SystemThemeManager
                .shared
                .handleTheme(darkMode: darkModeEnabled)
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
