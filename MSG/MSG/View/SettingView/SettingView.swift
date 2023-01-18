//
//  SettingView.swift
//  MSG
//
//  Created by zooey on 2023/01/18.
//
import SwiftUI

struct SettingView: View {
    
    @State private var currentMode: ColorScheme = .light
    @State private var isToggleOn: Bool = false
    
    private var frameWidth = UIScreen.main.bounds.width
    private var frameHeight = UIScreen.main.bounds.height
    
    var body: some View {
        
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 18) {
                HStack {
                    // 조건 써주기
                    if nil == nil {
                        Image(systemName: "person.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: frameWidth / 4, height: frameHeight / 10)
                    } else {
                        // 사진 불러오기
                        Image("logo")
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: frameWidth / 4, height: frameHeight / 10)
                    }
                }
                .frame(height: frameHeight / 15)
                
                HStack {
                    Text("닉네임")
                        .padding(.top)
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        HStack {
                            Text("수정")
                                .font(.caption)
                        }
                    }
                    .frame(width: frameWidth / 10, height: frameHeight / 30)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke()
                    }
                    .padding(.top)
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 18) {
                    Toggle("다크모드 활성화", isOn: $isToggleOn)
                        .onChange(of: isToggleOn, perform: { newValue in
                            if isToggleOn == true {
                                currentMode = .dark
                            }
                        })
                    
                    Text("알림 설정")
                    // 이메일, sms, 공유하기, 시트뷰로 보여주기
                    Text("친구 초대")
                    Button {
                        
                    } label: {
                        Text("로그아웃")
                    }
                    
                }
                VStack {
                    // 프레임 맞추려고 있는 VStack
                }
                .frame(height: frameHeight / 2.4)
            }
            .padding()
        }
        .foregroundColor(Color("Font"))
        .preferredColorScheme(currentMode)
    }
}

struct SettignView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
