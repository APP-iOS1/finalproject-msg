//
//  RecordDetailView.swift
//  MSG
//
//  Created by 정소희 on 2023/01/18.
//

import SwiftUI

struct RecordDetailView: View {
    
    @EnvironmentObject private var firestoreViewModel: FireStoreViewModel
    @Binding var challenge: Challenge
    @State var historyExpenditure: Expenditure?
    @State private var tagValue: [(tag: String, money: Int)] = []
    
    private func parsingExpenditure(_ expenditureHistory: [String:[String]]) -> [(tag: String, money: Int)]{
        
        var maxValue: (tag:String, money: Int) = ("",Int.min)
        var minValue: (tag:String, money: Int) = ("",Int.max)
        var maxSum = Int.min
        var minSum = Int.max
        
        for (tag, expenditure) in expenditureHistory{
            var sum:Int = 0
            for string in expenditure {
                let stringArr = string.components(separatedBy: "_")
                let money = stringArr[1]
                sum += Int(money)!
            }
            if maxSum < sum {
                maxValue = (tag: tag, money: sum)
                maxSum = sum
            }
            if minSum > sum {
                minValue = (tag: tag, money: sum)
                minSum = sum
            }
        }
        return [maxValue, minValue]
    }
    
    var category: [Category] = [
        Category(tag: "식비", icon: "fork.knife", color: "Chart1"),
        Category(tag: "교통비", icon: "bus", color: "Chart2"),
        Category(tag: "쇼핑", icon: "cart", color: "Chart3"),
        Category(tag: "의료", icon: "cross", color: "Chart4"),
        Category(tag: "주거", icon: "house", color: "Chart5"),
        Category(tag: "여가", icon: "figure.socialdance", color: "Chart6"),
        Category(tag: "금융", icon: "wonsign", color: "Chart7"),
        Category(tag: "기타", icon: "ellipsis.curlybraces", color: "Chart8")
    ]
    
