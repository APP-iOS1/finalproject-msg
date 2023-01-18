//
//  MakeProfileView.swift
//  MSG
//
//  Created by zooey on 2023/01/17.
//

import SwiftUI
import PhotosUI

struct MakeProfileView: View {
    
    @State private var nickNameText: String = ""
    
    private var frameWidth = UIScreen.main.bounds.width
    private var frameHeight = UIScreen.main.bounds.height
    
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    
    @EnvironmentObject var kakaoAuthViewModel: KakaoViewModel
    @Environment(\.dismiss) var dismiss
    
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
                
                VStack {
                    // 프로필 사진
                    HStack {
                        Text("프로필 사진")
                            .bold()
                        Spacer()
                        PhotosPicker(selection: $selectedPhotoItem, matching: .images, photoLibrary: .shared()) {
                            Text("선택하기")
                        }
                        .onChange(of: selectedPhotoItem) { newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                    selectedImageData = data
                                }
                            }
                        }
                    }
                    .padding(.leading)
                    .padding(.trailing)
                    .padding(.bottom)
                    
                    // 사진을 선택했을 경우 변경하기
                    if selectedImageData == nil {
                        Image(systemName: "person.crop.circle.badge.plus")
                            .resizable()
                            .scaledToFit()
                            .frame(height: frameHeight / 5)
                    } else {
                        if let selectedImageData,
                           let uiImage = UIImage(data: selectedImageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                            //                                .scaledToFit()
                                .clipShape(Circle())
                                .frame(width: frameWidth / 2, height: frameHeight / 5)
                        }
                    }
                }
                
                VStack {
                    // 닉네임
                    HStack {
                        Text("닉네임")
                            .bold()
                        Spacer()
                    }
                    .padding(.leading)
                    
                    HStack {
                        TextField("닉네임을 입력하세요", text: $nickNameText)
                        Button {
                            
                        } label: {
                            Text("중복 확인")
                        }
                        .frame(width: frameWidth / 5 ,height: frameHeight / 24)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke()
                        }
                    }
                    .padding(.leading)
                    .padding(.trailing)
                }
                .frame(height: frameHeight / 5)
                
                VStack {
                    // 가입버튼
                    Button {
                        kakaoAuthViewModel.userNicName = nickNameText
                        dismiss()
                    } label: {
                        Text("가입완료")
                    }
                }
                .frame(width: frameWidth / 1.6,height: frameHeight / 17)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke()
                }
            }
        }
        .foregroundColor(Color("Font"))
    }
}

struct MakeProfileView_Previews: PreviewProvider {
    static var previews: some View {
        MakeProfileView()
    }
}
