//
//  RecordDetailView.swift
//  MSG
//
//  Created by 정소희 on 2023/01/18.
//

import SwiftUI

struct RecordDetailView: View {
    
    @StateObject var challengeRecordVM = ChallengeRecordViewModel()
    @EnvironmentObject private var firestoreViewModel: FireStoreViewModel
    @Binding var challenge: Challenge
    @State var historyExpenditure: Expenditure?
    @State private var tagValue: [(tag: String, money: Int)] = []
    @State private var userValue: [(user:(userName: String, userProfile: String), totalMoney: Int)] = []
    
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
    
    private func userValues(_ challengeUsers: [(user:(userName: String, userProfile: String), totalMoney: Int)]) -> [(user:(userName: String, userProfile: String), totalMoney: Int)] {
        
        var maxValue: (user:(userName: String, userProfile: String), totalMoney: Int) = (("",""), Int.min)
        var minValue: (user:(userName: String, userProfile: String), totalMoney: Int) = (("",""), Int.max)
        var maxSum = Int.min
        var minSum = Int.max
        
        for (user, totalMoney) in challengeUsers {
            var sum:Int = 0
            let money = totalMoney
            sum += money
            
            if maxSum < sum {
                maxValue = (user:(userName: user.userName, userProfile: user.userProfile), totalMoney: sum)
                maxSum = sum
            }
            if minSum > sum {
                minValue = (user:(userName: user.userName, userProfile: user.userProfile), totalMoney: sum)
                minSum = sum
            }
        }
        return [maxValue, minValue]
    }
    
