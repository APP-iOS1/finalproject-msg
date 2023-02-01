//
//  SpendingWritingView.swift
//  MSG
//
//  Created by sehooon on 2023/01/17.
//

import SwiftUI
import FirebaseAuth
import Firebase

struct SpendingWritingView: View {
    
    @EnvironmentObject var loginViewModel: LoginViewModel
    @EnvironmentObject var fireStoreViewModel: FireStoreViewModel
    @State private var selection: Int = 0
    @ObservedObject var spendingViewModel = SpendingWriteViewModel()
    @State private var isValid = false
    
    private func convertTextLogic(title: String, money: String, date: Date) -> String {
        return title + "_" + money + "_" + date.toString()
    }
    
    let tagArray: [String] = ["식비", "교통비", "쇼핑", "의료", "주거", "여가", "금융", "기타"]
    
    var body: some View {
        
        GeometryReader { g in
            ZStack{
                Color("Color1").ignoresSafeArea()
                VStack{
                    Group{
                        Spacer()
                        HStack{
                            Text("소비 날짜")
                            Text("|")
                            Text("2023/01/17")
                            Spacer()
                        }
                        .padding()
                        
                        HStack{
                            Text("소비 태그")
                            Text("|")
                            VStack{
                                Picker("한국어",selection: $selection) {
                                    Text("식비").tag(0)
                                    Text("교통비").tag(1)
                                    Text("쇼핑").tag(2)
                                    Text("의료").tag(3)
                                    Text("주거").tag(4)
                                    Text("여가").tag(5)
                                    Text("금융").tag(6)
                                    Text("기타").tag(7)
                                }
                                .pickerStyle(.menu)
                                
                                Rectangle()
                                    .frame(height:1)
                                    .padding(.leading, 16)
                                    .padding(.trailing, 16)
                            }
                        }
                        .padding()
                        
                        HStack{
                            Text("상세 내용")
                            Text("|")
                            VStack{
                                HStack {
                                    TextField("", text: $spendingViewModel.consumeTitle)
                                        .padding(.leading, 16)
                                        .padding(.trailing, 16)
                                    Button {
                                        spendingViewModel.consumeTitle = ""
                                    } label: {
                                        Image(systemName: "eraser")
                                    }
                                }
                                Rectangle()
                                    .frame(height:1)
                                    .padding(.leading, 16)
                                    .padding(.trailing, 16)
                            }
                        }
                        .padding()
                        
                        HStack{
                            Text("금액")
                            Text("|")
                            VStack{
                                HStack {
                                    TextField("", text: $spendingViewModel.consumeMoney)
                                        .padding(.leading, 16)
                                        .padding(.trailing, 16)
                                    Button {
                                        spendingViewModel.consumeMoney = ""
                                    } label: {
                                        Image(systemName: "eraser")
                                    }
                                }
                                Rectangle()
                                    .frame(height:1)
                                    .padding(.leading, 16)
                                    .padding(.trailing, 29)
                            }
                        }
                        .padding()
                        
                        Spacer()
                        Button {
                            Task{
                                let convert = convertTextLogic(title: spendingViewModel.consumeTitle, money: spendingViewModel.consumeMoney, date: Date())
                                let user = try await fireStoreViewModel.fetchUserInfo(Auth.auth().currentUser!.uid)
                                await fireStoreViewModel.addExpenditure(user: user!,tagName: tagArray[selection], convert: convert, addMoney: Int(spendingViewModel.consumeMoney)!)
                                selection = 0
                                spendingViewModel.consumeTitle = ""
                                spendingViewModel.consumeMoney = ""
                            }
                        }label: {
                            Text("추가하기")
                        }
                        .buttonStyle(.borderless)
                        .frame(width: g.size.width / 1.2, height: g.size.height / 14)
                        .shadow(color: Color("Shadow3"), radius: 6, x: -7, y: -7)
                        .shadow(color: Color("Shadow"), radius: 6, x: 7, y: 7)
                        .padding(5)
                        .background(Color("Color1"))
                        .cornerRadius(10)
                        .shadow(color: Color("Shadow3"), radius: 6, x: -7, y: -7)
                        .shadow(color: Color("Shadow"), radius: 6, x: 7, y: 7)
                        .disabled(!self.isValid)
                        Spacer()
                    }
                    .onReceive(self.spendingViewModel.isGameSettingValidPublisher, perform: {self.isValid = $0})
                }
                .modifier(TextViewModifier(color: "Color2"))
                .foregroundColor(Color("Color2"))
            }
        }
    }
}

struct SpendingWritingView_Previews: PreviewProvider {
    static var previews: some View {
        SpendingWritingView()
        
    }
}
