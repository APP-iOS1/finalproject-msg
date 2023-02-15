//
//  ChallengeRecordListCell.swift
//  MSG
//
//  Created by zooey on 2023/02/13.
//

import SwiftUI

struct ChallengeRecordListCell: View {
    
    @StateObject var challengeRecordVM = ChallengeRecordViewModel()
    @State var challenge: Challenge
    @State var challengeUsers: ChallengeRecordViewModel.ChallengeUserData = []
   
    var body: some View {
        GeometryReader { g in
            NavigationLink {
                // 넘어갈 뷰 연결 부분
                RecordDetailView(challenge: $challenge)
            } label: {
                HStack {
                    if !challenge.inviteFriend.isEmpty {
                        Image(systemName: "figure.2.arms.open")
                            .font(.largeTitle)
                            .padding()
                    } else {
                        Image(systemName: "figure.arms.open")
                            .font(.largeTitle)
                            .padding()
                    }
                    
                    VStack(alignment: .leading, spacing: 5){
                        Text("\(challenge.gameTitle)")
                            .modifier(TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.title3, color: FontCustomColor.color2))
                            .lineLimit(1)
                        
                        // 챌린지에 함께한 친구들
                        if !challenge.inviteFriend.isEmpty {
                            VStack(alignment: .leading) {
                                Text("참여자 :")
                                HStack {
                                    ForEach(challengeUsers.indices, id:\.self) { index in
                                        Text("\(challengeUsers[index].user.userName)")
                                    }
                                }
                            }
                            .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.body, color: FontCustomColor.color2))
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                        }
                        
                        // 챌린지 기간(데이터 연결 시에 기간 정렬)
                        VStack(alignment: .leading) {
                            Text("챌린지 기간 : ")
                            Text("\(challenge.startDate.createdDate) ~ \(challenge.endDate.createdDate)")
                        }
                        .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.body, color: FontCustomColor.color2))
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                    } // VStack
                } // HStack
            } // NavigationLink
        }
        .onAppear {
            Task {
                guard let userArray = await challengeRecordVM.getUserData(user: challenge.inviteFriend, challengeId: challenge.id) else { return }
                self.challengeUsers = userArray
            }
        }
    }
}

struct ChallengeRecordListCell_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeRecordListCell(challenge: Challenge(id: "", gameTitle: "", limitMoney: 0, startDate: "", endDate: "", inviteFriend: [], waitingFriend: []))
    }
}
