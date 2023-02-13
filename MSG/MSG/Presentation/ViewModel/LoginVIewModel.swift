//
//  LoginVIewModel.swift
//  MSG
//
//  Created by 전준수 on 2023/01/18.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import CryptoKit
import AuthenticationServices
import GoogleSignIn
import KakaoSDKAuth
import KakaoSDKUser
import FirebaseAuth

enum LoginType: String {
    case Apple = "Apple"
    case Google = "Google"
    case Kakao = "Kakao"
    
    case none = "None" //기존에 쓰고있던 유저들은 그냥 버튼3개다보임
}


@MainActor
class LoginViewModel: ObservableObject {
    
    //MARK: Error Properties
    @Published var currentUserProfile: Msg? = nil
    @Published var showError: Bool = false
    @Published var errorMessege: String = ""
    @Published var currentUser = Auth.auth().currentUser
    @AppStorage("userLoginType") var userLoginType: LoginType = .none
    // MARK: App Log Status
    @AppStorage("log_status") var logStatus: Bool = false

    // MARK: Apple Sign in Properties
    @Published var nonce: String = ""
    
    // MARK: - UserProfile 유무 판별함수
    /// 로그인 후, 해당 유저의 프로필이 등록되어있는지 확인하는 함수
    func fetchUserInfo(_ userId: String) async throws -> Msg? {
        guard (Auth.auth().currentUser != nil) else { return nil}
        let ref = Firestore.firestore().collection("User").document(userId)
        let snapshot = try await ref.getDocument()
        guard let docData = snapshot.data() else { return nil }
        let nickName = docData["nickName"] as? String ?? ""
        let profileImage = docData["profileImage"] as? String ?? ""
        let game = docData["game"] as? String ?? ""
        let gameHistory = docData["gameHistory"] as? [String] ?? []
//        let friend = docData["gameHistory"] as? [String] ?? []
        let userInfo = Msg(id: snapshot.documentID, nickName: nickName, profileImage: profileImage, game: game, gameHistory: gameHistory)
        return userInfo
    }
    
    func deleteUser() {
        print(#function)
        //Refresh Token
//        print(Auth.auth().currentUser?.getIDToken())
        let user = Auth.auth().currentUser
        user?.delete { error in
          if let error = error {
            // An error happened.
              print("error: \(error)")
          } else {
            // Account deleted.
              self.currentUser = nil
          }
        }
    }
    
    func signout(){
        do{
            try Auth.auth().signOut()
            withAnimation(.easeInOut){self.logStatus = false}
            self.currentUserProfile = nil
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
    func appleAuthenticate(credential: ASAuthorizationAppleIDCredential) async {
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
        do {
            let authResult = try await Auth.auth().signIn(with: firebaseCredential)
            self.currentUserProfile =  try await fetchUserInfo(authResult.user.uid)
            self.currentUser = authResult.user
            self.userLoginType = .Apple
            withAnimation(.easeInOut){self.logStatus = true}
        }catch{
            print("appleLogin Fail..!")
        }
        
    }
    
    // MARK: Logging Google User into Firebase
    func logGoogleUser(user: GIDGoogleUser) {
        Task {
            do {
                guard let idToken = user.authentication.idToken else { return }
                let accesToken = user.authentication.accessToken
                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accesToken)
                let authResult = try await Auth.auth().signIn(with: credential)
                self.currentUserProfile = try await fetchUserInfo(authResult.user.uid)
                self.currentUser = authResult.user
                self.userLoginType = .Google
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
                    self.userLoginType = .Kakao
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
                    self.userLoginType = .Kakao
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
                    Task{
                        let authResult = try await Auth.auth().signIn(withEmail: (user?.kakaoAccount?.email ?? "")!, password: "\(String(describing: user?.id))")
                        self.currentUserProfile = try await self.fetchUserInfo(_: authResult.user.uid)
                        self.currentUser = authResult.user
                        withAnimation(.easeInOut){self.logStatus = true}
                    }
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


