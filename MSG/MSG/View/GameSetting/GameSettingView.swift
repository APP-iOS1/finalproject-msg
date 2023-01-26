//
//  gameSettingView.swift
//  MSG
//
//  Created by sehooon on 2023/01/17.
//

import SwiftUI

struct GameSettingView: View {
    
    //
    @EnvironmentObject var notiManager: NotificationManager
    @ObservedObject private var gameSettingViewModel = GameSettingViewModel()
    @ObservedObject private var fireStoreViewModel = FireStoreViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var isShowingAlert: Bool = false
    
    var frameWidth = UIScreen.main.bounds.width
    var frameHeight = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            VStack{
               // Spacer()
                
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
                .padding(.bottom)
                
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
                                .frame(width: 330, height: 120)
                                .overlay {
                                    HStack{
                                        VStack{
                                            Text("시작")
                                                .foregroundColor(Color("Font"))
                                            DatePicker("", selection: $gameSettingViewModel.startDate, in: Date.now...,displayedComponents: .date)
                                                .frame(width: frameWidth / 5)
                                            
                                        }
                                       Spacer()
                                            .frame(width: frameWidth / 5)
                                       
                                        VStack{
                                            Text("종료")
                                                .foregroundColor(Color("Font"))
                                            DatePicker("", selection: $gameSettingViewModel.endDate,in:gameSettingViewModel.startDate... , displayedComponents: .date)
                                                .frame(width: frameWidth / 5)
                                            
                                        }
                                        .padding(.trailing)
                                    }
                                    .foregroundColor(Color("Background"))
                                }
                            
                        }
                    }
                
                }
                .padding(.bottom ,50)
                
                // MARK: - 친구찾기 - [Button]
                HStack{
                    Button(action: {
                        
                    }, label: {
                       // HStack{
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("Point2"))
                                .frame(width: 330,height: 60)
                                .overlay {
                                    HStack{
                                        Text("친구찾기")
                                        Image(systemName: "magnifyingglass")
                                    }
                                    .foregroundColor(Color("Background"))
                                }
                    })
                    Spacer()
                }
                .padding([.leading, .bottom])
                
                VStack{
                    
                    Button(action: {
                        
                        isShowingAlert = true
                        
                        
                    }) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color("Point2"))
                            .frame(width: 330,height: 60)
                            .overlay {
                                Text("초대장 보내기")
                                    .foregroundColor(Color("Background"))
                            }
                        
                    }
                    
                }
                .alert(notiManager.isGranted ? "챌린지를 시작하시겠습니까?" : "알림을 허용해주세요", isPresented: $isShowingAlert, actions: {
                    Button("시작하기") {
                        Task{
                            if !notiManager.isGranted {
                                notiManager.openSetting()
                            } else {
                                print("도전장 보내짐?")
                                let localNotification = LocalNotification(identifier: UUID().uuidString, title: "도전장을 보냈습니다.", body: "도전을 받게되면 시작됩니다.", timeInterval: 1, repeats: false)
                                
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
            .padding(.horizontal)
            .navigationTitle("글쓰기")
           
           
        }
        
        .onAppear{
            fireStoreViewModel.findFriend()
            
        }
       
        
    }
}

struct SoloGameSettingView: View {
    @ObservedObject private var gameSettingViewModel = GameSettingViewModel()
    @EnvironmentObject var notiManager: NotificationManager

    @Environment(\.dismiss) private var dismiss
    @State private var isShowingAlert: Bool = false
    
    var frameWidth = UIScreen.main.bounds.width
    var frameHeight = UIScreen.main.bounds.height
     
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
                                            
                                        }
                                       Spacer()
                                            .frame(width: frameWidth / 5)
                                       
                                        VStack{
                                            Text("종료")
                                                .foregroundColor(Color("Font"))
                                            DatePicker("", selection: $gameSettingViewModel.endDate,in:gameSettingViewModel.startDate... , displayedComponents: .date)
                                                .frame(width: frameWidth / 5)
                                            
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
                VStack{
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
                    Spacer()
                }
//                .disabled(!gameSettingViewModel.isGameSettingValid)
                
                .alert(notiManager.isGranted ? "챌린지를 시작하시겠습니까?" : "알림을 허용해주세요", isPresented: $isShowingAlert, actions: {
                    Button("시작하기") {
                        Task{
                            if !notiManager.isGranted {
                                notiManager.openSetting()
                            } else {
                                print("도전장 보내짐")
                                let localNotification = LocalNotification(identifier: UUID().uuidString, title: "챌린지가 시작되었습니다!", body: "야호", timeInterval: 1, repeats: false)
                                
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
            }
            
            .navigationTitle("글쓰기")
            
        }
    }
}

struct GameSettingView_Previews: PreviewProvider {
    static var previews: some View {
        GameSettingView()
        //.environmentObject(NotificationManager())
    }
}
