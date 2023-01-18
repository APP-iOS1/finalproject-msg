
//  LoginView.swift
//  MSG
//
//  Created by zooey on 2023/01/17.
//
import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var kakaoAuthViewModel: KakaoViewModel
    @State private var showingSheetView: Bool = false
    
    private var frameWidth = UIScreen.main.bounds.width
    private var frameHeight = UIScreen.main.bounds.height
    
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
                    Text("애플 로그인")
                        .frame(width: 340, height: 40)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke()
                            
                        }
                    Text("구글 로그인")
                        .frame(width: 340, height: 40)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke()
                        }
                    
                    Button {
                        kakaoAuthViewModel.kakaoLogin()                    } label: {
                        Text("카카오 로그인")
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

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
