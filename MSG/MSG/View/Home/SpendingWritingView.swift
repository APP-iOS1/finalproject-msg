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
import Combine

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
    
    @State private var selection: Int = 8
    @State private var showingSpendingCategory = false
    @State private var keepWriting = false
    
    private func convertTextLogic(title: String, money: String, date: Date) -> String {
        return title + "_" + money + "_" + date.toString()
    }
    
    let tagArray: [String] = ["식비", "교통비", "쇼핑", "의료", "주거", "여가", "금융", "기타"]
    
    let maxConsumeTitle = Int(10)
    let maxConsumeMoney = Int(7)
    
    var body: some View {
        
        
        GeometryReader { g in
            ZStack{
                Color("Color1").ignoresSafeArea()
                
                    VStack{
                        Group {
                            
                            VStack(alignment: .leading) {
                                // MARK: 오늘 날짜
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("오늘 날짜")
                                            .modifier(TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.title2, color: FontCustomColor.color2))
                                        
                                        Spacer()
                                    }
                                    .frame(width: g.size.width / 1.2, height: g.size.height / 30)
                                    
                                    Spacer()
                                    
                                    HStack {
                                        Text("\(fireStoreViewModel.KoreanDateNow(date: Date()))")
                                        
                                        Spacer()
                                    }
                                    .frame(width: g.size.width / 1.2, height: g.size.height / 30)
                                    
                                }
                                .frame(width: g.size.width / 1.2, height: g.size.height / 11)
                                
                                
                                VStack {
                                    Spacer()
                                    Divider()
                                    Spacer()
                                }
                                
                                // MARK: 카테고리 선택란
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("카테고리")
                                            .modifier(TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.title2, color: FontCustomColor.color2))
                                            .padding(.bottom, 2)
                                        Spacer()
                                    }
                                    .frame(width: g.size.width / 1.2, height: g.size.height / 30)
                                    
                                    
                                    HStack{
                                        if selection == 0 {
                                            HStack {
                                                Image(systemName: "fork.knife")
                                                Text("식비")
                                            }
                                           
                                        } else if selection == 1 {
                                            HStack {
                                                Image(systemName: "bus")
                                                Text("교통비")
                                            }
                                        } else if selection == 2 {
                                            HStack {
                                                Image(systemName: "cart")
                                                Text("쇼핑")
                                            }
                                        } else if selection == 3 {
                                            HStack {
                                                Image(systemName: "cross")
                                                Text("의료")
                                            }
                                        } else if selection == 4 {
                                            HStack {
                                                Image(systemName: "house")
                                                Text("주거")
                                            }
                                        } else if selection == 5 {
                                            HStack {
                                                Image(systemName: "figure.socialdance")
                                                Text("여가")
                                            }
                                        } else if selection == 6 {
                                            HStack {
                                                Image(systemName: "wonsign")
                                                Text("금융")
                                            }
                                        } else if selection == 7 {
                                            HStack {
                                                Image(systemName: "ellipsis.curlybraces")
                                                Text("기타")
                                            }
                                        } else if selection == 8 {
                                            Text("카테고리를 선택해주세요")
                                                .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.body, color: FontCustomColor.color3))
                                        }
                                        
                                        Spacer()
                                        
                                        // MARK: 소비 태그 Collect Sheet
                                        Button {
                                            showingSpendingCategory.toggle()
                                        } label: {
                                            Image(systemName: "chevron.backward")
                                                .rotationEffect(.degrees(-90))
                                            
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
                                                                        //.frame(width: 30, height: 30)
                                                                        .frame(width: g.size.width / 13, height: g.size.height / 30)
                                                                    
                                                                    Text(item.name)
                                                                      //  .frame(width: 50)
                                                                        .frame(width: g.size.width / 5, height: g.size.height / 30)
                                                                }
                                                                
                                                                if item.tag == selection {
                                                                    Button {
                                                                        selection = item.tag
                                                                        showingSpendingCategory.toggle()
                                                                    } label: {
                                                                        Image(systemName: "checkmark.square.fill")
                                                                    }
                                                                    .frame(width: g.size.width / 9, height: g.size.height / 30)
                                                                } else {
                                                                    Button {
                                                                        selection = item.tag
                                                                        showingSpendingCategory.toggle()
                                                                    } label: {
                                                                        Image(systemName: "square")
                                                                    }
                                                                    .frame(width: g.size.width / 9, height: g.size.height / 30)
                                                                }
                                                            }
                                                            .frame(height: g.size.height / 20)
                                                      
                                                            
                                                        }
                                                        .frame(maxWidth: .infinity)
                                                    }
                                                    
                                                    Divider()
                                                    
                                                    Button {
                                                        showingSpendingCategory.toggle()
                                                    } label: {
                                                        Text("닫기")
                                                            .modifier(TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.title3, color: FontCustomColor.color2))
                                                    }
                                                }
                                                .frame(height: g.size.height / 2.5)
                                                .presentationDetents([.height(g.size.height / 2.1)])
                                                .interactiveDismissDisabled(true)
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
                                
                                // MARK: 상세 내용 작성란
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("상세 내용")
                                            .modifier(TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.title2, color: FontCustomColor.color2))
                                        Spacer()
                                    }
                                    .frame(width: g.size.width / 1.2, height: g.size.height / 30)
                                    
                                    
                                    HStack {
                                        TextField("", text: $spendingViewModel.consumeTitle)
                                            .placeholder(when: spendingViewModel.consumeTitle.isEmpty) {
                                                Text("11글자 미만으로 내용을 입력하세요")
                                                    .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.body, color: FontCustomColor.color3))
                                            }
                                            .frame(width: g.size.width / 1.4, height: g.size.height / 40)
                                            .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.body, color: FontCustomColor.color2))
                                            .onReceive(Just(spendingViewModel.consumeTitle), perform: { _ in
                                                if maxConsumeTitle < spendingViewModel.consumeTitle.count {
                                                    spendingViewModel.consumeTitle = String(spendingViewModel.consumeTitle.prefix(maxConsumeTitle))
                                                }
                                            })
                                        
                                        Spacer()
                                        
                                        if spendingViewModel.consumeTitle.isEmpty {
                                            Image(systemName: "delete.left")
                                        } else {
                                            Button {
                                                spendingViewModel.consumeTitle = ""
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
                                
                                // MARK: 금액 작성란
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("지출 금액")
                                            .modifier(TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.title2, color: FontCustomColor.color2))
                                        
                                        Spacer()
                                    }
                                    .frame(width: g.size.width / 1.2, height: g.size.height / 30)
                                    
                                    
                                    HStack {
                                        
                                        ZStack(alignment: .leading) {
                                            Text(spendingViewModel.consumeMoney.insertComma)
                                            
                                            TextField("", text: $spendingViewModel.consumeMoney)
                                                .placeholder(when: spendingViewModel.consumeMoney.isEmpty) {
                                                    Text("1,000만원 미만으로 입력하세요")
                                                        .kerning(0)
                                                        .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.body, color: FontCustomColor.color3))
                                                }
                                                .foregroundColor(Color(.clear))
                                                .kerning(+1.5)
                                                .keyboardType(.numberPad)
                                                .onReceive(Just(spendingViewModel.consumeMoney), perform: { _ in
                                                    if maxConsumeMoney < spendingViewModel.consumeMoney.count {
                                                        spendingViewModel.consumeMoney = String(spendingViewModel.consumeMoney.prefix(maxConsumeMoney))
                                                    }
                                                })
                                        }
                                        .frame(width: g.size.width / 1.4, height: g.size.height / 40)
                                        
                                        Spacer()
                                        
                                        if spendingViewModel.consumeMoney.isEmpty {
                                            Image(systemName: "delete.left")
                                        } else {
                                            Button {
                                                spendingViewModel.consumeMoney = ""
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
                            }
                            .frame(width: g.size.width / 1.2, height: g.size.height / 1.7)
                            
                            
                            
                            // MARK: 추가하기 Button
                            VStack {
                                Button {
                                    if selection != 8 {
                                        keepWriting.toggle()
                                        Task{
                                            let convert = convertTextLogic(title: spendingViewModel.consumeTitle, money: spendingViewModel.consumeMoney, date: Date())
                                            let user = try await fireStoreViewModel.fetchUserInfo(Auth.auth().currentUser!.uid)
                                            await fireStoreViewModel.addExpenditure(user: user!,tagName: tagArray[selection], convert: convert, addMoney: Int(spendingViewModel.consumeMoney)!)
                                            selection = 8
                                            spendingViewModel.consumeTitle = ""
                                            spendingViewModel.consumeMoney = ""
                                        }
                                    }
                                }label: {
                                    Text("추가하기")
                                        .modifier(spendingViewModel.consumeTitle.isEmpty || selection == 8 || spendingViewModel.consumeMoney.isEmpty ? TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.title3, color: FontCustomColor.color3) : TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.title3, color: FontCustomColor.color2))
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
                                .disabled(!self.isValid)
                                .alert("소비 내역이 작성되었습니다.", isPresented: $keepWriting) {
                                    Button {} label: { Text("확인") }
                                }
                            }
                            .keyboardType(.default)
                            
                            Spacer()
                            
                        }
                        .onReceive(self.spendingViewModel.isGameSettingValidPublisher, perform: {self.isValid = $0})
                    }
                    .frame(width: g.size.width / 1.2, height: g.size.height / 1.2)
                    .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.body, color: FontCustomColor.color2))
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Button("완료") {
                                hideKeyboard()
                            }
                        }
                    }

                
            }
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
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
            .environmentObject(FireStoreViewModel())
        
    }
}
