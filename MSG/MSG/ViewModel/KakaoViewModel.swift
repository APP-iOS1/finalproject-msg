//
//  KakaoAuthViewModel.swift
//  MSG
//
//  Created by zooey on 2023/01/17.
//
import Foundation
import KakaoSDKAuth
import KakaoSDKUser
import FirebaseAuth
import Firebase
import FirebaseCore

@MainActor
class KakaoViewModel: ObservableObject{
    
    @Published var currentUser: Firebase.User?
    init() {
        currentUser = Auth.auth().currentUser
    }
    @Published var isLoggedIn: Bool = false
    @Published var userNicName: String = ""
    
    func kakaoLogout() async {
        UserApi.shared.logout {(error) in
            if let error{
                print("error: \(error)")
            }
            else {
                print("== 로그아웃 성공 ==")
                //self.logStatus = false
                try? Auth.auth().signOut()
                self.currentUser = nil
                self.isLoggedIn = false
            }
        }
    }
    
    func kakaoLoginWithApp() async {
        UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
            if let error = error {
                print(error)
            }
            else {
                print("loginWithKakaoTalk() success.")
                //do something
                //_ = oauthToken
                if let oauthToken = oauthToken {
                    print("DEBUG: 카카오톡 \(oauthToken)")
                    self.signUpInFirebase()
                }
            }
        }
    }
    
    // MARK: - 카카오 계정으로 로그인
    func kakaoLoginWithWeb() async {
        UserApi.shared.loginWithKakaoAccount {(token, error) in
            if let error = error {
                print(error)
            }
            else {
                print("웹 로그인 성공")
                if let token {
                    print("\(token)")
                    self.signUpInFirebase()
                }
            }
        }
    }
    
    func kakaoLogin() {
        Task{
            if (UserApi.isKakaoTalkLoginAvailable()) {
                await kakaoLoginWithApp()
            } else {
                await kakaoLoginWithWeb()
                
            }
        }
    }
    
    func handleKakaoLogout() async -> Bool{
        await withCheckedContinuation({ continuation in
            UserApi.shared.logout {(error) in
                if let error = error {
                    print(error)
                    continuation.resume(returning: false)
                }
                else {
                    print("logout() success.")
                    continuation.resume(returning: true)
                }
            }
        })
    }
    
    func signUpInFirebase() {
        UserApi.shared.me() { user, error in
            if let error = error {
                print("error: \(error.localizedDescription)")
            } else {
                // 파이어베이스 유저 생성
                Auth.auth().createUser(withEmail: (user?.kakaoAccount?.email ?? "")!, password: "\(String(describing: user?.id))") { result, error in
                    if let error = error {
                        print("유저가 이미 존재하는 아이디가 있어 로그인을 시도합니다")
                        print("\(error)")
                        Auth.auth().signIn(withEmail: (user?.kakaoAccount?.email ?? "")!, password: "\(String(describing: user?.id))",completion: nil)
                        print("email:",user?.kakaoAccount?.email ?? "")
                        self.isLoggedIn = true
                        print(self.isLoggedIn)
                    }else {
                        self.currentUser = result?.user
                    }
                    
                }
            }
        }
    }
    
    func unlinkKakao(){
        UserApi.shared.unlink {(error) in
            if let error = error {
                print(error)
            }
            else {
                print("unlink() success.")
            }
        }
    }
    
    // 로그인후 유저 정보 입력
    func inputUserInfo() {
        UserApi.shared.me() { user, error in
            if let error = error {
                print("유저 정보 에러 :\(error)")
            }
        }
    }
}


