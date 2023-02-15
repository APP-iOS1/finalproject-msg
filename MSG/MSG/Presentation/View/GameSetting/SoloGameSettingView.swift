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
    @StateObject private var gameSettingViewModel = GameSettingViewModel()
    @EnvironmentObject var notiManager: NotificationManager
    @Environment(\.dismiss) var dismiss
    
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
                                    .onAppear{
                                        focusedField = .title
                                    }
                                
                                Spacer()
                                
                                Button {
                                    gameSettingViewModel.title = ""
                                } label: {
                                    Image(systemName: gameSettingViewModel.title.isEmpty ?  "delete.left" : "delete.left.fill")
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
                                    Image(systemName: gameSettingViewModel.targetMoney.isEmpty ? "delete.left" : "delete.left.fill")
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
                                    gameSettingViewModel.showingDaySelection.toggle()
                                } label: {
                                    
                                    Image(systemName: "chevron.backward")
                                        .rotationEffect(.degrees(-90))
                                        .foregroundColor(gameSettingViewModel.daySelection == 5 ? Color("Color3") : Color("Color2"))
                                    
                                }
                                .sheet(isPresented: $gameSettingViewModel.showingDaySelection) {
                                    DateSheetView(gameSettingViewModel: gameSettingViewModel, parentScreen: g) // ZStack
                                        .frame(height: g.size.height / 6)
                                        .presentationDetents([.height(g.size.height / 6)])
                                        .interactiveDismissDisabled(true)
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
                        
                        Spacer()
                            .frame(width: g.size.width / 1.2, height: g.size.height / 11)
                        
                    }.frame(width: g.size.width / 1.2, height: g.size.height / 1.7)
                    
                    // MARK: - 시작하기 - [Button]
                    Spacer()
                    VStack {
                        Button {
                                gameSettingViewModel.isShowingAlert = true
                        } label: {
                            Text("시작하기")
                                .modifier(!gameSettingViewModel.isGameSettingValid ? TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.title3, color: FontCustomColor.color3) : TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.title3, color: FontCustomColor.color2))
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
                    .alert("챌린지를 시작하시겠습니까?", isPresented: $gameSettingViewModel.isShowingAlert, actions: {
                        Button("시작하기") {
                            Task{
                                if !notiManager.isGranted {
                                    await gameSettingViewModel.createSingleChallenge()
                                    dismiss()
                                } else {
                                    print("도전장 보내짐")
                                    let localNotification = LocalNotification(identifier: UUID().uuidString, title: "챌린지가 시작되었습니다!", body: "지출을 추가해 기록을 작성해보세요", timeInterval: 1, repeats: false)
                                    await gameSettingViewModel.createSingleChallenge()
                                    dismiss()
                                    await notiManager.schedule(localNotification: localNotification)
                                    await notiManager.doSomething()
                                    await notiManager.getPendingRequests()
                                }
                            }
                        }
                        Button("취소하기") {
                            //   dismiss()
                        }
                    }
                           ,message: {
                        if notiManager.isGranted {
                            Text("챌린지가 시작되면 내용 변경이 불가능합니다.")
                        }
                    })
                    Spacer()
                    
                }
                .frame(width: g.size.width / 1.2, height: g.size.height / 1.2)
                .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.body, color: FontCustomColor.color2))
            }
            .onAppear {
                gameSettingViewModel.resetInputData()
            }
        }
        .ignoresSafeArea(.keyboard)
        
        .onTapGesture {
            self.endTextEditing()
        }
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

struct SoloGameSettingView_Previews: PreviewProvider {
    static var previews: some View {
        SoloGameSettingView()
            .environmentObject(NotificationManager())
    }
}
