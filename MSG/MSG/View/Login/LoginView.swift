
//  LoginView.swift
//  MSG
//
//  Created by zooey on 2023/01/17.
//
import SwiftUI
// 애플 로그인
import AuthenticationServices
// 구글 로그인
import GoogleSignIn
import GoogleSignInSwift
import Firebase

struct LoginView: View {
    
    @EnvironmentObject var kakaoAuthViewModel: KakaoViewModel
    @State private var showingSheetView: Bool = false
    
    private var frameWidth = UIScreen.main.bounds.width
    private var frameHeight = UIScreen.main.bounds.height
    
    // 애플, 구글 로그인 ViewModel
    @StateObject var loginModel: LoginViewModel = .init()
    
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
                    
                    // MARK: 로그인 버튼
                    VStack(spacing: 15) {
                        // MARK: Custom Apple Sign in Button
                        CustomButton1()
                        .overlay {
                            SignInWithAppleButton{(request) in
                                
                                    // requesting paramertes from apple login...
                                    loginModel.nonce = randomNonceString()
                                    request.requestedScopes = [.fullName, .email]
                                    request.nonce = sha256(loginModel.nonce)
                            } onCompletion: { (result) in
                                switch result {
                                case .success(let user):
                                    print("success")
                                    guard let credential = user.credential as?
                                            ASAuthorizationAppleIDCredential else {
                                        print("error with firebase")
                                        return
                                    }
                                    loginModel.appleAuthenticate(credential: credential)
                                case.failure(let error):
                                    print(error.localizedDescription)
                                }
                            }
                            .signInWithAppleButtonStyle(.white)
                            .frame(height: 45)
                            .blendMode(.overlay)
                        }
                        .clipped()
                        
                        // MARK: Custom Google Sign in Button
                        CustomButton1(isGoogle: true)
                            .overlay {
                                if let clientID = FirebaseApp.app()?.options.clientID {
                                    Button {
                                        GIDSignIn.sharedInstance.signIn(with: .init(clientID: clientID), presenting: UIApplication.shared.rootController()) { user, error in
                                            if let error = error {
                                                print(error.localizedDescription)
                                                return
                                            }
                                            // MARK: Loggin Google User into Firbase
                                            if let user {
                                                loginModel.logGoogleUser(user: user)
                                            }
                                        }
                                    } label: {
                                        Rectangle()
                                            .frame(width: 280, height: 45)
                                            .foregroundColor(.clear)
                                    }
                                }
                            }
                        .clipped()
                        
                        // MARK: Custom Kakao Sign in Button
                        CustomButton2()
                            .overlay{
                                Button {
                                    kakaoAuthViewModel.kakaoLogin()
                                } label: {
                                    Rectangle()
                                        .frame(width: 280, height: 45)
                                        .foregroundColor(.clear)
                                }
                            }
                            .clipped()
                        
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
    
    @ViewBuilder
    // Apple & Google CustomButton
    func CustomButton1(isGoogle: Bool = false) -> some View {
        HStack {
            Group {
                if isGoogle {
                    Image("GoogleIcon")
                        .resizable()
                } else {
                    Image(systemName: "applelogo")
                        .resizable()
                }
            }
            .aspectRatio(contentMode: .fit)
            .frame(width: 25, height: 25)
            .frame(height: 45)
            
            Text("\(isGoogle ? "Google" : "Apple") Sign in")
                .font(.callout)
                .lineLimit(1)
        }
        .foregroundColor(isGoogle ? .black : .white)
        .padding(.horizontal,15)
        .frame(width: 280, height: 45, alignment: .center)
        .background {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(isGoogle ? .white : .black)
        }
    }
    
    // KaKao & Facebook(추후 업데이트 예정) CustomButton
    func CustomButton2(isKakao: Bool = false) -> some View {
        HStack {
            
            Group {
                if isKakao {
                    Image(systemName: "applelogo")
                        .resizable()
                } else {
                    Image("KakaoIcon")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.black)
                }
            }
            .aspectRatio(contentMode: .fit)
            .frame(width: 25, height: 25)
            .frame(height: 45)
            
            Text("\(isKakao ? "Facebook" : "Kakao") Sign in")
                .font(.callout)
                .lineLimit(1)
        }
        .foregroundColor(isKakao ? .white : Color("KakaoFontColor"))
        .padding(.horizontal,15)
        .frame(width: 280, height: 45, alignment: .center)
        .background {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(isKakao ? .blue : Color("KakaoButtonColor"))
        }
    }
    
}



struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
