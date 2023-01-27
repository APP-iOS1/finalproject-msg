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
    
    @State private var showingAlert1 = false
    @State private var showingAlert2 = false
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
                        
                        // MARK: 닉네임 중복 확인 버튼
                        Button {
                            showingAlert1 = true
                        } label: {
                            Text("중복 확인")
                        }
                        .frame(width: frameWidth / 5 ,height: frameHeight / 24)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke()
                        }
                        .alert(Text("중복 확인"), isPresented: $showingAlert1) {
                            Button("확인") {}
                        } message: {
                            
                            // 닉네임 미입력
                            if nickNameText.isEmpty {
                                Text("닉네임을 입력하세요.")
                                
                            // 닉네임 6자리 이하 입력
                            } else if nickNameText.range(of: ".{7,100}$", options: .regularExpression) != nil {
                                Text("6자리 이하로 입력하세요")
                            } else {
                                
                                // 중복된 닉네임 입력
                                if fireStoreViewModel.nickNameCheck(nickName: nickNameText) == false {
                                    Text("중복된 닉네임입니다.")
                                    
                                // 사용 가능 닉네임 입력
                                } else if fireStoreViewModel.nickNameCheck(nickName: nickNameText) == true {
                                    Text("사용 가능한 닉네임입니다.")
                                }
                            }
                        } // alert
                        
                    }
                    .padding(.leading)
                    .padding(.trailing)
                }
                .frame(height: frameHeight / 5)
                
                VStack {

                    // MARK: 가입 완료 버튼
                    Button {
                        showingAlert2 = true
                    } label: {
                        Text("가입완료")
                    }
                    .alert(Text("가입 확인"), isPresented: $showingAlert2) {
                        
                            // 닉네임 미입력
                        if nickNameText.isEmpty {
                            Button("확인") {}
                            
                            // 닉네임 6자리 이하 입력
                        } else if nickNameText.range(of: ".{7,100}$", options: .regularExpression) != nil {
                            Button("확인") {}
                        } else {
                            
                            // 중복된 닉네임 입력
                            if fireStoreViewModel.nickNameCheck(nickName: nickNameText) == false {
                                Button("확인") {}
                                
                                // 사용 가능 닉네임 입력
                            } else if fireStoreViewModel.nickNameCheck(nickName: nickNameText) == true {
                                Button("취소") {}
                                
                                Button("확인") {
                                    kakaoAuthViewModel.userNicName = nickNameText
                                    let userProfile = Msg(id: Auth.auth().currentUser?.uid ?? "", nickName: nickNameText, profilImage: "", game: "", gameHistory: nil, friend: nil)
                                    loginViewModel.currentUserProfile = userProfile
                                    fireStoreViewModel.addUserInfo(user: userProfile, downloadUrl: "")
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                            }
                        }
                        
                    } message: {
                        
                        // 닉네임 미입력
                        if nickNameText.isEmpty {
                            Text("닉네임을 확인하세요.")
                            
                        // 닉네임 6자리 이하 입력
                        } else if nickNameText.range(of: ".{7,100}$", options: .regularExpression) != nil {
                            Text("닉네임을 확인하세요.")
                        } else {
                            
                            // 중복된 닉네임 입력
                            if fireStoreViewModel.nickNameCheck(nickName: nickNameText) == false {
                                Text("닉네임을 확인하세요.")
                                
                            // 사용 가능 닉네임 입력
                            } else if fireStoreViewModel.nickNameCheck(nickName: nickNameText) == true {
                                Text("가입하시겠습니까?")
                            }
                        }
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
