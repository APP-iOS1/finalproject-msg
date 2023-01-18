
//  LoginView.swift
//  MSG
//
//  Created by zooey on 2023/01/17.
//
import SwiftUI
import CryptoKit
import AuthenticationServices
import FirebaseAuth
import GoogleSignIn

struct LoginView: View {
    
    @EnvironmentObject var kakaoAuthViewModel: KakaoViewModel
    @State private var showingSheetView: Bool = false
    
    private var frameWidth = UIScreen.main.bounds.width
    private var frameHeight = UIScreen.main.bounds.height
    
    // 애플 로그인 코드(20~66번줄)
    @EnvironmentObject var appleUserAuth: AppleUserAuth
    @State var currentNonce: String?
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
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
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    @AppStorage("_isFirstLaunching") var isFirstLaunching: Bool = true
    
    var body: some View {
        
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            VStack {
                // 앱 이름
                HStack(spacing: 20) {
                    Image(systemName: "dpad.left.filled")
                        .resizable()
                        .scaledToFit()
                        .frame(width: frameHeight / 18)
                    VStack(alignment: .leading) {
                        Text("MSG")
                            .font(.largeTitle.bold())
                        Text("Money Save Game")
                    }
                }
                .padding()
                .frame(width: frameWidth, alignment: .leading)
                .frame(maxHeight: frameHeight / 7)
                
                VStack(spacing: 20) {
                    HStack {
                        Text("회원가입")
                            .bold()
                        Divider()
                            .frame(height: frameHeight / 30)
                        Text("로그인")
                            .bold()
                    }
                    .frame(width: frameWidth, alignment: .leading)
                    .padding(.leading)
                    .padding(.leading)
                    
                    // 로그인
                    // 애플 로그인 버튼(106~154번줄)
                    SignInWithAppleButton(
                        onRequest: { request in
                            let nonce = randomNonceString()
                            currentNonce = nonce
                            request.requestedScopes = [.fullName, .email]
                            request.nonce = sha256(nonce)
                        },
                        onCompletion: { result in
                            switch result {
                            case .success(let authResults):
                                switch authResults.credential {
                                case let appleIDCredential as ASAuthorizationAppleIDCredential:
                                    
                                    guard let nonce = currentNonce else {
                                        fatalError("Invalid state: A login callback was received, but no login request was sent.")
                                    }
                                    guard let appleIDToken = appleIDCredential.identityToken else {
                                        fatalError("Invalid state: A login callback was received, but no login request was sent.")
                                    }
                                    guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                                        print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                                        return
                                    }
                                    
                                    let credential = OAuthProvider.credential(withProviderID: "apple.com",idToken: idTokenString,rawNonce: nonce)
                                    Auth.auth().signIn(with: credential) { (authResult, error) in
                                        if (error != nil) {
                                            // Error. If error.code == .MissingOrInvalidNonce, make sure
                                            // you're sending the SHA256-hashed nonce as a hex string with
                                            // your request to Apple.
                                            print(error?.localizedDescription as Any)
                                            return
                                        }
                                        print("signed in")
                                        self.appleUserAuth.login()
                                    }
                                    
                                    print("\(String(describing: Auth.auth().currentUser?.uid))")
                                default:
                                    break
                                    
                                }
                            default:
                                break
                            }
                        }
                    )
                    .frame(width: 280, height: 45, alignment: .center)
                    
                    
                    GoogleSignInButton()
                        .frame(width: 280, height: 45)
                        .cornerRadius(9)
           
     
                    
                    Button {
                        kakaoAuthViewModel.kakaoLogin()                    } label: {
                            Image("KakaoIcon")
                                .resizable()
                                .frame(width: 280, height: 45)
                                .cornerRadius(9)
                        }
                }
                .padding(.bottom)
                .frame(maxHeight: frameHeight / 3)
                
                // 개인정보 처리방침
                HStack {
                    Button {
                        showingSheetView.toggle()
                    } label: {
                        Text("**이용약관** 및 **개인정보 취급방침**")
                    }
                }
                .font(.caption)
                .padding(.top)
                .frame(maxWidth:  frameWidth,maxHeight: frameHeight / 5)
            }
            .foregroundColor(Color("Font"))
        }
        .fullScreenCover(isPresented: $showingSheetView) {
            PrivacyPolicyView()
        }
        .fullScreenCover(isPresented: $isFirstLaunching) {
            OnBoardTapView(isFirstLaunching: $isFirstLaunching)
        }
    }
}

struct GoogleSignInButton: UIViewRepresentable {
    @Environment(\.colorScheme) var colorScheme
    
    private var button = GIDSignInButton()
    
    func makeUIView(context: Context) -> GIDSignInButton {
        button.colorScheme = colorScheme == .dark ? .dark : .light
        return button
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        button.colorScheme = colorScheme == .dark ? .dark : .light
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
