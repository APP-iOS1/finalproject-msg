//
//  SpendingWritingView.swift
//  MSG
//
//  Created by sehooon on 2023/01/17.
//

import SwiftUI
import FirebaseAuth
import Firebase
import UIKit

struct SpendingCategory: Identifiable, Hashable {
    let id = UUID().uuidString
    let name: String
    var tag: Int
    let icon: String
}

var spendingCategory: [SpendingCategory] = [
    SpendingCategory(name: "식비", tag: 0, icon: "fork.knife"),
    SpendingCategory(name: "교통비", tag: 1, icon: "bus"),
    SpendingCategory(name: "쇼핑", tag: 2, icon: "cart"),
    SpendingCategory(name: "의료", tag: 3, icon: "cross"),
    SpendingCategory(name: "주거", tag: 4, icon: "house"),
    SpendingCategory(name: "여가", tag: 5, icon: "figure.socialdance"),
    SpendingCategory(name: "금융", tag: 6, icon: "wonsign"),
    SpendingCategory(name: "기타", tag: 7, icon: "ellipsis.curlybraces")
]

struct SpendingWritingView: View {
    
    @EnvironmentObject var loginViewModel: LoginViewModel
    @EnvironmentObject var fireStoreViewModel: FireStoreViewModel

    @StateObject var spendingViewModel = SpendingWriteViewModel()
    @State private var isValid = false
    
    @State private var selection: Int = 0
    @State private var showingSpendingCategory = false
    @State private var keepWriting = false
    
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
                            Text("오늘 날짜")
                            Text("|")
//                            Text("\(fireStoreViewModel.KoreanDateNow(date: Date()))")
                            Spacer()
                        }
                        .padding()
                        
                        HStack{
                            Text("카테고리")
                            Text("|")
                            VStack{
                                // MARK: 소비 태그 피커
                                Button {
                                    showingSpendingCategory.toggle()
                                } label: {
                                    if selection == 0 {
                                        Text("식비")
                                    } else if selection == 1 {
                                        Text("교통비")
                                    } else if selection == 2 {
                                        Text("쇼핑")
                                    } else if selection == 3 {
                                        Text("의료")
                                    } else if selection == 4 {
                                        Text("주거")
                                    } else if selection == 5 {
                                        Text("여가")
                                    } else if selection == 6 {
                                        Text("금융")
                                    } else if selection == 7 {
                                        Text("기타")
                                    }
                                }
                                .sheet(isPresented: $showingSpendingCategory) {
                                    ZStack{
                                        Color("Color1").ignoresSafeArea()
                                        VStack {
                                            ScrollView {
                                                ForEach(spendingCategory, id: \.self){ item in

                                                    HStack(spacing: 130) {
                                                        HStack(spacing: 40) {
                                                            Image(systemName: item.icon)
                                                                .resizable()
                                                                .frame(width: 30, height: 30)
                                                            
                                                            Text(item.name)
                                                                .frame(width: 50)
                                                        }

                                                        if item.tag == selection {
                                                            Button {
                                                                selection = item.tag
                                                                showingSpendingCategory.toggle()
                                                            } label: {
                                                                Image(systemName: "checkmark.square.fill")
                                                            }
                                                            .frame(width: 20)
                                                        } else {
                                                            Button {
                                                                selection = item.tag
                                                                showingSpendingCategory.toggle()
                                                            } label: {
                                                                Image(systemName: "square")
                                                            }
                                                            .frame(width: 20)
                                                        }
                                                    }
                                                    .padding(.bottom, 20)
                                                    
                                                }
                                                .frame(maxWidth: .infinity)
                                            }

                                            Divider()
                                                .padding(.bottom, 5)
                                            
                                            Button {
                                                showingSpendingCategory.toggle()
                                            } label: {
                                                Text("닫기")
                                            }
                                        }
                                        .frame(height: 330)
                                        .presentationDetents([.height(350)])
                                        .interactiveDismissDisabled(true)
                                    }
                                }
                                .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.title3, color: FontCustomColor.color2))
                                
                                Rectangle()
                                    .frame(height:1)
                                    .padding(.leading, 16)
                                    .padding(.trailing, 16)
                            }
                        }
                        .padding()
                        
                        VStack {
                            HStack{
                                Text("상세 내용")
                                Text("|")
                                VStack{
                                    HStack {
                                        TextField("상세 내용을 입력해주세요", text: $spendingViewModel.consumeTitle)
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
                                        
                                        ZStack {
                                            Text(spendingViewModel.consumeMoney.insertComma)
                                            
                                            TextField("금액을 입력해주세요", text: $spendingViewModel.consumeMoney)
                                                .foregroundColor(Color(.clear))
                                                .keyboardType(.numberPad)
                                                .multilineTextAlignment(.center)
                                                .padding(.leading, 5)
                                        }
                         
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
                        }
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Button("완료") {
                                    hideKeyboard()
                                }
                            }
                        }
                        
                        Spacer()
                        Button {
                            keepWriting.toggle()
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
                        .alert("소비 내역이 작성되었습니다.", isPresented: $keepWriting) {
                            Button {} label: { Text("확인") }
                        }

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

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension String {
    var insertComma: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        if let _ = self.range(of: ".") {
            let numberArray = self.components(separatedBy: ".")
            if numberArray.count == 1 {
                var numberString = numberArray[0]
                if numberString.isEmpty {
                    numberString = "0"
                }
                guard let doubleValue = Double(numberString)
                    else { return self }
                return numberFormatter.string(from: NSNumber(value: doubleValue)) ?? self
            } else if numberArray.count == 2 {
                var numberString = numberArray[0]
                if numberString.isEmpty {
                    numberString = "0"
                }
                guard let doubleValue = Double(numberString)
                    else {
                        return self
                }
                return (numberFormatter.string(from: NSNumber(value: doubleValue)) ?? numberString) + ".\(numberArray[1])"
            }
        }
        else {
            guard let doubleValue = Double(self)
                else {
                    return self
            }
            return numberFormatter.string(from: NSNumber(value: doubleValue)) ?? self
        }
        return self
    }
}

struct SpendingWritingView_Previews: PreviewProvider {
    static var previews: some View {
        SpendingWritingView()
        
    }
}
