
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
    @State var buttonNumber: Int = 4
    @State var isAnimating: Bool = false
    
    // 애플, 구글 로그인 ViewMode
    @AppStorage("_isFirstLaunching") var isFirstLaunching: Bool = true
    
    var body: some View {
        
        GeometryReader { g in
            ZStack {
                Color("LoginColor")
                    .ignoresSafeArea()
                
                
                VStack {
                
                    
                    
                    ZStack {
                        Image(colorScheme == .light ? "LightLoginBack" : "BlackLoginBack")
                            .resizable()
                            .frame(width: g.size.width, height: g.size.height / 1.8)
                        
                        
                        VStack {
                            Spacer()
                            
                            // MARK: 로그인 버튼
                            VStack(spacing: g.size.height / 30) {
                                
                                // MARK: Custom Apple Sign in Button
                                ZStack {
                                    if buttonNumber == 1 {
                                        HStack(spacing: g.size.width / 1.75) {
                                            Image(systemName: "arrowtriangle.right.fill")
                                            Image(systemName: "arrowtriangle.left.fill")
                                        }
                                        .foregroundColor(.black)
                                    }
                                    
                                    HStack {
                                        Image(systemName: "applelogo")
                                            .resizable()
                                            .frame(width: g.size.width / 16, height: g.size.height / 28)
                                            .aspectRatio(contentMode: .fit)
                                        
                                        Text("Apple Sign in")
                                            .font(.callout)
                                            .lineLimit(1)
                                    }
                                    .foregroundColor(.white)
                                    .frame(width: g.size.width / 1.8, height: g.size.height / 17, alignment: .center)
                                    .background {
                                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                                            .fill(.black)
                                    }
                                    .overlay {
                                        SignInWithAppleButton { request in
                                            buttonNumber = 1
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
                                        .frame(width: g.size.width / 1.8, height: g.size.height / 17)
                                        .blendMode(.overlay)
                                    }
                                    .clipped()
                                    
                                }
                        
                                
                                // MARK: Custom Google Sign in Button
                                
                                ZStack {
                                    if buttonNumber == 2 {
                                        HStack(spacing: g.size.width / 1.75) {
                                            Image(systemName: "arrowtriangle.right.fill")
                                            Image(systemName: "arrowtriangle.left.fill")
                                        }
                                        .foregroundColor(.white)
                                    }
                                    
                                    HStack {
                                        Image("GoogleIcon")
                                            .resizable()
                                            .frame(width: g.size.width / 16, height: g.size.height / 28)
                                            .aspectRatio(contentMode: .fit)
                                        
                                        Text("Google Sign in")
                                            .font(.callout)
                                            .lineLimit(1)
                                    }
                                    .foregroundColor(.black)
                                    .frame(width: g.size.width / 1.8, height: g.size.height / 17, alignment: .center)
                                    .background {
                                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                                            .fill(.white)
                                    }
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
                                                    .frame(width: g.size.width / 1.8, height: g.size.height / 17)
                                                    .foregroundColor(.clear)
                                            }
                                        }
                                    }
                                    .clipped()
                                    
                                }
                       
                                
                                // MARK: Custom Kakao Sign in Button
                                ZStack {
                                    if buttonNumber == 3 {
                                        HStack(spacing: g.size.width / 1.75) {
                                            Image(systemName: "arrowtriangle.right.fill")
                                            Image(systemName: "arrowtriangle.left.fill")
                                        }
                                        .foregroundColor(Color("KakaoButtonColor"))
                                    }
                                    
                                    HStack {
                                        Image("KakaoIcon")
                                            .resizable()
                                            .frame(width: g.size.width / 16, height: g.size.height / 28)
                                            .aspectRatio(contentMode: .fit)
                                        
                                        Text("Kakao Sign in")
                                            .font(.callout)
                                            .lineLimit(1)
                                        
                                    }
                                    .foregroundColor(Color("KakaoFontColor"))
                                    .frame(width: g.size.width / 1.8, height: g.size.height / 17, alignment: .center)
                                    .background {
                                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                                            .fill(Color("KakaoButtonColor"))
                                    }
                                    .overlay {
                                        Button {
                                            buttonNumber = 3
                                            loginViewModel.kakaoLogin()
                                        } label: {
                                            Rectangle()
                                                .frame(width: g.size.width / 1.8, height: g.size.height / 17)
                                                .foregroundColor(.clear)
                                        }
                                    }
                                    .clipped()
                                    
                                }
                                
                            }
                            .frame(width: g.size.width, height: g.size.height / 3.2)
                            
                            
                            
                            // MARK: 앱 이름
                            Text("Money Save Game")
                           
                        }
                        .frame(width: g.size.width, height: g.size.height / 2.1)
                }
                   
                    // MARK: 조이패드 버튼
                    HStack {
                        ZStack {
                            Image(colorScheme == .light ? "LightLoginButtonBack1" : "BlackLoginButtonBack1")
                                .resizable()
                                .frame(width: g.size.width / 2.6, height: g.size.height / 5)
                            
                            VStack(spacing: g.size.height / 55) {
                                
                                // Top Button
                                Button {
                                    if buttonNumber > 1 {
                                        buttonNumber -= 1
                                    } else {
                                        buttonNumber = 4
                                    }
                                    
                                } label: {
                                    Image(colorScheme == .light ? "LightLoginTop" : "BlackLoginTop")
                                        .resizable()
                                        .frame(width: g.size.width / 8.2, height: g.size.height / 13)
                                }
                                
                                // Bottom Button
                                Button {
                                    if buttonNumber < 4 {
                                        buttonNumber += 1
                                    } else {
                                        buttonNumber = 1
                                    }
                                    
                                } label: {
                                    Image(colorScheme == .light ? "LightLoginBottom" : "BlackLoginBottom")
                                        .resizable()
                                        .frame(width: g.size.width / 8.2, height: g.size.height / 13)
                                }
                            }
                            
                            HStack(spacing: g.size.width / 30) {
                                // Left Button
                                Button {
                                    if buttonNumber > 1 {
                                        buttonNumber -= 1
                                    } else {
                                        buttonNumber = 4
                                    }
                                } label: {
                                    Image(colorScheme == .light ? "LightLoginLeft" : "BlackLoginLeft")
                                        .resizable()
                                        .frame(width: g.size.width / 6.6, height: g.size.height / 15)
                                }
                                
                                // Right Button
                                Button {
                                    if buttonNumber < 4 {
                                        buttonNumber += 1
                                    } else {
                                        buttonNumber = 1
                                    }
                                } label: {
                                    Image(colorScheme == .light ? "LightLoginRight" : "BlackLoginRight")
                                        .resizable()
                                        .frame(width: g.size.width / 6.6, height: g.size.height / 15)
                                }
                            }
                        }
                        .frame(width: g.size.width / 3, height: g.size.height / 5, alignment: .center)
                        .padding(.leading, g.size.width / 11)
                        .padding(.bottom, -(g.size.height / 7))
                        
                        Spacer()
                        
                        
                        VStack {
                            // A Button(선택된 로그인 진행)
                            
                            if buttonNumber == 1 {
                                
                                ZStack {
                                    Image(colorScheme == .light ? "LightLoginButtonBack2" : "BlackLoginButtonBack2")
                                        .resizable()
                                        .frame(width: g.size.width / 5.5, height: g.size.height / 10.5)
                                    
                                    
                                    
                                    Image(colorScheme == .light ? "LightLoginA" : "BlackLoginA")
                                        .resizable()
                                        .frame(width: g.size.width / 7.3, height: g.size.height / 13.9)
                                }
                                .padding(.leading, g.size.width / 6.2)
                                .padding(.top, g.size.height / 200)
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
                                    ZStack {
                                        Image(colorScheme == .light ? "LightLoginButtonBack2" : "BlackLoginButtonBack2")
                                            .resizable()
                                            .frame(width: g.size.width / 5.5, height: g.size.height / 10.5)
                                        
                                        Image(colorScheme == .light ? "LightLoginA" : "BlackLoginA")
                                            .resizable()
                                            .frame(width: g.size.width / 7.3, height: g.size.height / 13.9)
                                    }
                                    .padding(.leading, g.size.width / 6.2)
                                    .padding(.top, g.size.height / 200)
                                }
                            }
                            
                            // B Button(선택된 로그인 리셋)
                            Button {
                                buttonNumber = 4
                            } label: {
                                ZStack {
                                    Image(colorScheme == .light ? "LightLoginButtonBack2" : "BlackLoginButtonBack2")
                                        .resizable()
                                        .frame(width: g.size.width / 5.5, height: g.size.height / 10.5)
                                    
                                    Image(colorScheme == .light ? "LightLoginB" : "BlackLoginB")
                                        .resizable()
                                        .frame(width: g.size.width / 7.3, height: g.size.height / 13.7)
                                }
                                .padding(.trailing, g.size.width / 5.8)
                                .padding(.bottom, g.size.height / 100)
                            }
                        }
                        .offset(y: g.size.height / 9)
                        .padding(.trailing, g.size.width / 13)
                  
                        
                        
                    }
                    .padding(.bottom, g.size.height / 7.6)
                    
                    // MARK: 개인정보 처리방침
                    VStack {
                        HStack(spacing: g.size.width / 7.2) {
                            // Thin Button
                            Button {
                                showingSheetView.toggle()
                            } label: {
                                ZStack {
                                    Image(colorScheme == .light ? "LightLoginButtonBack3" : "BlackLoginButtonBack3")
                                        .resizable()
                                        .frame(width: g.size.width / 6.9, height: g.size.height / 23)
                                    
                                    Image(colorScheme == .light ? "LightLoginThin" : "BlackLoginThin")
                                        .resizable()
                                        .frame(width: g.size.width / 10.5, height: g.size.height / 50)
                                }
                            }
                            
                            // Thin Button
                            Button {
                                showingSheetView.toggle()
                            } label: {
                                ZStack {
                                    Image(colorScheme == .light ? "LightLoginButtonBack3" : "BlackLoginButtonBack3")
                                        .resizable()
                                        .frame(width: g.size.width / 6.9, height: g.size.height / 23)
                                    
                                    Image(colorScheme == .light ? "LightLoginThin" : "BlackLoginThin")
                                        .resizable()
                                        .frame(width: g.size.width / 10.5, height: g.size.height / 50)
                                }
                            }
                        }
                        Text("이용약관 및 개인정보 취급방침")
                            .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.caption2, color: FontCustomColor.color2))

                    }
                    .frame(width: g.size.width, height: g.size.height / 14)
         
                   
                    
                }
                .ignoresSafeArea()
   
            }
            .fullScreenCover(isPresented: $showingSheetView) {
                PrivacyPolicyView()
            }
            .fullScreenCover(isPresented: $isFirstLaunching) {
                OnBoardTapView(isFirstLaunching: $isFirstLaunching)
            }
            .modifier(TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.title2, color: FontCustomColor.color2))
        }

    }
  
    
}



struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
