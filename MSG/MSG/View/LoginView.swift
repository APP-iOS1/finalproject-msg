//
//  LoginView.swift
//  MSG
//
//  Created by zooey on 2023/01/17.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var kakaoAuthViewModel: KakaoAuthViewModel = KakaoAuthViewModel()
    
    var body: some View {
        
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            VStack {
                HStack(spacing: 20) {
                    Image(systemName: "flag.checkered.2.crossed")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70)
                    VStack(alignment: .leading) {
                        Text("MSG")
                            .font(.largeTitle.bold())
                        Text("Money Save Game")
                    }
                }
                .padding()
                .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                .frame(maxHeight: UIScreen.main.bounds.height / 7)
                
                VStack(spacing: 20) {
                    HStack {
                        Text("회원가입")
                            .bold()
                        Divider()
                            .frame(height: UIScreen.main.bounds.height / 30)
                        Text("로그인")
                            .bold()
                    }
                    .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                    .padding(.leading)
                    .padding(.leading)
                    
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
                        kakaoAuthViewModel.kakaoLogin()
                    } label: {
                        Text("카카오 로그인")
                    }
                }
                .padding(.bottom)
                .frame(maxHeight: UIScreen.main.bounds.height / 3)
                
                HStack {
                    Button {
                        
                    } label: {
                        Text("이용약관")
                            .bold()
                    }
                    
                    Text("및")
                    
                    Button {
                        
                    } label: {
                        Text("개인정보 취급방침")
                            .bold()
                    }
                }
                .font(.caption)
                .padding(.top)
                .frame(maxHeight: UIScreen.main.bounds.height / 5)
            }
            
        }
        .foregroundColor(Color("Font"))
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
