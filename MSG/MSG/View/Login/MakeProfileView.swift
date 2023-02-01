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
    
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @State private var profileImage: UIImage? = nil
    
    @EnvironmentObject var kakaoAuthViewModel: KakaoViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        GeometryReader { g in
            
            ZStack {
                Color("Color1").ignoresSafeArea()
                
                VStack {
                    // 앱 이름
                        VStack(alignment: .leading) {
                            Text("MSG")
                                .modifier(TextTitleBold())
                            Text("Money Save Game")
                                .modifier(TextViewModifier(color: "Color2"))
                        }
                        .frame(width: g.size.width / 1.1 ,height: g.size.height / 7, alignment: .leading)
                    
                    VStack {
                        // 프로필 사진
                        HStack {
                            Text("프로필 사진")
                                .modifier(TextTitleBold())
                            Spacer()
                            PhotosPicker(selection: $selectedPhotoItem, matching: .images, photoLibrary: .shared()) {
                                Text("선택하기")
                                    .modifier(TextViewModifier(color: "Color2"))
                            }
                            .onChange(of: selectedPhotoItem) { newItem in
                                Task {
                                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                        selectedImageData = data
                                        if let image = UIImage(data: selectedImageData!) { profileImage = image}
                                    }
                                }
                            }
                        }
                        .frame(width: g.size.width / 1.1)
                        
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
                                .frame(width: g.size.width / 1.1, height: g.size.height / 3)
                            
                            // 사진을 선택했을 경우 변경하기
                            if selectedImageData == nil {
                                Image(systemName: "person.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: g.size.height / 5)
                            } else {
                                if let selectedImageData,
                                   profileImage != nil {
                                    Image(uiImage: profileImage!)
                                        .resizable()
                                        .clipShape(Circle())
                                        .frame(width: g.size.width / 2, height: g.size.height / 5)
                                }
                            }
                        }
                    }
                    
                    VStack {
                        // 닉네임
                        HStack {
                            Text("닉네임")
                                .modifier(TextTitleBold())
                            Spacer()
                        }
                        .padding(.leading)
                        
                        HStack {
                            TextField("닉네임을 입력하세요", text: $nickNameText)
                                .modifier(TextViewModifier(color: "Color2"))
                            
                            // MARK: 닉네임 체크 이미지
                            HStack {
                                // 닉네임 미입력
                                if nickNameText.isEmpty {
                                    Image(systemName: "multiply.circle.fill")
//                                        .foregroundColor(.red)
                                    
                                    // 닉네임 6자리 이하 입력
                                } else if nickNameText.range(of: ".{7,100}$", options: .regularExpression) != nil {
                                    Image(systemName: "multiply.circle.fill")
//                                        .foregroundColor(.red)
                                } else {
                                    
                                    // 중복된 닉네임 입력
                                    if fireStoreViewModel.nickNameCheck(nickName: nickNameText) == false {
                                        Image(systemName: "multiply.circle.fill")
//                                            .foregroundColor(.red)
                                        
                                        // 사용 가능 닉네임 입력
                                    } else if fireStoreViewModel.nickNameCheck(nickName: nickNameText) == true {
                                        Image(systemName: "checkmark.circle.fill")
//                                            .foregroundColor(.blue)
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
                                Text("")
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
                        .modifier(TextViewModifier(color: "Color2"))
                        .padding(.leading)
                    }
                    .frame(height: g.size.height / 5)
                    
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
                                    Task{
                                        kakaoAuthViewModel.userNicName = nickNameText
                                        let userProfile = Msg(id: Auth.auth().currentUser?.uid ?? "", nickName: nickNameText, profileImage: "", game: "", gameHistory: nil)
                                        await fireStoreViewModel.uploadImageToStorage(userImage: profileImage, user: userProfile)
                                        loginViewModel.currentUserProfile = try await fireStoreViewModel.fetchUserInfo(Auth.auth().currentUser?.uid ?? "")
                                        self.presentationMode.wrappedValue.dismiss()
                                    }
                                }
                            }
                        } label: {
                            Text("가입완료")
                                .modifier(TextViewModifier(color: "Color2"))
                                .frame(width: g.size.width / 1.4, height: g.size.height / 34)
                                .shadow(color: Color("Shadow3"), radius: 8, x: -9, y: -9)
                                .shadow(color: Color("Shadow"), radius: 8, x: 9, y: 9)
                                .padding(20)
                                .background(Color("Color1"))
                                .cornerRadius(20)
                        }
                        .shadow(color: Color("Shadow3"), radius: 8, x: -9, y: -9)
                        .shadow(color: Color("Shadow"), radius: 8, x: 9, y: 9)
                    } // VStack: 가입 완료 버튼
                }
                
            }
            .foregroundColor(Color("Color2"))
        }
    }
      
}

struct MakeProfileView_Previews: PreviewProvider {
    static var previews: some View {
        MakeProfileView()
    }
}
