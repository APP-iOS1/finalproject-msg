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
    @FocusState private var focusedField: Field?
    
    let maxConsumeMoney = Int(7)
    @EnvironmentObject var notiManager: NotificationManager
    @StateObject private var gameSettingViewModel = GameSettingViewModel()
    @State private var isShowingAlert: Bool = false
    @EnvironmentObject var friendViewModel: FriendViewModel
    @EnvironmentObject var realtimeViewModel: RealtimeViewModel
    @EnvironmentObject var fireStoreViewModel: FireStoreViewModel
    @State private var selected: Int = 0
    // Back button 클릭 시, 입력중인 data가 있다면, backBtnAlert
    @State private var backBtnAlert: Bool = false
    @Environment(\.dismiss) var dismiss
    
    @State private var summitAlertToggle: Bool = false // 공백문자만 있으면 띄우는 얼럿
    
    // 챌린지 기간 설정 시트
    @State private var showingDaySelection: Bool = false
    
    // 함께할 친구 추가 시트
    @State private var findFriendToggle: Bool = false
    
    
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
                                    .onSubmit {
                                        print("submit")
                                        focusedField = .limitMoney
                                    }
                                    .submitLabel(.done)
                                
                                Spacer()
                                
                                if gameSettingViewModel.title.isEmpty {
                                    Image(systemName: "delete.left")
                                } else {
                                    Button {
                                        gameSettingViewModel.title = ""
                                    } label: {
                                        Image(systemName: "delete.left.fill")
                                    }
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
                                    Text(gameSettingViewModel.targetMoney.insertComma)
                                        .multilineTextAlignment(.leading)
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
                                        .onReceive(Just(gameSettingViewModel.targetMoney), perform: { _ in
                                            if maxConsumeMoney < gameSettingViewModel.targetMoney.count {
                                                gameSettingViewModel.targetMoney = String(gameSettingViewModel.targetMoney.prefix(maxConsumeMoney))
                                            }
                                        })
                                }
                                .frame(width: g.size.width / 1.4, height: g.size.height / 40)
                                
                                Spacer()
                                
                                if gameSettingViewModel.targetMoney.isEmpty {
                                    Image(systemName: "delete.left")
                                } else {
                                    Button {
                                        gameSettingViewModel.targetMoney = ""
                                    } label: {
                                        Image(systemName: "delete.left.fill")
                                    }
                                }
                            }
                            .frame(width: g.size.width / 1.2, height: g.size.height / 30)
                            .toolbar {
                                ToolbarItemGroup(placement: .keyboard) {
                                    if focusedField == .limitMoney {
                                        Button("완료") {
                                            hideKeyboard()
                                        }
                                    }
                                }
                            }
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
                                
                                Button {
                                    showingDaySelection.toggle()
                                } label: {

                                    Image(systemName: "chevron.backward")
                                        .rotationEffect(.degrees(-90))
                                        .foregroundColor(gameSettingViewModel.daySelection == 5 ? Color("Color3") : Color("Color2"))
                                }
                                .sheet(isPresented: $showingDaySelection) {
                                    ZStack {
                                        Color("Color1").ignoresSafeArea()
                                        VStack {
                                            Spacer()
                                            
                                            ScrollView(.horizontal, showsIndicators: false) {
                                                HStack {
                                                    ForEach(gameSettingViewModel.dayArray.indices, id: \.self) { index in
                                                        Button {
                                                            gameSettingViewModel.daySelection = index
                                                            gameSettingViewModel.startDate = Date().timeIntervalSince1970
                                                            gameSettingViewModel.endDate = gameSettingViewModel.startDate + Double(86400) * gameSettingViewModel.dayMultiArray[index]
                                                            print("\(gameSettingViewModel.startDate - gameSettingViewModel.endDate)")
                                                        } label: {
                                                            Text("\(gameSettingViewModel.dayArray[index])")
                                                                .frame(width: g.size.width / 7, height: g.size.height / 20)
                                                                .shadow(color: Color("Shadow3"), radius: 6, x: -7, y: -7)
                                                                .shadow(color: Color("Shadow"), radius: 6, x: 7, y: 7)
                                                                .padding(8)
                                                                .background(Color("Color1"))
                                                                .cornerRadius(10)
                                                                .shadow(color: Color("Shadow3"), radius: 6, x: -7, y: -7)
                                                                .shadow(color: Color("Shadow"), radius: 6, x: 7, y: 7)
                                                                .foregroundColor( gameSettingViewModel.daySelection == index ? Color("Color2") : Color("Color3"))
                                                        }
                                                        .frame(width: g.size.width / 4.3, height: g.size.height / 15)
                                                    }
                                                    .frame(maxHeight: .infinity)
                                                }
                                            }
                                            Spacer()
                                            
                                            Divider()
                                            
                                            Button {
                                                showingDaySelection.toggle()
                                            } label: {
                                                Text("닫기")
                                                    .modifier(TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.title3, color: FontCustomColor.color2))
                                            }
                                            
                                        } // VStack
                                        .frame(height: g.size.height / 6)
                                        .presentationDetents([.height(g.size.height / 6)])
                                        .interactiveDismissDisabled(true)
                                    } // ZStack
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
                         
                                if !realtimeViewModel.inviteFriendArray.isEmpty{
                                    ForEach(realtimeViewModel.inviteFriendArray, id: \.self) {friend in
                                        HStack {
                                           
                                            Text(friend.nickName)
                                                .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.footnot, color: FontCustomColor.color1))
                                                .frame(width: g.size.width / 5, height: g.size.height / 40)
                                                .padding(6)
                                                .background(Color("Color2"))
                                                .cornerRadius(7)
                                           
                                               
//                                            Button {
//                                                // min
//                                            } label: {
//                                                Image(systemName: "minus")
//                                            }
                                      
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
                                    findFriendToggle.toggle()
                                } label: {
                                    Image(systemName: "chevron.backward")
                                        .rotationEffect(.degrees(-90))
                                        .foregroundColor(realtimeViewModel.inviteFriendArray.isEmpty ? Color("Color3") : Color("Color2"))
                                }
                                .sheet(isPresented: $findFriendToggle) {
                                    FriendView(findFriendToggle: $findFriendToggle)
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
                    VStack {
                        Button {
                            if trimsTitleTextField.count > 0 && trimTargetMoneyTextField.count > 0 && gameSettingViewModel.daySelection != 5{
                                    isShowingAlert = true
                            } else { //공백문자만 있을 때
                                summitAlertToggle = true
                            }
                        } label: {
                            Text("초대장 보내기")
                                .modifier(gameSettingViewModel.title.isEmpty || gameSettingViewModel.targetMoney.isEmpty || gameSettingViewModel.daySelection == 5 || realtimeViewModel.inviteFriendArray.isEmpty ? TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.title3, color: FontCustomColor.color3) : TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.title3, color: FontCustomColor.color2))
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
            .onAppear {
                gameSettingViewModel.daySelection = 5
                gameSettingViewModel.startDate = Date().timeIntervalSince1970 + gameSettingViewModel.dayMultiArray[0]
                gameSettingViewModel.endDate = gameSettingViewModel.startDate + Double(86400) * gameSettingViewModel.dayMultiArray[0]
            }
        }
        .ignoresSafeArea(.keyboard)

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
                            startDate: String(gameSettingViewModel.startDate) ,
                            endDate: String(gameSettingViewModel.endDate),
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
                //   dismiss()
            }
        }, message: {
            if notiManager.isGranted {
                Text("챌린지가 시작되면 내용 변경이 불가능합니다.")
            }
        })
        .alert("작성을 중단하시겠습니까?", isPresented: $backBtnAlert, actions: {
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