    var body: some View {
        
        GeometryReader { g in
            ZStack{
                Color("Color1").ignoresSafeArea()
                ScrollView{
                    VStack{
                        //타이틀, 날짜 그룹
                        Group{
                            HStack{
                                Text(challenge.gameTitle)
                                    .modifier(TextModifier(fontWeight: .bold, fontType: FontCustomType.title2, color: .color2))
                                Spacer()
                                //FireStoreViewModel.expenditure
                                NavigationLink(destination: ChartView(expenditure: historyExpenditure ?? Expenditure(id: "", totalMoney: 0, expenditureHistory: [:]))) {
                                    Text("상세내역")
                                        .frame(width: g.size.width / 6, height: g.size.height / 34)
                                        .shadow(color: Color("Shadow3"), radius: 8, x: -9, y: -9)
                                        .shadow(color: Color("Shadow"), radius: 8, x: 9, y: 9)
                                        .padding(20)
                                        .background(Color("Color1"))
                                        .cornerRadius(20)
                                        .shadow(color: Color("Shadow3"), radius: 8, x: -9, y: -9)
                                        .shadow(color: Color("Shadow"), radius: 8, x: 9, y: 9)
                                }
                            }
                            Divider()
                            HStack{
                                Text("\(challenge.startDate.createdDate) ~ \(challenge.endDate.createdDate)")
                                    .modifier(TextModifier(fontWeight: .bold, fontType: FontCustomType.body, color: .color2))
                                    .padding(.bottom, 20)
                                Spacer()
                            }
                        }
                        .padding(.horizontal)
                        .modifier(TextViewModifier(color: "Color2"))
                        
                        //챌린지 참여인원에 따른 사용금액 그룹
                        if !challenge.inviteFriend.isEmpty {
                            Group{
                                ForEach(firestoreViewModel.challengeUsers.indices, id: \.self) { index in
                                    HStack{
                                        VStack{
                                            if firestoreViewModel.challengeUsers[index].user.userProfile.isEmpty{
                                                Image(systemName: "person")
                                                    .font(.largeTitle)
                                                    .background(content: {
                                                        Color("Point2")
                                                    })
                                                    .padding(.trailing)
                                            }else{
                                                AsyncImage(url: URL(string: firestoreViewModel.challengeUsers[index].user.userProfile)!) { Image in
                                                    Image
                                                        .resizable()
                                                        .frame(width: 50, height: 50)
                                                } placeholder: { }
                                            }
                                            Text("\(firestoreViewModel.challengeUsers[index].user.userName)")
                                        }
                                        Text("총 \(firestoreViewModel.challengeUsers[index].totalMoney)원 사용")
                                        Spacer()
                                    }
                                }
                            }
                            .padding([.vertical, .horizontal])
                            .modifier(TextViewModifier(color: "Color2"))
                            
                            //가장적게 쓴, 많이 쓴 사람 그룹
                            Group{
                                HStack{
                                    Text("가장 적게 쓴 사람")
                                        .padding(.trailing)
                                    Image(systemName: "person")
                                        .resizable()
                                        .frame(width: g.size.width / 10, height: g.size.height / 18.5)
                                        .padding(25)
                                        .foregroundColor(Color("Color2"))
                                        .background(
                                            Circle()
                                                .fill(
                                                    .shadow(.inner(color: Color("Shadow2"),radius: 5, x:3, y: 3))
                                                    .shadow(.inner(color: Color("Shadow3"), radius:5, x: -3, y: -3))
                                                )
                                                .foregroundColor(Color("Color1")))
                                }.padding(.top, 20)
                                HStack{
                                    Text("가장 많이 쓴 사람")
                                        .padding(.trailing)
                                    Image(systemName: "person")
                                        .resizable()
                                        .frame(width: g.size.width / 10, height: g.size.height / 18.5)
                                        .padding(25)
                                        .foregroundColor(Color("Color2"))
                                        .background(
                                            Circle()
                                                .fill(
                                                    .shadow(.inner(color: Color("Shadow2"),radius: 5, x:3, y: 3))
                                                    .shadow(.inner(color: Color("Shadow3"), radius:5, x: -3, y: -3))
                                                )
                                                .foregroundColor(Color("Color1")))
                                }
                            }
                            .padding([.vertical, .horizontal], 10)
                            .modifier(TextViewModifier(color: "Color2"))
                        } else {
                            VStack {
                                HStack{
                                    ForEach(firestoreViewModel.challengeHistoryUserList.indices, id:\.self) { index in
                                        Text("총 사용 금액 : \(firestoreViewModel.challengeHistoryUserList[index].totalMoney)원")
                                            .modifier(TextModifier(fontWeight: .bold, fontType: FontCustomType.title3, color: .color2))
                                    }
                                    Spacer()
                                }.padding()
                                    .padding(.bottom)
                                HStack{
                                    Text("최대 사용 소비 태그")
                                        .padding(.horizontal, 20)
                                    Text("최소 사용 소비 태그")
                                        .padding(.horizontal, 20)
                                    
                                }.modifier(TextModifier(fontWeight: .bold, fontType: FontCustomType.subhead, color: .color2))
                                HStack{
                                    ForEach(tagValue.indices , id: \.self) { index in
                                        
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(Color("Color1"),
                                                        lineWidth: 4)
                                                .shadow(color: Color("Shadow"),
                                                        radius: 3, x: 5, y: 5)
                                                .clipShape(
                                                    RoundedRectangle(cornerRadius: 15))
                                                .shadow(color: Color("Shadow3"), radius: 2, x: -2, y: -2)
                                                .clipShape(
                                                    RoundedRectangle(cornerRadius: 15))
                                                .background(Color("Color1"))
                                                .cornerRadius(20)
                                                .frame(width: g.size.width / 4.04, height: g.size.height / 12)
                                            
                                            Text("\(tagValue[index].tag)")
                                            
                                        }
                                        .padding(.horizontal, 32)
                                        
                                    }
                                }
                                .padding(.bottom, 40)
                                
                                
                                HStack{
                                    Text("최대 사용 소비 금액")
                                        .padding(.horizontal, 20)
                                    Text("최소 사용 소비 금액")
                                        .padding(.horizontal, 20)
                                    
                                }.modifier(TextModifier(fontWeight: .bold, fontType: FontCustomType.subhead, color: .color2))
                                
                                HStack{
                                    ForEach(tagValue.indices , id: \.self) { index in
                                        
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(Color("Color1"),
                                                        lineWidth: 4)
                                                .shadow(color: Color("Shadow"),
                                                        radius: 3, x: 5, y: 5)
                                                .clipShape(
                                                    RoundedRectangle(cornerRadius: 15))
                                                .shadow(color: Color("Shadow3"), radius: 2, x: -2, y: -2)
                                                .clipShape(
                                                    RoundedRectangle(cornerRadius: 15))
                                                .background(Color("Color1"))
                                                .cornerRadius(20)
                                                .frame(height: 60)
//                                                .frame(width: g.size.width, height: g.size.height / 12)
                                            
                                            Text("\(tagValue[index].money)원")
                                            
                                        }
                                        .padding(.horizontal, 2)
                                        
                                    }
                                }
                                .padding(.horizontal, 34)
                            }
                        }
                    }
                    .modifier(TextViewModifier(color: "Color2"))
                }
            }
            .onAppear{
                Task{
                    await firestoreViewModel.fetchChallengeUsers(challenge.inviteFriend, challenge.id)
                    // 각 유저별 총액 가져오기
                    try await firestoreViewModel.fetchChallengeTotalMoney(challenge.id)
                    
                    // 과거 지출 기록 가져오기
                    guard let history = await firestoreViewModel.fetchHistoryExpenditure(challenge.id) else { return }
                    historyExpenditure = history
                    
                    print(tagValue)
                }
            }
        }
        .foregroundColor(Color("Color2"))
    }
}

//
//struct RecordDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        RecordDetailView(challenge: .constant(Challenge(id: "테스트아이디", gameTitle: "게임해보자", limitMoney: 1000, startDate: "abc", endDate: "def", inviteFriend: ["철수,영희"],waitingFriend: ["철수,영희"])))
//    }
//}
