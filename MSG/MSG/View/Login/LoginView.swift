
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
    
    // 애플, 구글 로그인 ViewMode
    
    @AppStorage("_isFirstLaunching") var isFirstLaunching: Bool = true
    
    var body: some View {
        
        GeometryReader { g in
            ZStack {
                Color("Color1").ignoresSafeArea()
                VStack {
                    // MARK: 앱 이름
                    VStack(alignment: .leading) {
                        Text("MSG")
                            .font(.largeTitle.bold())
                        Text("Money Save Game")
                    }
                    .frame(width: g.size.width / 1.1, height: g.size.height / 10, alignment: .leading)
                    .offset(y: g.size.height / -10)
                    
                    VStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color("Color1"),
                                        lineWidth: 4)
                                .shadow(color: Color("Shadow"),
                                        radius: 3, x: 5, y: 5)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 15))
                                .shadow(color: Color("Shadow3"), radius: 2, x: -2, y: -2)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 15))
                                .background(Color("Color1"))
                                .cornerRadius(20)
                                .frame(width: g.size.width / 1.1, height: g.size.height / 3)
                            
                            // MARK: 로그인 버튼
                            VStack(spacing: 20) {
                                
                                // MARK: Custom Apple Sign in Button
                                CustomButton1()
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
                    }
                    .offset(y: g.size.height / -10)
                    
                    HStack {
                        Button(action: {}) {
                            Image(systemName: "dpad.fill")
                                .resizable()
                                .foregroundColor(Color("Color2"))
                                .frame(width: g.size.width / 5, height: g.size.height / 9.5)
                                .shadow(color: Color("Shadow3"), radius: 8, x: -9, y: -9)
                                .shadow(color: Color("Shadow"), radius: 8, x: 9, y: 9)
                                .padding(20)
                                .background(Color("Color1"))
                                .cornerRadius(20)
                        }
                        .shadow(color: Color("Shadow3"), radius: 8, x: -9, y: -9)
                        .shadow(color: Color("Shadow"), radius: 8, x: 9, y: 9)
                        
                        Spacer()
                        
                        Button(action: {}){
                            Image(systemName: "a.circle.fill")
                                .resizable()
                                .frame(width: g.size.width / 10, height: g.size.height / 18.5)
                                .padding(25)
                                .foregroundColor(Color("Color2"))
                                .background(
                                    Circle()
                                        .fill(
                                            .shadow(.inner(color: Color("Shadow2"),radius: 5, x:3, y: 3))
                                            .shadow(.inner(color: Color("Shadow3"), radius:5, x: -3, y: -3))
                                        )
                                        .foregroundColor(Color("Color1")))
                        }
                        
                        VStack {
                            Button(action: {}){
                                Image(systemName: "b.circle.fill")
                                    .resizable()
                                    .frame(width: g.size.width / 10, height: g.size.height / 18.5)
                                    .padding(25)
                                    .foregroundColor(Color("Color2"))
                                    .background(
                                        Circle()
                                            .fill(
                                                .shadow(.inner(color: Color("Shadow2"),radius: 5, x:3, y: 3))
                                                .shadow(.inner(color: Color("Shadow3"), radius:5, x: -3, y: -3))
                                            )
                                            .foregroundColor(Color("Color1")))
                            }
                        }
                    }
                    .frame(width: g.size.width / 1.1)
                    
                    // MARK: 개인정보 처리방침
                    HStack {
                        Button {
                            showingSheetView.toggle()
                        } label: {
                            Text("**이용약관** 및 **개인정보 취급방침**")
                            //                                    .padding(.top, 340)
                        }
                    }
                    .font(.caption)
                    .offset(y: g.size.height / 7)
                    
                }
                .foregroundColor(Color("Color2"))
            }
            .fullScreenCover(isPresented: $showingSheetView) {
                PrivacyPolicyView()
            }
            .fullScreenCover(isPresented: $isFirstLaunching) {
                OnBoardTapView(isFirstLaunching: $isFirstLaunching)
            }
        }
    }
    
    @ViewBuilder
    // MARK: Apple & Google CustomButton
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
