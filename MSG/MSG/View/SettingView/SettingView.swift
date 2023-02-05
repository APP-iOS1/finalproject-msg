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
    @State private var logoutToggle: Bool = false
    
    var body: some View {
        
        GeometryReader { g in
            ZStack {
                Color("Color1").ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 30) {
                    
                    VStack(alignment: .leading) {
                        Text("설정")
                            .modifier(TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.largeTitle, color: FontCustomColor.color2))
                        Text("Money Save Game")
                            .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.caption, color: FontCustomColor.color2))
                    }
                    .frame(width: g.size.width / 1.1, height: g.size.height / 8, alignment: .leading)
                    
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
                            .frame(width: g.size.width / 1.1, height: g.size.height / 4)
                        
                        VStack {
                            VStack {
                                // 조건 써주기
                                if userProfile == nil || userProfile!.profileImage.isEmpty{
                                    Image(systemName: "person.circle")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: g.size.width / 3, height: g.size.height / 7)
                                } else {
                                    // 사진 불러오기
                                    AsyncImage(url: URL(string: userProfile!.profileImage)) { Image in
                                        Image
                                            .resizable()
                                            .clipShape(Circle())
                                            .frame(width: g.size.width / 3, height: g.size.height / 7)
                                    } placeholder: { }
                                }
                            }
                            .frame(height: g.size.height / 7)
                            
                            HStack {
                                Text( userProfile != nil ? userProfile!.nickName : "닉네임")
                                    .modifier(TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.title3, color: FontCustomColor.color2))
                                    .padding(.top)
                            }
                        }
                    }
                    .frame(width: g.size.width / 1.1, height: g.size.height / 4)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            Text("다크모드")
                            Spacer()
                            CustomToggle(width: g.size.width / 4.7, height: g.size.height / 22, toggleWidthOffset: 12, cornerRadius: 15, padding: 4, darkModeEnabled: $darkModeEnabled)
                               }
                        
                        Button {
                            
                        } label: {
                            Text("프로필 편집")
                        }
                        
                        Text("알림 설정")
                        
                        // 이메일, sms, 공유하기, 시트뷰로 보여주기
                        Text("친구 초대")
                        
                        Button {
                            logoutToggle.toggle()
                        } label: {
                            Text("로그아웃")
                        }
                        .alert("로그아웃", isPresented: $logoutToggle) {
                            Button("확인", role: .destructive) {
                                loginViewModel.signout()
                            }
                            Button("취소", role: .cancel) {}
                        } message: {
                            Text("로그아웃하시겠습니까?")
                        }
                        
                    }
                    .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.body, color: FontCustomColor.color2))
                    
                    VStack {
                        // 프레임 맞추려고 있는 VStack
                    }
                    .frame(height: g.size.height / 4)
                }
                .foregroundColor(Color("Color2"))
                .padding()
            }
            .onAppear{
                if loginViewModel.currentUserProfile != nil{
                    self.userProfile = loginViewModel.currentUserProfile
                }
            }
        }
    }
}

struct SettignView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(darkModeEnabled: .constant(false))
    }
}
