//
//  ContentView.swift
//  MSG
//
//  Created by kimminho on 2023/01/17.
//
import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var loginViewModel: LoginViewModel
    @EnvironmentObject var kakaoAuthViewModel: KakaoViewModel
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var fireStoreViewModel: FireStoreViewModel
    @StateObject var realtimeViewModel = PostitStore()
    @State private var checked: Msg?
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
                    if loginViewModel.currentUser != nil {
                        if loginViewModel.currentUserProfile == nil {
                            withAnimation {
                                MakeProfileView()
                            }
                            
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
                // (1) -> 로그인 상태가 유지된 경우, 현재 curre
                .onAppear{
                    if loginViewModel.currentUser != nil {
                        Task{
                                loginViewModel.currentUserProfile = try await fireStoreViewModel.fetchUserInfo(_: loginViewModel.currentUser!.uid)
                        }
                    }
                }
                .onChange(of: loginViewModel.currentUser) { user in
                    if let user {
                        Task{
                            loginViewModel.currentUserProfile  = try await fireStoreViewModel.fetchUserInfo(_: user.uid)
                        }
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

struct ContentView_Previews: PreviewProvider {
    static let kakaoAuthViewModel = KakaoViewModel()
    static let fireStoreViewModel = FireStoreViewModel()
    static let realtimeViewModel = PostitStore()
    
    static var previews: some View {
        ContentView()
            .environmentObject(kakaoAuthViewModel)
            .environmentObject(fireStoreViewModel)
            .environmentObject(realtimeViewModel)
    }
}
