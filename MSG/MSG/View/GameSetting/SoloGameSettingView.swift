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
    
    var body: some View {
        
        GeometryReader { g in
            ZStack {
                Color("Color1").ignoresSafeArea()
                VStack(spacing: 30) {
                    Spacer()
                    
                    // MARK: - 챌린지 주제- [TextField]
                    VStack(alignment: .leading){
                        Text("챌린지 주제: ")
                            .modifier(TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.body, color: FontCustomColor.color2))
                        VStack{
                            
                            TextField("ex) 하루 만원으로 버티기!", text: $gameSettingViewModel.title)
                                .keyboardType(.default)
                                .focused($focusedField, equals: .title)
                                .onSubmit {
                                    focusedField = .limitMoney
                                }
                                .submitLabel(.done)
                                .modifier(TextViewModifier(color: "Color2"))
                            Divider()
                        }
                    }
                    .padding([.leading, .trailing])
                    // MARK: - 목표금액 - [TextField]
                    VStack(alignment: .leading){
                        Text("한도금액: ")
                            .modifier(TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.body, color: FontCustomColor.color2))
                        VStack(alignment: .leading){
                            ZStack(alignment: .leading) {
                                Text(gameSettingViewModel.targetMoney.insertComma)
                                    .modifier(TextViewModifier(color: "Color2"))
                                    .multilineTextAlignment(.leading)
                                TextField("", text: $gameSettingViewModel.targetMoney)
                                    .placeholder(when: gameSettingViewModel.targetMoney.isEmpty) {
                                        Text("1,000만원 미만으로 입력하세요")
                                            .kerning(0)
                                            .modifier(TextViewModifier(color: "Color2"))
                                            .opacity(0.3)
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
                            Divider()
                            
                        }
                    }
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            if focusedField == .limitMoney {
                                Button("완료") {
                                    hideKeyboard()
                                }
                            }
                        }
                    }
                    .padding([.leading, .trailing])
                    
                    // MARK: - 챌린지 기간 - [DatePicker]
                    VStack(alignment: .leading){
                        HStack{
                            Text("챌린지 기간 설정")
                                .modifier(TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.body, color: FontCustomColor.color2))
                            Spacer()
                        }.padding()
                        HStack{
                            ForEach(gameSettingViewModel.dayArray.indices, id: \.self) { index in
                                Button {
                                    gameSettingViewModel.daySelection = index
                                    gameSettingViewModel.startDate = Date().timeIntervalSince1970 + gameSettingViewModel.dayMultiArray[index]
                                    gameSettingViewModel.endDate = gameSettingViewModel.startDate + Double(86400) * gameSettingViewModel.dayMultiArray[index]
                                    print("\(gameSettingViewModel.dayArray[index])")
                                } label: {
                                    Text("\(gameSettingViewModel.dayArray[index])")
                                        .foregroundColor( gameSettingViewModel.daySelection == index ? .red : .blue)
                                        .modifier(TextViewModifier(color: "Color2"))
                                        .frame(width: g.size.width / 10, height: g.size.height / 34)
                                        .shadow(color: Color("Shadow3"), radius: 8, x: -9, y: -9)
                                        .shadow(color: Color("Shadow"), radius: 8, x: 9, y: 9)
                                        .padding(10)
                                        .background(Color("Color1"))
                                        .cornerRadius(20)
                                        .shadow(color: Color("Shadow3"), radius: 8, x: -9, y: -9)
                                        .shadow(color: Color("Shadow"), radius: 8, x: 9, y: 9)
                                        
                                }
                                
                            }
                        

                        }
                        .padding([.leading, .trailing])
                    }
                    .padding(.bottom ,50)
                    
                    // MARK: - 시작하기 - [Button]
                    Button(action: {
                        isShowingAlert = true
                    }) {
                        Text("시작하기")
                            .modifier(TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.body, color: FontCustomColor.color2))
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
                .foregroundColor(Color("Color2"))
            }
            .onAppear {
                gameSettingViewModel.daySelection = 0
                gameSettingViewModel.startDate = Date().timeIntervalSince1970 + gameSettingViewModel.dayMultiArray[0]
                gameSettingViewModel.endDate = gameSettingViewModel.startDate + Double(86400) * gameSettingViewModel.dayMultiArray[0]
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
