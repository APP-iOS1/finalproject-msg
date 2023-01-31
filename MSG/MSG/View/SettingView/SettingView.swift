//
//  SettingView.swift
//  MSG
//
//  Created by zooey on 2023/01/18.
//
import SwiftUI

struct SettingView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    @State var userProfile: Msg?
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
                    if userProfile == nil || userProfile!.profileImage.isEmpty{
                        Image(systemName: "person.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: frameWidth / 3, height: frameHeight / 7)
                    } else {
                        // 사진 불러오기
                        AsyncImage(url: URL(string: userProfile!.profileImage)) { Image in
                            Image
                                .resizable()
                                .clipShape(Circle())
                                .frame(width: frameWidth / 3, height: frameHeight / 7)
                                
                        } placeholder: { }
                    }
                }
                .frame(height: frameHeight / 7)
                
                HStack {
                    Text( userProfile != nil ? userProfile!.nickName : "닉네임")
                        .modifier(TextViewModifier(color: "Font"))
                        .padding(.top)
                        .padding(.leading)
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
                    } label: {
                        Text("로그아웃")
                    }
                }
                .modifier(TextViewModifier(color: "Font"))
                
                VStack {
                    // 프레임 맞추려고 있는 VStack
                }
                .frame(height: frameHeight / 2.8)
            }
            .padding()
        }.onAppear{
            if loginViewModel.currentUserProfile != nil{
                self.userProfile = loginViewModel.currentUserProfile
            }
            
        }
        .foregroundColor(Color("Font"))
    }
}

struct SettignView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(darkModeEnabled: .constant(false))
    }
}
