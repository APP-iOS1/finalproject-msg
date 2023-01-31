
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
    
    @EnvironmentObject var loginViewModel: LoginViewModel
    @EnvironmentObject var kakaoAuthViewModel: KakaoViewModel
    @State private var showingSheetView: Bool = false
    
    private var frameWidth = UIScreen.main.bounds.width
    private var frameHeight = UIScreen.main.bounds.height
    
    // 애플, 구글 로그인 ViewMode
    
    @AppStorage("_isFirstLaunching") var isFirstLaunching: Bool = true
    
    var body: some View {
        
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            VStack {
                
                VStack {
                    // MARK: 앱 이름
                    HStack(spacing: 20) {
                        Image(systemName: "dpad.left.filled")
                            .resizable()
                            .scaledToFit()
                            .frame(width: frameHeight / 18)
                        VStack(alignment: .leading) {
                            Text("MSG")
                                .modifier(TextTitleBold())
                            Text("Money Save Game")
                                .modifier(TextViewModifier(color: "Font"))
                        }
                    }
                    .padding()
                    .frame(width: frameWidth, alignment: .center)
                    .frame(maxHeight: frameHeight / 7)
                    
                    // MARK: 로그인 버튼
                    VStack(spacing: 20) {
                        // MARK: 로그인
                        ZStack {
                            Rectangle()
                                .frame(width: 280, height:4)
                                .foregroundColor(Color("Point1"))
                                .padding(.top,40)
                            Text("로그인")
                                .modifier(TextTitleBold())
                        }
                        // MARK: Custom Apple Sign in Button
                        CustomButton1()
                        // MARK: Custom Google Sign in Button
                        CustomButton1(isGoogle: true)
                        
                        // MARK: Custom Kakao Sign in Button
                        CustomButton2()
                            .overlay{
                                Button {
                                    loginViewModel.kakaoLogin()
                                } label: {
                                    Rectangle()
                                        .frame(width: 280, height: 45)
                                        .foregroundColor(.clear)
                                }
                            }
                            .clipped()
                    }
                    .padding(.top, 20)
                }
                
                // MARK: 개인정보 처리방침
                HStack {
                    Button {
                        showingSheetView.toggle()
                    } label: {
                        Text("**이용약관** 및 **개인정보 취급방침**")
                            .modifier(TextViewModifier(color: "Font"))
                        
                        //                                    .padding(.top, 340)
                    }
                }
                .padding(.top)
                .frame(maxWidth:  frameWidth,maxHeight: frameHeight / 5)
                
            }
            .modifier(TextViewModifier(color: "Font"))
        }
        .fullScreenCover(isPresented: $showingSheetView) {
            PrivacyPolicyView()
        }
        .fullScreenCover(isPresented: $isFirstLaunching) {
            OnBoardTapView(isFirstLaunching: $isFirstLaunching)
        }
    }
    
    @ViewBuilder
    // MARK: Apple & Google CustomButton
    func CustomButton1(isGoogle: Bool = false) -> some View {
        
        if isGoogle {
            HStack {
                Group {
                    Image("GoogleIcon")
                        .resizable()
                }
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
                .frame(height: 45)
                
                Text("Google Sign in")
                    .font(.callout)
                    .lineLimit(1)
            }
            .foregroundColor(.black)
            .padding(.horizontal,15)
            .frame(width: 280, height: 45, alignment: .center)
            .background {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(.white)
            }
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
                                loginViewModel.logGoogleUser(user: user)
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
        } else {
            HStack {
                Group {
                    Image(systemName: "applelogo")
                        .resizable()
                }
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
                .frame(height: 45)
                
                Text("Apple Sign in")
                    .font(.callout)
                    .lineLimit(1)
            }
            .foregroundColor(.white)
            .padding(.horizontal,15)
            .frame(width: 280, height: 45, alignment: .center)
            .background {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(.black)
            }
            .overlay {
                SignInWithAppleButton { request in
                    loginViewModel.nonce = randomNonceString()
                    request.requestedScopes = [.fullName, .email]
                    request.nonce = sha256(loginViewModel.nonce)
                    
                } onCompletion: { (result) in
                    switch result {
                    case .success(let user):
                        print("success")
                        guard let credential = user.credential as?
                                ASAuthorizationAppleIDCredential else {
                            print("error with firebase")
                            return
                        }
                        Task { await loginViewModel.appleAuthenticate(credential: credential) }
                    case.failure(let error):
                        print(error.localizedDescription)
                    }
                }
                .signInWithAppleButtonStyle(.white)
                .cornerRadius(8)
                .frame(height: 45)
                .blendMode(.overlay)
            }
            .clipped()
        }
    }
    
    // MARK: KaKao & Facebook(추후 업데이트 예정) CustomButton
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
