//
//  MakeProfileView.swift
//  MSG
//
//  Created by zooey on 2023/01/17.
//
import SwiftUI
import PhotosUI
import FirebaseAuth

struct MakeProfileView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    @EnvironmentObject var fireStoreViewModel: FireStoreViewModel
    @State private var nickNameText: String = ""
    
    private var frameWidth = UIScreen.main.bounds.width
    private var frameHeight = UIScreen.main.bounds.height
    
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    
    @EnvironmentObject var kakaoAuthViewModel: KakaoViewModel
    @Environment(\.presentationMode) var presentationMode
    
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
                        
                        // MARK: 닉네임 체크 이미지
                        HStack {
                            // 닉네임 미입력
                            if nickNameText.isEmpty {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.red)
                                
                                // 닉네임 6자리 이하 입력
                            } else if nickNameText.range(of: ".{7,100}$", options: .regularExpression) != nil {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.red)
                            } else {
                                
                                // 중복된 닉네임 입력
                                if fireStoreViewModel.nickNameCheck(nickName: nickNameText) == false {
                                    Image(systemName: "multiply.circle.fill")
                                        .foregroundColor(.red)
                                    
                                    // 사용 가능 닉네임 입력
                                } else if fireStoreViewModel.nickNameCheck(nickName: nickNameText) == true {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.blue)
                                }
                            }
                        } // HStack: 닉네임 체크 이미지
                        
                    } // HStack
                    .padding(.leading)
                    .padding(.trailing)
                    
                    // MARK: 닉네임 체크 텍스트
                    HStack {
                        // 닉네임 미입력
                        if nickNameText.isEmpty {
                            Text("닉네임을 입력하세요.")
                                .font(.subheadline)
                            // 닉네임 6자리 이하 입력
                        } else if nickNameText.range(of: ".{7,100}$", options: .regularExpression) != nil {
                            Text("6자리 이하로 입력하세요")
                                .font(.subheadline)
                        } else {
                            
                            // 중복된 닉네임 입력
                            if fireStoreViewModel.nickNameCheck(nickName: nickNameText) == false {
                                Text("중복된 닉네임입니다.")
                                    .font(.subheadline)
                                
                                // 사용 가능 닉네임 입력
                            } else if fireStoreViewModel.nickNameCheck(nickName: nickNameText) == true {
                                Text("사용 가능한 닉네임입니다.")
                                    .font(.subheadline)
                            }
                        }
                        Spacer()
                        
                    } // HStack: 닉네임 체크 텍스트
                    .padding(.leading)
                }
                .frame(height: frameHeight / 5)
                
                
                
                // MARK: 가입 완료 버튼
                VStack {
                    Button {
                        // 닉네임 미입력
                        if nickNameText.isEmpty {
                            
                            // 닉네임 6자리 이하 입력
                        } else if nickNameText.range(of: ".{7,100}$", options: .regularExpression) != nil {
                            
                        } else {
                            // 중복된 닉네임 입력
                            if fireStoreViewModel.nickNameCheck(nickName: nickNameText) == false {
                                
                                // 사용 가능 닉네임 입력 (최종 체크 가입완료)
                            } else if fireStoreViewModel.nickNameCheck(nickName: nickNameText) == true {
                                kakaoAuthViewModel.userNicName = nickNameText
                                let userProfile = Msg(id: Auth.auth().currentUser?.uid ?? "", nickName: nickNameText, profilImage: "", game: "", gameHistory: nil, friend: nil)
                                loginViewModel.currentUserProfile = userProfile
                                fireStoreViewModel.addUserInfo(user: userProfile, downloadUrl: "")
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }
                    } label: {
                        Text("가입완료")
                    }
                } // VStack: 가입 완료 버튼
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
