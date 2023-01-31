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
    @Environment(\.dismiss) var dismiss
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
                                Text(friend.nickName)
                                    .foregroundColor(Color("Font"))
                                Spacer()
                                Button {
                                    //
                                } label: {
                                    Image(systemName: "minus")
                                }

                            }
                                .foregroundColor(Color("Background"))
                                .listRowBackground(Color("Point1"))
                        }
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
                        isShowingAlert = true
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
                    .padding([.leading, .bottom, .trailing])
                    .sheet(isPresented: $findFriendToggle) {
                        FriendView(findFriendToggle: $findFriendToggle)
                            .presentationDetents([.height(350)])
                            .presentationDragIndicator(.visible)
                        //                        Spacer()
                    }
                }
                .foregroundColor(Color("Color2"))
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
