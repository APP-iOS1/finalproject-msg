//
//  gameSettingView.swift
//  MSG
//
//  Created by sehooon on 2023/01/17.
//

import SwiftUI
import Combine

struct GameSettingView: View {
    enum Field: Hashable {
        case title
        case limitMoney
    }
    
    @Environment(\.dismiss) var dismiss
    
    @FocusState private var focusedField: Field?
    @EnvironmentObject var notiManager: NotificationManager
    @EnvironmentObject var realtimeViewModel: RealtimeViewModel
    @StateObject private var gameSettingViewModel = GameSettingViewModel()
}


extension GameSettingView {
    
    var body: some View {
        
        GeometryReader { g in
            ZStack {
                Color("Color1").ignoresSafeArea()
                
                VStack {
                    VStack {
                        // MARK: - 챌린지 주제- [TextField]
                        VStack(alignment: .leading){
                            HStack {
                                Text("챌린지 주제")
                                    .modifier(TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.title2, color: FontCustomColor.color2))
                                
                                Spacer()
                            }
                            .frame(width: g.size.width / 1.2, height: g.size.height / 30)
                            
                            Spacer()
                            
                            HStack{
                                TextField("", text: $gameSettingViewModel.title)
                                    .placeholder(when: gameSettingViewModel.title.isEmpty) {
                                        Text("ex) 치킨걸고 30만원 챌린지!")
                                            .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.body, color: FontCustomColor.color3))
                                    }
                                    .keyboardType(.default)
                                    .focused($focusedField, equals: .title)
                                    .onSubmit { focusedField = .limitMoney }
                                    .submitLabel(.done)
                                    .onAppear{ focusedField = .title }
                                
                                Spacer()
                                    Button {
                                        gameSettingViewModel.title = ""
                                    } label: {
                                        Image(systemName: gameSettingViewModel.title.isEmpty ? "delete.left" : "delete.left.fill")
                                    }
                            }
                            .frame(width: g.size.width / 1.2, height: g.size.height / 30)
                        }
                        .frame(width: g.size.width / 1.2, height: g.size.height / 11)
                        
                        VStack {
                            Spacer()
                            Divider()
                            Spacer()
                        }
                        
                        // MARK: - 목표금액 - [TextField]
                        VStack(alignment: .leading){
                            HStack {
                                Text("한도 금액")
                                    .modifier(TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.title2, color: FontCustomColor.color2))
                                
                                Spacer()
                            }
                            .frame(width: g.size.width / 1.2, height: g.size.height / 30)
                            
                            HStack {
                                ZStack(alignment: .leading) {
                                    if !gameSettingViewModel.targetMoney.insertComma.isEmpty {
                                        Text("\(gameSettingViewModel.targetMoney.insertComma)원")
                                            .multilineTextAlignment(.leading)
                                    }
                                    TextField("", text: $gameSettingViewModel.targetMoney)
                                        .placeholder(when: gameSettingViewModel.targetMoney.isEmpty) {
                                            Text("1,000만원 미만으로 입력하세요")
                                                .kerning(0)
                                                .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.body, color: FontCustomColor.color3))
                                        }
                                        .focused($focusedField, equals: .limitMoney)
                                        .foregroundColor(Color(.clear))
                                        .kerning(+1.5)
                                        .keyboardType(.numberPad)
                                }
                                .frame(width: g.size.width / 1.4, height: g.size.height / 40)
                                Spacer()
                                    Button {
                                        gameSettingViewModel.targetMoney = ""
                                    } label: {
                                        Image(systemName: gameSettingViewModel.targetMoney.isEmpty ?  "delete.left" : "delete.left.fill")
                                    }
                            }
                            .frame(width: g.size.width / 1.2, height: g.size.height / 30)
                        }
                        .frame(width: g.size.width / 1.2, height: g.size.height / 11)
                        
                        VStack {
                            Spacer()
                            Divider()
                            Spacer()
                        }
                        
                        // MARK: - 챌린지 기간 - [DateSheet]
                        VStack(alignment: .leading){
                            HStack {
                                Text("챌린지 기간")
                                    .modifier(TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.title2, color: FontCustomColor.color2))
                                Spacer()
                            }
                            .frame(width: g.size.width / 1.2, height: g.size.height / 30)
                            
                            Spacer()
                            
                            HStack {
                                if gameSettingViewModel.daySelection == 5 {
                                    Text("챌린지 기간을 설정해주세요")
                                        .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.body, color: FontCustomColor.color3))
                                } else {
                                    Text("\(gameSettingViewModel.dayArray[gameSettingViewModel.daySelection])")
                                }
                                
                                Spacer()
                                
                                // MARK: - [날짜 선택 버튼]
                                Button {
                                    gameSettingViewModel.showingDaySelection.toggle()
                                } label: {
                                    Image(systemName: "chevron.backward")
                                        .rotationEffect(.degrees(-90))
                                        .foregroundColor(gameSettingViewModel.daySelection == 5 ? Color("Color3") : Color("Color2"))
                                }
                                .sheet(isPresented: $gameSettingViewModel.showingDaySelection) {
                                    DateSheetView(gameSettingViewModel: gameSettingViewModel, parentScreen: g)
                                        .frame(height: g.size.height / 6)
                                        .presentationDetents([.height(g.size.height / 6)])
                                        .interactiveDismissDisabled(true)
                                    // ZStack
                                } // sheet
                                
                            }
                            .frame(width: g.size.width / 1.2, height: g.size.height / 30)
                            
                        }
                        .frame(width: g.size.width / 1.2, height: g.size.height / 11)
                        
                        VStack {
                            Spacer()
                            Divider()
                            Spacer()
                        }
                        
                        // MARK: - 같이할 친구들
                        VStack(alignment: .leading) {
                            HStack{
                                Text("함께할 친구들")
                                    .modifier(TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.title2, color: FontCustomColor.color2))
                                Spacer()
                            }
                            .frame(width: g.size.width / 1.2, height: g.size.height / 30)
                            
                            Spacer()
                            
                            HStack {
                                //
                                if !gameSettingViewModel.invitingFriendList.isEmpty{
                                    ForEach(gameSettingViewModel.invitingFriendList, id: \.self) {friend in
                                        HStack {
                                            Text(friend.nickName)
                                                .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.footnot, color: FontCustomColor.color1))
                                                .frame(width: g.size.width / 5, height: g.size.height / 40)
                                                .padding(6)
                                                .background(Color("Color2"))
                                                .cornerRadius(7)
                                        }
                                        .listRowBackground(Color("Color1"))
                                    }
                                    .listStyle(.automatic)
                                    .foregroundColor(Color("Color1"))
                                    .background(Color("Color1"))
                                    .scrollContentBackground(.hidden)
                                }else{
                                    Text("함께할 친구를 선택해주세요")
                                        .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.body, color: FontCustomColor.color3))
                                }
                                
                                Spacer()
                                
                                Button {
                                    Task{
                                        gameSettingViewModel.findFriendToggle.toggle()
                                        await gameSettingViewModel.fetchMyFriendList()
                                    }
                                } label: {
                                    Image(systemName: "chevron.backward")
                                        .rotationEffect(.degrees(-90))
                                        .foregroundColor(gameSettingViewModel.invitingFriendList.isEmpty ? Color("Color3") : Color("Color2"))
                                }
                                .sheet(isPresented: $gameSettingViewModel.findFriendToggle) {
                                    ScrollView{
                                        ForEach(gameSettingViewModel.displayFriend, id:\.self) { friend in
                                            ChallengeFriendCellView(gameSettingViewModel: gameSettingViewModel, friend: friend, parentScreen: g)
                                        }
                                    }
                                    .padding()
                                    .presentationDetents([.height(350)])
                                    .presentationDragIndicator(.visible)
                                }
                                
                                
                            }
                            .frame(width: g.size.width / 1.2, height: g.size.height / 30)
                        }
                        .modifier(ListBackgroundModifier())
                        .frame(width: g.size.width / 1.2, height: g.size.height / 11)
                        
                        VStack {
                            Spacer()
                            Divider()
                            Spacer()
                        }
                    }
                    .frame(width: g.size.width / 1.2, height: g.size.height / 1.7)
                    
                    // MARK: - 초대장 보내기 Button
                    Spacer()
                    VStack {
                        Button {
                            gameSettingViewModel.isShowingAlert = true
                        } label: {
                            Text("초대장 보내기")
                                .modifier(!gameSettingViewModel.isGameSettingValid || realtimeViewModel.inviteFriendArray.isEmpty ? TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.title3, color: FontCustomColor.color3) : TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.title3, color: FontCustomColor.color2))
                        }
                        .buttonStyle(.borderless)
                        .frame(width: g.size.width / 1.4, height: g.size.height / 14)
                        .shadow(color: Color("Shadow3"), radius: 6, x: -7, y: -7)
                        .shadow(color: Color("Shadow"), radius: 6, x: 7, y: 7)
                        .padding(5)
                        .background(Color("Color1"))
                        .cornerRadius(10)
                        .shadow(color: Color("Shadow3"), radius: 6, x: -7, y: -7)
                        .shadow(color: Color("Shadow"), radius: 6, x: 7, y: 7)
                        .disabled(!gameSettingViewModel.isGameSettingValid)
                        .padding([.leading, .bottom, .trailing])
                    }
                    
                    Spacer()
                    
                }
                .frame(width: g.size.width / 1.2, height: g.size.height / 1.2)
                .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.body, color: FontCustomColor.color2))
                
                Spacer()
            }
            .onAppear { gameSettingViewModel.resetInputData() }
        }
        .ignoresSafeArea(.keyboard)
        .onTapGesture { self.endTextEditing() }
        .alert("챌린지를 시작하시겠습니까?", isPresented: $gameSettingViewModel.isShowingAlert, actions: {
            Button("시작하기") {
                Task{
                    if !notiManager.isGranted {
                        await gameSettingViewModel.createMultiChallenge()
                        // UserInfo 가져오기
                        // UserUseCase
                        // realtimeViewModel.sendFightRequest(to: realtimeViewModel.inviteFriendArray, from: myInfo, isFight: true)
                        dismiss()
                    } else {
                        print("도전장 보내짐?")
                        let localNotification = LocalNotification(identifier: UUID().uuidString, title: "도전장을 보냈습니다.", body: "상대방이 도전을 수락하면 시작됩니다.", timeInterval: 1, repeats: false)
                        await gameSettingViewModel.createMultiChallenge()
                        //[UserUseCase에서 유저정보 가져오기]
                        //                        realtimeViewModel.sendFightRequest(to: realtimeViewModel.inviteFriendArray, from: myInfo, isFight: true)
                        dismiss()
                        await notiManager.schedule(localNotification: localNotification)
                        await notiManager.doSomething()
                        await notiManager.getPendingRequests()
                    }
                }
            }
            Button("취소하기") {
            }
        }, message: {
            if notiManager.isGranted {
                Text("챌린지가 시작되면 내용 변경이 불가능합니다.")
            }
        })
        .alert("작성을 중단하시겠습니까?", isPresented: $gameSettingViewModel.backBtnAlert, actions: {
            Button {
                
            } label: {
                Text("취소")
            }
            
            Button {
                dismiss()
                gameSettingViewModel.resetInputData()
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
                    gameSettingViewModel.backBtnAlert = true
                } label: {
                    Image(systemName:"chevron.backward")
                }
            }
        }
    }
}





struct GameSettingView_Previews: PreviewProvider {
    static var previews: some View {
        GameSettingView()
            .environmentObject(NotificationManager())
            .environmentObject(RealtimeViewModel())
    }
}
