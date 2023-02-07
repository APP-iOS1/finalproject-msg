//
//  SoloGameSettingView.swift
//  MSG
//
//  Created by sehooon on 2023/01/30.
//

import SwiftUI
import Combine

struct SoloGameSettingView: View {
    enum Field: Hashable {
        case title
        case limitMoney
    }
    @FocusState private var focusedField: Field?
    let maxConsumeMoney = Int(7)
    @StateObject private var gameSettingViewModel = GameSettingViewModel()
    @EnvironmentObject var notiManager: NotificationManager
    @State private var isShowingAlert: Bool = false
    @State private var backBtnAlert: Bool = false
    @EnvironmentObject var fireStoreViewModel: FireStoreViewModel
    private let dateFormatter = DateFormatter()
    @Environment(\.dismiss) var dismiss
    
    // 챌린지 기간 설정 시트
    @State private var showingDaySelection: Bool = false
    
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
                            HStack{
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
                        
                        
                        // MARK: - 시작하기 - [Button]
                        VStack {
                            Button {
                                if gameSettingViewModel.daySelection != 5 {
                                    isShowingAlert = true
                                }
                            } label: {
                                Text("시작하기")
                                    .modifier(gameSettingViewModel.title.isEmpty || gameSettingViewModel.targetMoney.isEmpty || gameSettingViewModel.daySelection == 5 ? TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.title3, color: FontCustomColor.color3) : TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.title3, color: FontCustomColor.color2))
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
                        .disabled(!gameSettingViewModel.isGameSettingValid)
                        .alert(notiManager.isGranted ? "챌린지를 시작하시겠습니까?" : "알림을 허용해주세요", isPresented: $isShowingAlert, actions: {
                            Button("시작하기") {
                                Task{
                                    if !notiManager.isGranted {
                                        notiManager.openSetting()
                                    } else {
                                        print("도전장 보내짐")
                                        let localNotification = LocalNotification(identifier: UUID().uuidString, title: "챌린지가 시작되었습니다!", body: "야호", timeInterval: 1, repeats: false)
                                        let singGame = Challenge(id: UUID().uuidString, gameTitle: gameSettingViewModel.title, limitMoney: Int(gameSettingViewModel.targetMoney) ?? 0, startDate:  String(gameSettingViewModel.startDate), endDate:  String(gameSettingViewModel.endDate), inviteFriend: [], waitingFriend: [])
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
                    .frame(width: g.size.width / 1.2, height: g.size.height / 1.7)
                    
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

        .alert("작성을 중단하시겠습니까?", isPresented: $backBtnAlert, actions: {

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
                    backBtnAlert = true
                } label: {
                    Image(systemName:"chevron.backward")
                }
                
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
