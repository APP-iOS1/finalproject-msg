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
    var frameWidth = UIScreen.main.bounds.width
    var frameHeight = UIScreen.main.bounds.height
    @EnvironmentObject var fireStoreViewModel: FireStoreViewModel
    private let dateFormatter = DateFormatter()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            VStack{
                Spacer()
                
                // MARK: - 챌린지 주제- [TextField]
                HStack{
                    Text("챌린지 주제: ")
                        .modifier(TextViewModifier())
                    VStack{
                        TextField("ex) 치킨걸고 30만원 챌린지!", text: $gameSettingViewModel.title)
                            .keyboardType(.default)
                        Divider()
                    }
                }
                .padding()
                .padding(.leading)
                // MARK: - 목표금액 - [TextField]
                HStack{
                    Text("목표금액: ")
                        .modifier(TextViewModifier())
                    
                    VStack{
                        TextField("ex) 300000", text: $gameSettingViewModel.targetMoney)
                            .keyboardType(.numberPad)
                        Divider()
                        
                    }
                }
                .padding()
                .padding(.leading)
                
                // MARK: - 챌린지 기간 - [DatePicker]
                VStack{
                    HStack{
                        Text("챌린지 기간 설정")
                            .modifier(TextViewModifier())
                        Spacer()
                    }
                    .padding(.leading)
                    VStack{
                        HStack{
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color("Point1"), lineWidth: 1)
                            //  .fill(Color("Point1"))
                                .frame(width: 330, height: 120)
                                .overlay {
                                    HStack{
                                        VStack{
                                            Text("시작")
                                                .foregroundColor(Color("Font"))
                                            DatePicker("", selection: $gameSettingViewModel.startDate, in: Date.now...,displayedComponents: .date)
                                                .frame(width: frameWidth / 5)
                                                .id(gameSettingViewModel.startDate)
                                                .onChange(of: gameSettingViewModel.startDate) { _ in
                                                    gameSettingViewModel.startDate += 1
                                                }
                                            
                                        }
                                        Spacer()
                                            .frame(width: frameWidth / 5)
                                        
                                        VStack{
                                            Text("종료")
                                                .foregroundColor(Color("Font"))
                                            DatePicker("", selection: $gameSettingViewModel.endDate,in:gameSettingViewModel.startDate... , displayedComponents: .date)
                                                .frame(width: frameWidth / 5)
                                                .id(gameSettingViewModel.endDate)
                                                .onChange(of: gameSettingViewModel.endDate) { _ in
                                                    gameSettingViewModel.endDate += 1
                                                }
                                            
                                        }
                                        .padding(.trailing)
                                    }
                                    .foregroundColor(Color("Background"))
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
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color("Point2"))
                        .frame(width: 330,height: 60)
                        .overlay {
                            Text("시작하기")
                                .foregroundColor(Color("Background"))
                        }
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
                    .navigationTitle("글쓰기")
                
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