    var body: some View {
        
        GeometryReader { g in
            ZStack{
                Color("Color1").ignoresSafeArea()
                ScrollView{
                    VStack{
                        //타이틀, 날짜 그룹
                        HStack{
                            Text(challenge.gameTitle)
                                .modifier(TextModifier(fontWeight: .bold, fontType: FontCustomType.largeTitle, color: .color2))
                            Spacer()
                            NavigationLink(destination: ChartView(expenditure: historyExpenditure ?? Expenditure(id: "", totalMoney: 0, expenditureHistory: [:]),limitMoney: Float(challenge.limitMoney))) {
                                Text("상세내역")
                                    .modifier(TextModifier(fontWeight: .normal, fontType: FontCustomType.subhead, color: .color2))
                                    .frame(width: g.size.width / 6, height: g.size.height / 34)
                                    .shadow(color: Color("Shadow3"), radius: 8, x: -9, y: -9)
                                    .shadow(color: Color("Shadow"), radius: 8, x: 9, y: 9)
                                    .padding(10)
                                    .background(Color("Color1"))
                                    .cornerRadius(10)
                                    .shadow(color: Color("Shadow3"), radius: 8, x: -9, y: -9)
                                    .shadow(color: Color("Shadow"), radius: 8, x: 9, y: 9)
                                
                            }
                        }
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                        .padding()
                        
                        VStack(alignment: .leading, spacing: 15){
                            Text("챌린지 기간 :")
                                .modifier(TextModifier(fontWeight: .normal, fontType: FontCustomType.body, color: .color2))
                            Text("\(challenge.startDate.createdDate) ~ \(challenge.endDate.createdDate)")
                                .modifier(TextModifier(fontWeight: .bold, fontType: FontCustomType.title3, color: .color2))
                        }
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                        .padding()
                        
                        VStack(alignment: .leading, spacing: 15){
                            Text("챌린지 금액 :")
                                .modifier(TextModifier(fontWeight: .normal, fontType: FontCustomType.body, color: .color2))
                            Text("\(challenge.limitMoney)원")
                                .modifier(TextModifier(fontWeight: .bold, fontType: FontCustomType.title3, color: .color2))
                        }
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                        .frame(minWidth: g.size.width / 1.1, alignment: .leading)
                        .padding(.bottom)
                        
                        //챌린지 참여인원에 따른 사용금액 그룹
                        if !challenge.inviteFriend.isEmpty {
                            ForEach(challengeRecordVM.challengeUsers.indices, id: \.self) { index in
                                HStack(spacing: 40) {
                                    VStack(spacing: 0) {
                                        VStack {
                                            if challengeRecordVM.challengeUsers[index].user.userProfile.isEmpty{
                                                Image(systemName: "person")
                                                    .font(.largeTitle)
                                            } else {
                                                AsyncImage(url: URL(string: challengeRecordVM.challengeUsers[index].user.userProfile)!) { Image in
                                                    Image
                                                        .resizable()
                                                } placeholder: {
                                                    Image(systemName: "person")
                                                        .font(.largeTitle)
                                                }
                                            }
                                            
                                        }
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: g.size.width / 6, height: g.size.height / 7)
                                        .clipShape(Circle())
                                        .foregroundColor(Color("Color2"))
                                        .background(
                                            Circle()
                                                .fill(
                                                    .shadow(.inner(color: Color("Shadow2"),radius: 5, x:3, y: 3))
                                                    .shadow(.inner(color: Color("Shadow3"), radius:5, x: -3, y: -3))
                                                )
                                                .foregroundColor(Color("Color1")))
                                        
                                        Text("\(challengeRecordVM.challengeUsers[index].user.userName)")
                                            .modifier(TextModifier(fontWeight: .normal, fontType: FontCustomType.body, color: .color2))
                                        
                                    }
                                    Text("총 \(challengeRecordVM.challengeUsers[index].totalMoney)원 사용")
                                        .modifier(TextModifier(fontWeight: .bold, fontType: FontCustomType.body, color: .color2))
                                }
                                .frame(minWidth: g.size.width / 1.1, minHeight: g.size.height / 8, alignment: .leading)
                            }
                            
                            //가장적게 쓴, 많이 쓴 사람
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
                                    .frame(width: g.size.width / 1.1, height: g.size.height / 3)
                                VStack(spacing: 0){
                                ForEach(userValue.indices , id: \.self) { index in
                                    
                                        HStack {
                                            if index == 0 {
                                                HStack {
                                                    Text("가장 많이 쓴 사람")
                                                        .padding(.trailing)
                                                    VStack {
                                                        VStack {
                                                            if userValue[index].user.userProfile.isEmpty {
                                                                Image(systemName: "person")
                                                                    .font(.largeTitle)
                                                            } else {
                                                                AsyncImage(url: URL(string: userValue[index].user.userProfile)!) { Image in
                                                                    Image
                                                                        .resizable()
                                                                } placeholder: {
                                                                    Image(systemName: "person")
                                                                        .font(.largeTitle)
                                                                }
                                                            }
                                                        }
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(width: g.size.width / 7, height: g.size.height / 11)
                                                        .clipShape(Circle())
                                                        .foregroundColor(Color("Color2"))
                                                        .background(
                                                            Circle()
                                                                .fill(
                                                                    .shadow(.inner(color: Color("Shadow2"),radius: 5, x:3, y: 3))
                                                                    .shadow(.inner(color: Color("Shadow3"), radius:5, x: -3, y: -3))
                                                                )
                                                                .foregroundColor(Color("Color1")))
                                                        
                                                        Text("\(userValue[index].user.userName)")
                                                    }
                                                }
                                            } else {
                                                HStack {
                                                    Text("가장 적게 쓴 사람")
                                                        .padding(.trailing)
                                                    VStack(spacing: 0) {
                                                        VStack {
                                                            if userValue[index].user.userProfile.isEmpty {
                                                                Image(systemName: "person")
                                                                    .font(.largeTitle)
                                                            } else {
                                                                AsyncImage(url: URL(string: userValue[index].user.userProfile)!) { Image in
                                                                    Image
                                                                        .resizable()
                                                                } placeholder: {
                                                                    Image(systemName: "person")
                                                                        .font(.largeTitle)
                                                                }
                                                            }
                                                        }
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(width: g.size.width / 7, height: g.size.height / 11)
                                                        .clipShape(Circle())
                                                        .foregroundColor(Color("Color2"))
                                                        .background(
                                                            Circle()
                                                                .fill(
                                                                    .shadow(.inner(color: Color("Shadow2"),radius: 5, x:3, y: 3))
                                                                    .shadow(.inner(color: Color("Shadow3"), radius:5, x: -3, y: -3))
                                                                )
                                                                .foregroundColor(Color("Color1")))
                                                        
                                                        Text("\(userValue[index].user.userName)")
                                                    }
                                                }
                                            }
                                        }
                                        .modifier(TextModifier(fontWeight: .normal, fontType: FontCustomType.subhead, color: .color2))
                                        .padding()
                                    }
                                }
                            }
                        } else {
                            VStack {
                                ForEach(challengeRecordVM.challengeHistoryUserList.indices, id:\.self) { index in
                                    
                                    VStack(alignment: .leading, spacing: 15){
                                        Text("총 사용 금액 :")
                                            .modifier(TextModifier(fontWeight: .normal, fontType: FontCustomType.body, color: .color2))
                                        Text("\(firestoreViewModel.challengeHistoryUserList[index].totalMoney)원")
                                            .modifier(TextModifier(fontWeight: .bold, fontType: FontCustomType.title3, color: .color2))
                                    }
                                    .minimumScaleFactor(0.5)
                                    .lineLimit(1)
                                    .frame(minWidth: g.size.width / 1.1, alignment: .leading)
                                }
                                
                                ForEach(tagValue.indices , id: \.self) { index in
                                    VStack {
                                        HStack {
                                            if index == 0 {
                                                Text("가장 많이 사용한 곳 :")
                                            } else {
                                                Text("가장 적게 사용한 곳:")
                                            }
                                            Spacer()
                                        }
                                        .modifier(TextModifier(fontWeight: .normal, fontType: FontCustomType.body, color: .color2))
                                        .padding()
                                        
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
                                                .frame(width: g.size.width / 1.1, height: g.size.height / 6)
                                            HStack {
                                                Text("\(tagValue[index].tag)")
                                                Text("\(tagValue[index].money)원")
                                            }
                                        }
                                    }
                                    .modifier(TextModifier(fontWeight: .bold, fontType: FontCustomType.title3, color: .color2))
                                }
                            }
                        }
                    }
                }
            }
            .onAppear{
                Task{
                    await challengeRecordVM.getChallengeUser(users: challenge.inviteFriend, challengeId: challenge.id)
                    // 각 유저별 총액 가져오기
                    try await challengeRecordVM.getChallengeTotalMoney(challengeId: challenge.id)
                    
                    // 과거 지출 기록 가져오기
                    guard let history = await challengeRecordVM.getHistoryExpenditure(gameId: challenge.id) else { return }
                    historyExpenditure = history
                    self.tagValue = self.parsingExpenditure(historyExpenditure!.expenditureHistory)
                    self.userValue = self.userValues(firestoreViewModel.challengeUsers)
                }
            }
        }
        .foregroundColor(Color("Color2"))
        .scrollIndicators(.hidden)
    }
}


struct RecordDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RecordDetailView(challenge: .constant(Challenge(id: "테스트아이디", gameTitle: "게임해보자", limitMoney: 1000, startDate: "abc", endDate: "def", inviteFriend: ["철수,영희"],waitingFriend: ["철수,영희"])))
    }
}
