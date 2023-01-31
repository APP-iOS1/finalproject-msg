//
//  SoloGameSettingView.swift
//  MSG
//
//  Created by sehooon on 2023/01/30.
//

import SwiftUI

struct SoloGameSettingView: View {
    
    @ObservedObject private var gameSettingViewModel = GameSettingViewModel()
    @EnvironmentObject var notiManager: NotificationManager
    @State private var isShowingAlert: Bool = false
    @EnvironmentObject var fireStoreViewModel: FireStoreViewModel
    private let dateFormatter = DateFormatter()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        GeometryReader { g in
            ZStack {
                Color("Color1").ignoresSafeArea()
                VStack(spacing: 20) {
                    Spacer()
                    
                    // MARK: - 챌린지 주제- [TextField]
                    HStack{
                        Text("챌린지 주제: ")
                            .modifier(TextViewModifier())
                        VStack{
                            TextField("ex) 하루 만원으로 버티기!", text: $gameSettingViewModel.title)
                                .keyboardType(.default)
                            Divider()
                        }
                    }
                    .padding([.leading, .trailing])
                    // MARK: - 목표금액 - [TextField]
                    HStack{
                        Text("목표금액: ")
                            .modifier(TextViewModifier())
                        
                        VStack{
                            TextField("ex) 300,000", text: $gameSettingViewModel.targetMoney)
                                .keyboardType(.numberPad)
                            Divider()
                            
                        }
                    }
                    .padding([.leading, .trailing])
                    
                    // MARK: - 챌린지 기간 - [DatePicker]
                    VStack{
                        HStack{
                            Text("챌린지 기간 설정")
                                .modifier(TextViewModifier())
                            Spacer()
                        }
                        
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
                    .padding()
                    .padding(.bottom ,50)
                    
                    // MARK: - 시작하기 - [Button]
                    Button(action: {
                        isShowingAlert = true
                    }) {
                        Text("시작하기")
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
                    .alert(notiManager.isGranted ? "챌린지를 시작하시겠습니까?" : "알림을 허용해주세요", isPresented: $isShowingAlert, actions: {
                        Button("시작하기") {
                            Task{
                                if !notiManager.isGranted {
                                    notiManager.openSetting()
                                } else {
                                    print("도전장 보내짐")
                                    let localNotification = LocalNotification(identifier: UUID().uuidString, title: "챌린지가 시작되었습니다!", body: "야호", timeInterval: 1, repeats: false)
                                    let singGame = Challenge(id: UUID().uuidString, gameTitle: gameSettingViewModel.title, limitMoney: Int(gameSettingViewModel.targetMoney) ?? 0, startDate:  String(gameSettingViewModel.startDate.timeIntervalSince1970), endDate:  String(gameSettingViewModel.endDate.timeIntervalSince1970 + 10), inviteFriend: [], waitingFriend: [])
                                    dismiss()
                                    await fireStoreViewModel.makeSingleGame(singGame)
                                    await notiManager.schedule(localNotification: localNotification)
                                    await notiManager.getPendingRequests()
                                }
                            }
                        }
                        Button("취소하기") {
                            //   dismiss()
                        }
                    }, message: {
                        if notiManager.isGranted {
                            Text("챌린지가 시작되면 내용 변경이 불가능합니다.")
                        }
                    })
                    Spacer()
                }
                .foregroundColor(Color("Color2"))
            }
        }
    }
}

struct SoloGameSettingView_Previews: PreviewProvider {
    static var previews: some View {
        SoloGameSettingView()
            .environmentObject(NotificationManager())
            .environmentObject(FireStoreViewModel())
    }
}
