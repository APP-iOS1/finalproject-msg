//
//  ContentView.swift
//  MSG
//
//  Created by kimminho on 2023/01/17.
//

//.font(.custom("MaplestoryOTFLight", size: 30))
//.font(.custom("MaplestoryOTFBold", size: 30))
import SwiftUI

struct ContentView: View {
    //** 코어데이터 -> 로그인 처리 **
    @EnvironmentObject var loginViewModel: LoginViewModel
    @EnvironmentObject var kakaoAuthViewModel: KakaoViewModel
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var fireStoreViewModel: FireStoreViewModel
    @EnvironmentObject var realtimeViewModel: RealtimeViewModel
    @EnvironmentObject var notiManager: NotificationManager
    @State private var checked: Msg?
    @AppStorage("DarkModeEnabled") private var darkModeEnabled: Bool = false
    @State var email: String = ""
    @State private var selectedTabBar: SelectedTab = .first
    @State var labelNumber = 10
    // 탭바
//    init() {
//        UITabBar.appearance().shadowImage = UIImage()
//        UITabBar.appearance().backgroundImage = UIImage()
//        UITabBar.appearance().isTranslucent = true
//        UITabBar.appearance().backgroundColor = UIColor(Color("Background"))
//    }
    
    var body: some View {
       
        GeometryReader { g in
            ZStack {
                Color("Color1")
                    .ignoresSafeArea()
                NavigationStack {
                    Group {
                        if loginViewModel.currentUser != nil {
                            if loginViewModel.currentUserProfile == nil {
                                withAnimation {
                                    MakeProfileView()
                                    // MakeProfileView를 지연 시킴
                                        .deferredRendering(for: 0.5)
                                }
                            } else {
                                VStack(spacing: 0) {
                                    switch selectedTabBar {
                                    case .first:
                                        HomeView()
                                            .onAppear{
                                                Task{
                                                    try? await notiManager.requestAuthorization()
                                                }
                                            }
                                    case .second:
                                        ChallengeRecordView()
                                    case .third:
                                        FriendSettingView()
                                    case .fourth:
                                        SettingView(darkModeEnabled: $darkModeEnabled)
                                    }
                                    TabBarView(selectedTabBar: $selectedTabBar, number: $realtimeViewModel.labelNumber)
                                        .frame(width: g.size.width, height: g.size.height / 10)
                                }
                                .onAppear {
                                    realtimeViewModel.myInfo = loginViewModel.currentUserProfile
                                }
                            }
                        } else {
                            LoginView()
                            
                        }
                    }
                    .ignoresSafeArea(.keyboard)
                    .onAppear{
                        if loginViewModel.currentUser != nil {
                            Task{
                                loginViewModel.currentUserProfile = try await fireStoreViewModel.fetchUserInfo(_: loginViewModel.currentUser!.uid)
                            }
                        }
                    }
                }
                .accentColor(Color("Color2"))
            }
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
    static let realtimeViewModel = RealtimeViewModel()
    
    static var previews: some View {
        ContentView()
            .environmentObject(kakaoAuthViewModel)
            .environmentObject(fireStoreViewModel)
            .environmentObject(realtimeViewModel)
            .environmentObject(NotificationManager())
    }
}


// MARK: 123번 ~ 161번 지연 시키는 ViewModifier
private struct DeferredViewModifier: ViewModifier {
    
    // MARK: API
    
    let threshold: Double
    
    // MARK: - ViewModifier
    
    func body(content: Content) -> some View {
        _content(content)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + threshold) {
                    self.shouldRender = true
                }
            }
    }
    
    // MARK: - Private
    
    @ViewBuilder
    private func _content(_ content: Content) -> some View {
        if shouldRender {
            content
        } else {
            content
                .hidden()
        }
    }
    
    @State
    private var shouldRender = false
}

extension View {
    func deferredRendering(for seconds: Double) -> some View {
        modifier(DeferredViewModifier(threshold: seconds))
    }
}
