//
//  gameSettingView.swift
//  MSG
//
//  Created by sehooon on 2023/01/17.
//

import SwiftUI

struct GameSettingView: View {
    
    //
    @ObservedObject private var gameSettingViewModel = GameSettingViewModel()
    @EnvironmentObject var friendViewModel: FriendViewModel
    @State private var findFriendToggle: Bool = false
    
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
                            
                            // MARK: - 챌린지 기간 - [DatePicker]
                            HStack{
                                Text("챌린지 기간")
                                    .modifier(TextViewModifier())
                                Spacer()
                                HStack(spacing: 20){
                                    VStack{
                                        Text("시작")
                                            .modifier(TextViewModifier())
                                        DatePicker("", selection: $gameSettingViewModel.startDate, in: Date.now...,displayedComponents: .date)
                                            .frame(width: 110)
                                        
                                    }
                                    VStack{
                                        Text("종료")
                                            .modifier(TextViewModifier())
                                        DatePicker("", selection: $gameSettingViewModel.endDate,in:gameSettingViewModel.startDate... , displayedComponents: .date)
                                        
                                            .frame(width: 110)
                                    }
                                }
                            }
                            .padding()
                            
                            // MARK: - 친구찾기 - [Button]
                            HStack{
                                Button(action: {
                                    findFriendToggle = true
                                }, label: {
                                    HStack{
                                        Text("친구찾기")
                                        Image(systemName: "magnifyingglass")
                                    }
                                    .modifier(TextViewModifier())
                                    
                                })
                                .sheet(isPresented: $findFriendToggle) {
                                    //
                                    FriendView(findFriendToggle: $findFriendToggle)
                                }
                                Spacer()
                            }
                            .padding()
                            Spacer()
                                .frame(height: 180)
                            
                            
                            // MARK: - 초대장 보내기 - [Button]
                            Button {
                                
                            } label: {
                                Text("초대장 보내기")
                                    .foregroundColor(Color("Font"))
                                
                            }
                            .frame(width: 300,height: 40)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color("Point2"), lineWidth: 2)
                            )
                            .disabled(!gameSettingViewModel.isGameSettingValid)
                            
                            Spacer()
                        }
                    .navigationTitle("글쓰기")
                    
                }
    }
}

struct SoloGameSettingView: View {
    
    @ObservedObject private var gameSettingViewModel = GameSettingViewModel()
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
                            
                            // MARK: - 챌린지 기간 - [DatePicker]
                            HStack{
                                Text("챌린지 기간")
                                    .modifier(TextViewModifier())
                                Spacer()
                                HStack(spacing: 20){
                                    VStack{
                                        Text("시작")
                                            .modifier(TextViewModifier())
                                        DatePicker("", selection: $gameSettingViewModel.startDate, in: Date.now...,displayedComponents: .date)
                                            .frame(width: 110)
                                        
                                    }
                                    VStack{
                                        Text("종료")
                                            .modifier(TextViewModifier())
                                        DatePicker("", selection: $gameSettingViewModel.endDate,in:gameSettingViewModel.startDate... , displayedComponents: .date)
                                        
                                            .frame(width: 110)
                                    }
                                }
                            }
                            .padding()
                            
                            // MARK: - 초대장 보내기 - [Button]
                            Button {
                                let singGame = Challenge(id: UUID().uuidString, gameTitle: gameSettingViewModel.title, limitMoney: Int(gameSettingViewModel.targetMoney) ?? 0, startDate:  String(gameSettingViewModel.startDate.timeIntervalSince1970), endDate:  String(gameSettingViewModel.endDate.timeIntervalSince1970), inviteFriend: [])
                                fireStoreViewModel.makeSingleGame(singGame)
                                dismiss()
                            } label: {
                                Text("시작하기")
                                    .foregroundColor(Color("Font"))
                                
                            }
                            .frame(width: 300,height: 40)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color("Point2"), lineWidth: 2)
                            )
                            .disabled(!gameSettingViewModel.isGameSettingValid)
                            
                            Spacer()
                        }
                    .navigationTitle("글쓰기")
                    
                }
    }
}

struct GameSettingView_Previews: PreviewProvider {
    static var previews: some View {
        GameSettingView()
    }
}
