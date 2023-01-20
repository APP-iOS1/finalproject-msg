import SwiftUI
import FirebaseCore
import KakaoSDKCommon
import KakaoSDKAuth
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
}

@main
struct MSGApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    //    @UIApplicationDelegateAdaptor var kakaoAppDelegate: KakaoAppDelegate
    init() {
        let kakaoAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] ?? ""
        KakaoSDK.initSDK(appKey: kakaoAppKey as! String)
    }
    @StateObject var loginViewModel = LoginViewModel()
    @StateObject var viewModel = KakaoViewModel()
    @StateObject var fireStoreViewModel = FireStoreViewModel()
    @StateObject var realtimeViewModel = PostitStore()
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView().onOpenURL { url in
                    if AuthApi.isKakaoTalkLoginUrl(url) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                }
                .environmentObject(viewModel)
                .environmentObject(loginViewModel)
                .environmentObject(fireStoreViewModel)
                .environmentObject(realtimeViewModel)
            }
        }
    }
}
