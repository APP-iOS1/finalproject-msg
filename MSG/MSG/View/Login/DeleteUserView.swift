
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

struct DeleteUserView: View {
    
    @EnvironmentObject var fireStoreViewModel: FireStoreViewModel
    @EnvironmentObject var loginViewModel: LoginViewModel
    @EnvironmentObject var kakaoAuthViewModel: KakaoViewModel
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) private var dismiss
    @State private var text = ""
    @State private var deleteToggle: Bool = false
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
                    Text("다시 로그인 후 회원탈퇴를 진행해주세요.")
                    
                    
                    ZStack {
                        Image(colorScheme == .light ? "LightLoginBack" : "BlackLoginBack")
                            .resizable()
                            .frame(width: g.size.width, height: g.size.height / 1.8)
                        
                        
                        VStack {
                            Spacer().frame(height: g.size.height * 0.05)
                            
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
                            
                        }
                        .frame(width: g.size.width, height: g.size.height / 2.1)
                    }
                    HStack {
                        Button {
                            deleteToggle.toggle()
                        } label: {
                            Text("탈퇴")
                        }
                        .alert("회원탈퇴", isPresented: $deleteToggle) {
                            TextField("",text: $text)
                            Button("확인", role: .destructive) {
                                if text == "탈퇴하겠습니다" {
                                    Task {
                                        await fireStoreViewModel.deleteUser()
                                        loginViewModel.deleteUser()
                                        deleteToggle.toggle()
                                        dismiss()
                                    }
                                }
                            }
                            Button("취소", role: .cancel) { deleteToggle.toggle() }
                        } message: {
                            Text("탈퇴 시 개인정보는 30일이후 삭제됩니다. 탈퇴하시려면 \"탈퇴하겠습니다\"를 입력해주세요.")
                        }
                        Spacer().frame(width: g.size.width / 5)
                        Button {
                            dismiss()
                        } label: {
                            Text("취소")
                        }
                    }
                    
                }
                .ignoresSafeArea()
                
            }
            .modifier(TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.title2, color: FontCustomColor.color2))
        }
        
    }
    
    
}



struct DeleteUserView_Previews: PreviewProvider {
    static var previews: some View {
        DeleteUserView()
    }
}
