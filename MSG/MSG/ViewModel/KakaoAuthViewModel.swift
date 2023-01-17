//
//  KakaoAuthViewModel.swift
//  MSG
//
//  Created by zooey on 2023/01/17.
//

import Foundation
import KakaoSDKAuth
import KakaoSDKUser

@MainActor
class KakaoAuthViewModel: ObservableObject {
    
    @Published var isLoggedIn: Bool = false
    
    func kakaoLogin() {
        Task {
            if (UserApi.isKakaoTalkLoginAvailable()) {
                isLoggedIn = await handleLoginWithKakaoTalkApp()
            } else {
                isLoggedIn = await handleWithKakaoAccountLogin()
            }
        }
    }
    
    func kakaoLogout() {
        Task {
            if await handleKakaoLogout() {
                isLoggedIn = false
            }
        }
    }
    
    // MARK: 카카오앱으로 로그인
    func handleLoginWithKakaoTalkApp() async -> Bool {
        await withCheckedContinuation({ continuation in
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                if let error = error {
                    print(error)
                    continuation.resume(returning: false)
                } else {
                    print("loginWithKakaoTalk() Success.")
                    _ = oauthToken
                    continuation.resume(returning: true)
                }
            }
        })
    }
    
    // MARK: 카카오 웹뷰로 로그인
    func handleWithKakaoAccountLogin() async -> Bool {
        await withCheckedContinuation({ continuation in
            UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                if let error = error {
                    print(error)
                    continuation.resume(returning: false)
                } else {
                    print("loginWithKakaoAccount() success.")
                    _ = oauthToken
                    continuation.resume(returning: true)
                }
            }
        })
    }
    
    // MARK: 로그아웃
    func handleKakaoLogout() async -> Bool {
        await withCheckedContinuation({ continueation in
            UserApi.shared.logout { error in
                if let error = error {
                    print(error)
                    continueation.resume(returning: false)
                } else {
                    print("logout() success.")
                    continueation.resume(returning: true)
                }
            }
        })
    }
}
