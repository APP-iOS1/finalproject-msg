//
//  SettingView.swift
//  MSG
//
//  Created by zooey on 2023/01/18.
//
import SwiftUI

struct SettingView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var loginViewModel: LoginViewModel

    @Binding var darkModeEnabled: Bool
    
    var frameWidth = UIScreen.main.bounds.width
    var frameHeight = UIScreen.main.bounds.height
    
    var body: some View {
        
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 18) {
                VStack {
                    // 조건 써주기
                    if nil == nil {
                        Image(systemName: "person.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: frameWidth / 3, height: frameHeight / 7)
                    } else {
                        // 사진 불러오기
                        Image("logo")
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: frameWidth / 3, height: frameHeight / 7)
                    }
                }
                .frame(height: frameHeight / 7)
                
                HStack {
                    Text("닉네임")
                        .font(.title3.bold())
                        .padding(.top)
                        .padding(.leading)
                    
//                    Spacer()
//
//                    Button {
//
//                    } label: {
//                        HStack {
//                            Text("수정")
//                                .font(.caption)
//                        }
//                    }
//                    .frame(width: frameWidth / 10, height: frameHeight / 30)
//                    .overlay {
//                        RoundedRectangle(cornerRadius: 10)
//                            .stroke()
//                    }
//                    .padding(.top)
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 18) {
                    Toggle("다크모드 활성화", isOn: $darkModeEnabled)
                        .onChange(of: darkModeEnabled) { _ in
                           
                                SystemThemeManager
                                    .shared
                                    .handleTheme(darkMode: darkModeEnabled)
                        }
                        
                    Button {
                        
                    } label: {
                        Text("프로필 편집")
                    }
                    
                    Text("알림 설정")
                    
                    // 이메일, sms, 공유하기, 시트뷰로 보여주기
                    Text("친구 초대")
                    
                    Button {
                        loginViewModel.signout()
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("로그아웃")
                    }
                }
                
                VStack {
                    // 프레임 맞추려고 있는 VStack
                }
                .frame(height: frameHeight / 2.8)
            }
            .padding()
        }
        .foregroundColor(Color("Font"))
    }
}

struct SettignView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(darkModeEnabled: .constant(false))
    }
}
