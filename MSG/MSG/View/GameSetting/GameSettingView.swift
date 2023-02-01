//
//  gameSettingView.swift
//  MSG
//
//  Created by sehooon on 2023/01/17.
//

import SwiftUI

struct GameSettingView: View {
    @EnvironmentObject var notiManager: NotificationManager
    @ObservedObject private var gameSettingViewModel = GameSettingViewModel()
    @State private var isShowingAlert: Bool = false
    @EnvironmentObject var friendViewModel: FriendViewModel
    @EnvironmentObject var realtimeViewModel: RealtimeViewModel
    @EnvironmentObject var fireStoreViewModel: FireStoreViewModel
    @State private var findFriendToggle: Bool = false
    
    // Back button 클릭 시, 입력중인 data가 있다면, backBtnAlert
    @State private var backBtnAlert: Bool = false
    @Environment(\.dismiss) var dismiss
    
    @State private var summitAlertToggle: Bool = false // 공백문자만 있으면 띄우는 얼럿
    
    //텍스트필드 공백체크
    private var trimsTitleTextField: String {
        gameSettingViewModel.title.trimmingCharacters(in: .whitespaces)
    }
    
    private var trimTargetMoneyTextField: String {
        gameSettingViewModel.targetMoney.trimmingCharacters(in: .whitespaces)
    }
}


extension GameSettingView {
    
