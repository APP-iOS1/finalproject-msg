//
//  SpendingWritingView.swift
//  MSG
//
//  Created by sehooon on 2023/01/17.
//

import SwiftUI

struct SpendingWritingView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    @EnvironmentObject var fireStoreViewModel: FireStoreViewModel
    @State private var selection: Int = 0
    
    @State private var consumeTag = ""
    @State private var consumeMoney = ""
    
    private func convertTextLogic(tag: String, money: String) -> String {
        return tag + "_" + money
    }
    
    var body: some View {
        ZStack{
            Color("Background").ignoresSafeArea()
            VStack{
                Group{
          
                    Spacer()
                    HStack{
                        Text("소비 날짜")
                            .foregroundColor(Color("Font"))
                        Text("|")
                        Text("2023/01/17")
                        Spacer()
                    }
                    .padding()
                    
                    HStack{
                        Text("소비 태그")
                            .foregroundColor(Color("Font"))
                        Text("|")
                            .foregroundColor(Color("Font"))
         
                        VStack{
                                if selection == 5 {
                                
                                        ZStack{
                                            TextField("태그를 입력해주세요", text: $consumeTag)
                                                .padding(.leading, 16)
                                                .padding(.trailing, 16)
                                            Button {
                                                    selection = 0
                                            } label: {
                                                Image(systemName: "arrow.triangle.2.circlepath")
                                            }.offset(x:110)
                                            
                                        }
                                } else{
                                    Picker("한국어",selection: $selection) {
                                        Text("식비").tag(0)
                                        Text("교통비").tag(1)
                                        Text("경조사").tag(2)
                                        Text("생활용품").tag(3)
                                        Text("기타").tag(4)
                                        Text("직접입력").tag(5)
                                    }
                                    .pickerStyle(.menu)
                                    .accentColor(Color("Font"))
                                }
         
                            
                            Rectangle()
                                .frame(height:1)
                                .foregroundColor(Color("Point2"))
                                .padding(.leading, 16)
                                .padding(.trailing, 16)
                        }
                        
                    }
                    .padding()
                    
                    HStack{
                        Text("금액")
                            .foregroundColor(Color("Font"))
                        Text("|")
                            .foregroundColor(Color("Font"))
                        VStack{
                            TextField("", text: $consumeMoney)
                                .padding(.leading, 16)
                                .padding(.trailing, 16)
                                
                            Rectangle()
                                .frame(height:1)
                                .foregroundColor(Color("Point2"))
                                .padding(.leading, 16)
                                .padding(.trailing, 16)
                        }
                    }
                    .padding()
                    
                    Spacer()
                    Button {
                        let convert = convertTextLogic(tag: consumeTag, money: consumeMoney)
                        fireStoreViewModel.addExpenditure(user: loginViewModel.currentUserProfile!, categoryAndExpenditure: convert)
                    } label: {
                        Text("추가하기")
                            .foregroundColor(Color("Font"))
                    }
                    .frame(width: 300,height: 40)
                    .overlay {
                        RoundedRectangle(cornerRadius: 20).stroke(Color("Point2"), lineWidth: 2)
                    }
                    Spacer()
                }
            }
        }
    }
}

struct SpendingWritingView_Previews: PreviewProvider {
    static var previews: some View {
        SpendingWritingView()
    }
}
