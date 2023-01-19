//
//  LoginVIewModel.swift
//  MSG
//
//  Created by 전준수 on 2023/01/18.
//

import SwiftUI
import Firebase
import CryptoKit
import AuthenticationServices
import GoogleSignIn
import KakaoSDKAuth
import KakaoSDKUser
import FirebaseAuth

@MainActor
class LoginViewModel: ObservableObject {
    
    //MARK: Error Properties

    @Published var currentUserProfile: Msg? = nil
    @Published var showError: Bool = false
    @Published var errorMessege: String = ""
    @Published var currentUser = Auth.auth().currentUser
    // MARK: App Log Status
    @AppStorage("log_status") var logStatus: Bool = false
    
    // MARK: Apple Sign in Properties
    @Published var nonce: String = ""
    
    func signout(){
        do{
         
         try Auth.auth().signOut()
            currentUser = nil
            
        }catch{
            print("실패")
        }
        
    }
    
    // MARK: Handling Error
    func handleError(error: Error) async {
        
        await MainActor.run(body: {
            errorMessege = error.localizedDescription
            showError.toggle()
        })
    }
    
    // MARK: Apple Sign in API
    func appleAuthenticate(credential: ASAuthorizationAppleIDCredential) {
        
        // getting Token...
        guard let token = credential.identityToken else {
            print("error with firebase")
            return
        }
        
        // Token String...
        guard let tokenString = String(data: token, encoding: .utf8) else {
            print("error with Token")
            return
        }
        
        let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokenString, rawNonce: nonce)
    
        Auth.auth().signIn(with: firebaseCredential) { (result, err) in
            if let error = err {
                print(error.localizedDescription)
                return
            }
            self.currentUser = result?.user
            // User Successfully Logged Into Firebase...
            
            print("Logged In Success Apple")
            withAnimation(.easeInOut){self.logStatus = true}
        }
        
    }
    
    // MARK: Logging Google User into Firebase
    func logGoogleUser(user: GIDGoogleUser) {
        Task {
            do {
                guard let idToken = user.authentication.idToken else { return }
                let accesToken = user.authentication.accessToken
                
                
                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accesToken)
                
                try await Auth.auth().signIn(with: credential)
                self.currentUser = Auth.auth().currentUser
                print("Logged In Success Google")
                await MainActor.run(body: {
                    withAnimation(.easeInOut){self.logStatus = true}
                })
            } catch {
                await handleError(error: error)
            }
        }
    }
    
    
    // MARK: - [카카오 Auth]
    func kakaoLogout() async {
        UserApi.shared.logout {(error) in
            if let error{
                print("error: \(error)")
            }
            else {
                print("== 로그아웃 성공 ==")
                //self.logStatus = false
                try? Auth.auth().signOut()
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
                        print("signup failed")
                        print("error")
                        Auth.auth().signIn(withEmail: (user?.kakaoAccount?.email ?? "")!, password: "\(String(describing: user?.id))") { result, error in
                            self.currentUser = result?.user
                        }
                        print("email:",user?.kakaoAccount?.email ?? "")
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

// MARK: Extensions
extension UIApplication {
    func rootController() -> UIViewController {
        guard let window = connectedScenes.first as? UIWindowScene else {return .init()}
        guard let viewcontroller = window.windows.last?.rootViewController else {return .init()}
        
        return viewcontroller
    }
}

// MARK: Apple Sign in Helpers
func sha256(_ input: String) -> String {
  let inputData = Data(input.utf8)
  let hashedData = SHA256.hash(data: inputData)
  let hashString = hashedData.compactMap {
    return String(format: "%02x", $0)
  }.joined()

  return hashString
}

func randomNonceString(length: Int = 32) -> String {
  precondition(length > 0)
  let charset: Array<Character> =
      Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
  var result = ""
  var remainingLength = length

  while remainingLength > 0 {
    let randoms: [UInt8] = (0 ..< 16).map { _ in
      var random: UInt8 = 0
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
      if errorCode != errSecSuccess {
        fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
      }
      return random
    }

    randoms.forEach { random in
      if remainingLength == 0 {
        return
      }

      if random < charset.count {
        result.append(charset[Int(random)])
        remainingLength -= 1
      }
    }
  }

  return result
}