    var body: some View {
        
        GeometryReader { g in
            ZStack {
                Color("Color1").ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // MARK: - 챌린지 주제- [TextField]
                    HStack{
                        Text("챌린지 주제: ")
                            .modifier(TextViewModifier(color: "Color2"))
                        VStack{
                            TextField("ex) 치킨걸고 30만원 챌린지!", text: $gameSettingViewModel.title)
                                .keyboardType(.default)
                                .modifier(TextViewModifier(color: "Color2"))
                            Divider()
                        }
                    }
                    .padding([.leading, .trailing])
                    
                    // MARK: - 목표금액 - [TextField]
                    HStack{
                        Text("목표금액: ")
                            .modifier(TextViewModifier(color: "Color2"))
                        VStack{
                            TextField("ex) 300,000", text: $gameSettingViewModel.targetMoney)
                                .keyboardType(.numberPad)
                                .modifier(TextViewModifier(color: "Color2"))
                            Divider()
                            
                        }
                    }
                    .padding([.leading, .trailing])
                    
                    // MARK: - 챌린지 기간 - [DatePicker]
                    VStack{
                        HStack{
                            Text("챌린지 기간 설정")
                                .modifier(TextViewModifier(color: "Color2"))
                            Spacer()
                        }
                        .padding([.leading, .trailing])
                        
                        VStack{
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
                                
                                HStack{
                                    VStack{
                                        Text("시작")
                                            .modifier(TextViewModifier(color: "Color2"))
                                        DatePicker("", selection: $gameSettingViewModel.startDate, in: Date.now...,displayedComponents: .date)
                                            .frame(width: g.size.width / 5)
                                            .id(gameSettingViewModel.startDate)
                                            .onChange(of: gameSettingViewModel.startDate) { _ in
                                                gameSettingViewModel.startDate += 1
                                            }
                                    }
                                    Spacer()
                                        .frame(width: g.size.width / 5)
                                    
                                    VStack{
                                        Text("종료")
                                            .modifier(TextViewModifier(color: "Color2"))
                                        DatePicker("", selection: $gameSettingViewModel.endDate,in:gameSettingViewModel.startDate... , displayedComponents: .date)
                                            .frame(width: g.size.width / 5)
                                            .id(gameSettingViewModel.endDate)
                                            .onChange(of: gameSettingViewModel.endDate) { _ in
                                                gameSettingViewModel.endDate += 1
                                            }
                                    }
                                    .padding(.trailing)
                                }
                            }
                        }
                    }
                    .padding(.bottom ,50)
                    
                    if !realtimeViewModel.inviteFriendArray.isEmpty {
                        List(realtimeViewModel.inviteFriendArray) {friend in
                            HStack {
                                if friend.profileImage.isEmpty{
                                    Image(systemName: "Person")
                                        .resizable()
                                        .frame(width: g.size.width / 15, height:g.size.width / 15)
                                        .clipShape(Circle())
                                        .scaledToFit()
                                }else{
                                    AsyncImage(url: URL(string: friend.profileImage)!) { Image in
                                        Image
                                            .resizable()
                                            .frame(width: g.size.width / 15, height:g.size.width / 15)
                                            .clipShape(Circle())
                                            .scaledToFit()
                                    } placeholder: {
                                        Image(systemName: "Person")
                                            .resizable()
                                            .frame(width: g.size.width / 15, height:g.size.width / 15)
                                            .clipShape(Circle())
                                            .scaledToFit()
                                    }
                                }
                                Text(friend.nickName)
                                    .foregroundColor(Color("Color2"))
                                Spacer()
                                Button {
                                    //
                                } label: {
                                    Image(systemName: "minus")
                                }
                                
                            }
                            .foregroundColor(Color("Color1"))
                            .listRowBackground(Color("Point1"))
                        }
                        .background(Color("Color1"))
                        .listStyle(.automatic)
                        .modifier(ListBackgroundModifier())
                    }
                    
                    // MARK: - 친구찾기 - [Button]
                    Button(action: {
                        findFriendToggle = true
                    }, label: {
                        // HStack{
                        
                        HStack{
                            Text("친구찾기")
                            Image(systemName: "magnifyingglass")
                        }
                        .frame(width: g.size.width / 1.4, height: g.size.height / 34)
                        .shadow(color: Color("Shadow3"), radius: 8, x: -9, y: -9)
                        .shadow(color: Color("Shadow"), radius: 8, x: 9, y: 9)
                        .padding(20)
                        .background(Color("Color1"))
                        .cornerRadius(20)
                        .shadow(color: Color("Shadow3"), radius: 8, x: -9, y: -9)
                        .shadow(color: Color("Shadow"), radius: 8, x: 9, y: 9)
                    })
                    .padding([.leading, .bottom, .trailing])
                    
                    
                    // MARK: - 초대장 보내기 Button
                    Button {
                        if trimsTitleTextField.count > 0 && trimTargetMoneyTextField.count > 0 {
                            isShowingAlert = true
                        } else { //공백문자만 있을 때
                            summitAlertToggle = true
                        }
                    } label: {
                        Text("초대장 보내기")
                            .frame(width: g.size.width / 1.4, height: g.size.height / 34)
                            .shadow(color: Color("Shadow3"), radius: 8, x: -9, y: -9)
                            .shadow(color: Color("Shadow"), radius: 8, x: 9, y: 9)
                            .padding(20)
                            .background(Color("Color1"))
                            .cornerRadius(20)
                            .shadow(color: Color("Shadow3"), radius: 8, x: -9, y: -9)
                            .shadow(color: Color("Shadow"), radius: 8, x: 9, y: 9)
                    }
                    .disabled(!gameSettingViewModel.isGameSettingValid)
                    .padding([.leading, .bottom, .trailing])
                    .sheet(isPresented: $findFriendToggle) {
                        FriendView(findFriendToggle: $findFriendToggle)
                            .presentationDetents([.height(350)])
                            .presentationDragIndicator(.visible)
                        //                        Spacer()
                    }
                }
                
                .modifier(TextViewModifier(color: "Color2"))
                .foregroundColor(Color("Color2"))
                .alert("필수항목을 모두 작성해주세요.", isPresented: $summitAlertToggle, actions: {
                    Button("확인") {}
                })
                .alert(notiManager.isGranted ? "챌린지를 시작하시겠습니까?" : "알림을 허용해주세요", isPresented: $isShowingAlert, actions: {
                    Button("시작하기") {
                        Task{
                            if !notiManager.isGranted {
                                notiManager.openSetting()
                            } else {
                                print("도전장 보내짐?")
                                let localNotification = LocalNotification(identifier: UUID().uuidString, title: "도전장을 보냈습니다.", body: "도전을 받게되면 시작됩니다.", timeInterval: 1, repeats: false)
                                let challenge = Challenge(
                                    id: UUID().uuidString,
                                    gameTitle: gameSettingViewModel.title,
                                    limitMoney: Int(gameSettingViewModel.targetMoney)!,
                                    startDate: String(gameSettingViewModel.startDate.timeIntervalSince1970) ,
                                    endDate: String(gameSettingViewModel.endDate.timeIntervalSince1970),
                                    inviteFriend: [], waitingFriend: realtimeViewModel.inviteFriendIdArray)
                                await fireStoreViewModel.addMultiGame(challenge)
                                guard let myInfo = fireStoreViewModel.myInfo else { return }
                                //                            print("myInfo: \(myInfo)")
                                print(realtimeViewModel.inviteFriendArray)
                                realtimeViewModel.sendFightRequest(to: realtimeViewModel.inviteFriendArray, from: myInfo, isFight: true)
                                dismiss()
                                await notiManager.schedule(localNotification: localNotification)
                                await notiManager.getPendingRequests()
                            }
                        }
                    }
                    Button("취소하기") {
                        // dismiss()
                    }
                }, message: {
                    if notiManager.isGranted {
                        Text("챌린지가 시작되면 내용 변경이 불가능합니다.")
                    }
                })
                Spacer()
            }
        }
        .alert("뒤로 가기", isPresented: $backBtnAlert, actions: {
            Button {
                
            } label: {
                Text("취소")
            }
            
            Button {
                dismiss()
                gameSettingViewModel.resetInputData()
                realtimeViewModel.resetInviteFriend()
            } label: {
                Text("확인")
            }

        }, message: {
            Text("현재 작성중인 항목이 삭제될 수 있습니다.")
        })
        .navigationBarBackButtonHidden(true)
        .toolbar{
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Button {
                    backBtnAlert = true
                } label: {
                    Image(systemName:"chevron.backward")
                }
    
            }
        }
        .onAppear{
            fireStoreViewModel.findFriend()
        }
    }
}

struct GameSettingView_Previews: PreviewProvider {
    static var previews: some View {
        GameSettingView()
            .environmentObject(NotificationManager())
            .environmentObject(FriendViewModel())
            .environmentObject(RealtimeViewModel())
            .environmentObject(FireStoreViewModel())
        
    }
}
