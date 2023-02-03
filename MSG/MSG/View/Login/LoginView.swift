
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
    @Environment(\.colorScheme) var colorScheme
    @State private var showingSheetView: Bool = false
    @State var buttonNumber: Int = 1
    
    // 애플, 구글 로그인 ViewMode
    @AppStorage("_isFirstLaunching") var isFirstLaunching: Bool = true
    
    var body: some View {
        
        GeometryReader { g in
            ZStack {
                Image(colorScheme == .light ? "LightLoginBack" : "BlackLoginBack")
                    .resizable()
                    .ignoresSafeArea()
                 
                
                // MARK: 로그인 선택
                if buttonNumber == 1 {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(Color("SelectColor"))
                        .frame(width: 260, height: 55)
                        .padding(.bottom, 390)
                } else if buttonNumber == 2 {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(Color("SelectColor"))
                        .frame(width: 260, height: 55)
                        .padding(.bottom, 260)
                } else if buttonNumber == 3 {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(Color("SelectColor"))
                        .frame(width: 260, height: 55)
                        .padding(.bottom, 130)
                }
     
                 
                
                VStack {
                
                   Spacer()

                            // MARK: 로그인 버튼
                            VStack(spacing: 20) {
                                
                                // MARK: Custom Apple Sign in Button
                                CustomButton1()
                                    .overlay {
                                        SignInWithAppleButton { request in
                                            loginViewModel.nonce = randomNonceString()
                                            request.requestedScopes = [.fullName, .email]
                                            request.nonce = sha256(loginViewModel.nonce)
                                            buttonNumber = 1
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
                                                buttonNumber = 2
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
                                                    .frame(width: 250, height: 45)
                                                    .foregroundColor(.clear)
                                            }
                                        }
                                    }
                                    .clipped()
                                
                                // MARK: Custom Kakao Sign in Button
                                CustomButton2()
                                    .overlay{
                                        Button {
                                            buttonNumber = 3
                                            loginViewModel.kakaoLogin()
                                        } label: {
                                            Rectangle()
                                                .frame(width: 250, height: 45)
                                                .foregroundColor(.clear)
                                        }
                                    }
                                    .clipped()
                            }
                            .padding(.bottom, 32)

                    
                    // MARK: 앱 이름
                    
                    Text("Money Save Game")
                        .font(.title2)
                        .modifier(TextViewModifier(color: "Color2"))
                        .bold()
                        .padding(.bottom, 71)
                  
            
              
                    
                    // MARK: 조이패드 버튼
                    HStack {
                        ZStack {
                            VStack(spacing: 12) {
                                
                                // Top Button
                                Button {
                                    if buttonNumber > 1 {
                                        buttonNumber -= 1
                                    } else {
                                        buttonNumber = 3
                                    }
                                  
                                } label: {
                                    Image(colorScheme == .light ? "LightLoginTop" : "BlackLoginTop")
                                        .resizable()
                                        .frame(width: 48, height: 58)
                                }

                                // Bottom Button
                                Button {
                                    if buttonNumber < 3 {
                                        buttonNumber += 1
                                    } else {
                                        buttonNumber = 1
                                    }
                                  
                                } label: {
                                    Image(colorScheme == .light ? "LightLoginBottom" : "BlackLoginBottom")
                                        .resizable()
                                        .frame(width: 48, height: 58)
                                }
                            }
                            
                            HStack(spacing: 12) {
                                // Left Button
                                Button {
                                    if buttonNumber > 1 {
                                        buttonNumber -= 1
                                    } else {
                                        buttonNumber = 3
                                    }
                                } label: {
                                    Image(colorScheme == .light ? "LightLoginLeft" : "BlackLoginLeft")
                                        .resizable()
                                        .frame(width: 58, height: 48)
                                }

                                // Right Button
                                Button {
                                    if buttonNumber < 3 {
                                        buttonNumber += 1
                                    } else {
                                        buttonNumber = 1
                                    }
                                } label: {
                                    Image(colorScheme == .light ? "LightLoginRight" : "BlackLoginRight")
                                        .resizable()
                                        .frame(width: 58, height: 48)
                                }
                            }
                        }
                        .padding(.leading, 36)
                        
                        Spacer()
                        
                 
                            VStack {
                                // A Button(선택된 로그인 진행)
                                
                                if buttonNumber == 1 {
                             
              
                                    Image(colorScheme == .light ? "LightLoginA" : "BlackLoginA")
                                            .resizable()
                                            .frame(width: 55, height: 55)
                                            .padding(.leading,65)
                                            .overlay {
                                                SignInWithAppleButton { request in
                                                    loginViewModel.nonce = randomNonceString()
                                                    request.requestedScopes = [.fullName, .email]
                                                    request.nonce = sha256(loginViewModel.nonce)
                                                    buttonNumber = 1
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
                                                .frame(height: 0)
                                                .clipped()
                                                
                                            }
                                            .offset(y: 18)
                      
                                    
                                         
                                } else {
                                    Button {
                                        if buttonNumber == 2 {
                                            if let clientID = FirebaseApp.app()?.options.clientID {
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
                                            }
                                        } else if buttonNumber == 3 {
                                            loginViewModel.kakaoLogin()
                                        }
                             
                                    } label: {
                                        Image(colorScheme == .light ? "LightLoginA" : "BlackLoginA")
                                            .resizable()
                                            .frame(width: 55, height: 55)
                                            .padding(.leading,65)
                                    }
                                    .offset(y: 18)
                                }
                                
                                // B Button(선택된 로그인 리셋)
                                Button {
                                    buttonNumber = 1
                                } label: {
                                    Image(colorScheme == .light ? "LightLoginB" : "BlackLoginB")
                                        .resizable()
                                        .frame(width: 55, height: 55)
                                        .padding(.trailing, 65)
                                }
                                .offset(y: 14)
                            }
                        .padding(.trailing, 35)
                        .padding(.top,10)
                      
                    }
                    .padding(.bottom, 80)
                    
                    // MARK: 개인정보 처리방침
                    HStack(spacing: 55) {
                        // Thin Button
                        Button {
                            showingSheetView.toggle()
                        } label: {
                            Image(colorScheme == .light ? "LightLoginThin" : "BlackLoginThin")
                                .resizable()
                                .frame(width: 340 / 9, height: 15)
                        }
                        
                        // Thin Button
                        Button {
                            showingSheetView.toggle()
                        } label: {
                            Image(colorScheme == .light ? "LightLoginThin" : "BlackLoginThin")
                                .resizable()
                                .frame(width: 340 / 9, height: 15)
                        }
                        
                    }
                    .padding(.bottom, 5)
                    
          
          
                    Text("이용약관 및 개인정보 취급방침")
                        .modifier(TextViewModifier(color: "Color2"))
                        .font(.caption)
                        .padding(.bottom, 17)
                
               
                    
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
        .frame(width: 250, height: 45, alignment: .center)
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
        .frame(width: 250, height: 45, alignment: .center)
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
