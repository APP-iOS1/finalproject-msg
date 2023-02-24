//
//  SettingView.swift
//  MSG
//
//  Created by zooey on 2023/01/18.
//
import SwiftUI
import PhotosUI

struct SettingView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    @EnvironmentObject var fireStoreViewModel: FireStoreViewModel
    @State var userProfile: Msg?
    @Binding var darkModeEnabled: Bool
    @State private var logoutToggle: Bool = false
    @State private var deleteToggle: Bool = false
    @State private var text: String = ""
    @State private var profileEditing: Bool = false
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @State private var profileImage: UIImage? = nil
    @EnvironmentObject var notiManager: NotificationManager
    
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
                            .frame(minWidth: g.size.width / 1.5, minHeight: g.size.height / 4)
                        
                        VStack(spacing: 0) {
                                VStack {
                                    ZStack {
                                        // MARK: 프로필 편집 모드 On
                                        if profileEditing == true {
                                            HStack {
                                                Spacer()
                                                ZStack {
                                                    // 선택된 이미지가 없는 경우
                                                    if selectedItem == nil {
                                                        // 사진 선택 버튼
                                                        PhotosPicker(
                                                            selection: $selectedItem,
                                                            matching: .images,
                                                            photoLibrary: .shared()) {
                                                                Spacer()
                                                                Text("사진선택   |")
                                                                    .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.caption, color: FontCustomColor.color2))
                                                            }
                                                        // 선택된 이미지가 있는 경우
                                                    } else {
                                                        // 선택 완료 버튼
                                                        Button(action: {
                                                            selectedItem = nil
                                                            profileEditing = false
                                                            if let selectedImageData,
                                                               let uiImage = UIImage(data: selectedImageData) {
                                                                let userProfile = Msg(id: fireStoreViewModel.myInfo?.id ?? "", nickName: userProfile!.nickName, profileImage: fireStoreViewModel.myInfo?.profileImage ?? "", game: fireStoreViewModel.myInfo?.game ?? "")
                                                                Task{
                                                                    await fireStoreViewModel.uploadImageToStorage(userImage: uiImage, user: userProfile)
                                                                    fireStoreViewModel.myInfo = try await fireStoreViewModel.fetchUserInfo(self.userProfile?.id ?? "")
                                                                }
                                                            }
                                                        }) {
                                                            Text("   선택완료    |")
                                                                .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.caption, color: FontCustomColor.color2))
                                                        }
                                                    }
                                                }
                                                
                                                // 선택 취소 버튼
                                                Button(action: {
                                                    selectedItem = nil
                                                    selectedImageData = nil
                                                    profileEditing = false
                                                }) {
                                                    Text("  취소  ")
                                                        .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.caption, color: FontCustomColor.color2))
                                                }
                                            }
                                            
                                        // MARK: 프로필 편집 모드 Off
                                        } else {
                                            HStack{
                                                Spacer()
                                            }
                                        }
                                    }
                                    .padding(.trailing)
                                    .padding(.top, -g.size.height / 18)
                                    .padding(.bottom, 5)
                                    .onChange(of: selectedItem) { newItem in
                                        Task {
                                            // Retrive selected asset in the form of Data
                                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                                selectedImageData = data
                                            }
                                        }
                                    }
                                    
                                    // 선택된 이미지 데이터가 없는 경우
                                    if selectedImageData == nil {
                                        // 유저 프로필 이미지가 없는 경우
                                        if userProfile == nil || userProfile!.profileImage.isEmpty{
                                            Image(systemName: "person.circle")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: g.size.width / 3, height: g.size.height / 7)
                                            
                                            // 유저 프로필 이미지가 있는 경우
                                        } else {
                                            // 이미지 불러오기
                                            AsyncImage(url: URL(string: userProfile!.profileImage)) { Image in
                                                Image
                                                    .resizable()
                                                    .clipShape(Circle())
                                                    .frame(width: g.size.width / 3, height: g.size.height / 7)
                                            } placeholder: {
                                                Image(systemName: "person.circle")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: g.size.width / 3, height: g.size.height / 7)
                                                    .aspectRatio(contentMode: .fill)
                                            }
                                        }
                                    // 선택된 이미지 데이터가 있는 경우
                                    } else {
                                        if profileImage != nil {
                                            Image(uiImage: profileImage!)
                                                .resizable()
                                                .clipShape(Circle())
                                                .frame(width: g.size.width / 3, height: g.size.height / 7)
                                                .aspectRatio(contentMode: .fill)
                                        } else {
                                            if let selectedImageData,
                                               let uiImage = UIImage(data: selectedImageData) {
                                                Image(uiImage: uiImage)
                                                    .resizable()
                                                    .clipShape(Circle())
                                                    .frame(width: g.size.width / 3, height: g.size.height / 7)
                                                    .aspectRatio(contentMode: .fill)
                                            }
                                        }
                                    }
                                }
                                .frame(height: g.size.height / 6)
                            
                            HStack {
                                Text( userProfile != nil ? userProfile!.nickName : "닉네임")
                                    .modifier(TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.title3, color: FontCustomColor.color2))
                                    .padding(.top, 5)
                            }
                        }
                    }
                    .frame(width: g.size.width / 1.1, height: g.size.height / 4)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            Text("다크모드")
                            Spacer()
                            DarkModeToggle(width: g.size.width / 4.7, height: g.size.height / 22, toggleWidthOffset: 12, cornerRadius: 15, padding: 4, darkModeEnabled: $darkModeEnabled)
                        }
                        
                        Button {
                            notiManager.openSetting()
                        } label: {
                            Text("알림설정")
                        }
                        
                        
                        //                        HStack {
                        //                            Text("알림설정")
                        //                            Spacer()
                        //                            NotificationToggle(width: g.size.width / 4.7, height: g.size.height / 22, toggleWidthOffset: 12, cornerRadius: 15, padding: 4, notificationEnabled: $notificationEnabled)
                        //                        }
                        
                        Button {
                            profileEditing.toggle()
                        } label: {
                            Text("프로필 편집")
                        }
                        
                        // 이메일, sms, 공유하기, 시트뷰로 보여주기
                        Button {
                            buttonAction("https://apps.apple.com/kr/app/msg/id1670628313", .share)
                        } label: {
                            Text("친구초대")
                        }
                        
                        NavigationLink {
                            LicenseView()
                        } label: {
                            Text("라이센스")
                        }
                        
                        Button {
                            logoutToggle.toggle()
                        } label: {
                            Text("로그아웃")
                        }
                        .alert("로그아웃", isPresented: $logoutToggle) {
                            Button("확인", role: .destructive) {
                                Task {await fireStoreViewModel.initAllItem()}
                                loginViewModel.signout()
                                
                            }
                            Button("취소", role: .cancel) {}
                        } message: {
                            Text("로그아웃하시겠습니까?")
                        }
                        Button {
                            if fireStoreViewModel.currentGame == nil {
                                deleteToggle.toggle()
                            } else {
                                // 게임중에는 탈퇴할 수 없습니다...
                            }
                        }
                    label: {
                        Text("회원탈퇴")
                            .font(.custom("MaplestoryOTFLight", size: 15))
                            .foregroundColor(.red)
                    }
                    .sheet(isPresented: $deleteToggle) {
                        DeleteUserView(sheetToggle: $deleteToggle)
                            .interactiveDismissDisabled(true)
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
    private enum Coordinator {
        static func topViewController(
            _ viewController: UIViewController? = nil
        ) -> UIViewController? {
            
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            let window = windowScene?.windows
            
            let vc = viewController ?? window?.first(where: { $0.isKeyWindow })?.rootViewController
            
            if let navigationController = vc as? UINavigationController {
                return topViewController(navigationController.topViewController)
            } else if let tabBarController = vc as? UITabBarController {
                return tabBarController.presentedViewController != nil ?
                topViewController(
                    tabBarController.presentedViewController
                ) : topViewController(
                    tabBarController.selectedViewController
                )
            } else if let presentedViewController = vc?.presentedViewController {
                return topViewController(presentedViewController)
            }
            return vc
        }
    }
    
    private enum Method: String {
        case share
        case link
    }
    
    private func buttonAction(_ stringToURL: String, _ method: Method) {
        let shareURL: URL = URL(string: stringToURL)!
        
        if method == .share {
            let activityViewController = UIActivityViewController(activityItems: [shareURL], applicationActivities: nil)
            let viewController = Coordinator.topViewController()
            activityViewController.popoverPresentationController?.sourceView = viewController?.view
            viewController?.present(activityViewController, animated: true, completion: nil)
        } else {
            UIApplication.shared.open(URL(string: stringToURL)!)
        }
    }
}

struct SettignView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(darkModeEnabled: .constant(false))
    }
}
