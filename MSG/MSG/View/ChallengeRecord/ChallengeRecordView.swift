//
//  ChallengeRecordView.swift
//  MSG
//
//  Created by 전준수 on 2023/01/17.
//

import SwiftUI

// 유저의 챌린지 기록 View
struct ChallengeRecordView: View {
    
    @EnvironmentObject var fireStoreViewModel: FireStoreViewModel
    
    var body: some View {
        
        GeometryReader {g in
            ZStack {
                // 백그라운드
                Color("Color1")
                    .ignoresSafeArea()
                
                VStack {
                    // 타이틀
                    VStack(alignment: .leading) {
                        Text("기록")
                            .modifier(TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.largeTitle, color: FontCustomColor.color2))
                        Text("Money Save Game")
                            .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.caption, color: FontCustomColor.color2))
                    }
                    .frame(minWidth: g.size.width / 1.1, minHeight: g.size.height / 8, alignment: .leading)
                    .padding(.top)
                    
                    if fireStoreViewModel.challengeHistoryArray.isEmpty {
                        Spacer()
                        Text("비어있습니다.")
                            .modifier(TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.title, color: FontCustomColor.color2))
                        Spacer()
                    } else {
                        // 챌린지 기록 리스트
                        // (List에 NavigationLink를 사용하면 꺽쇠 > 버튼은 숨길 수 없어서 List를 사용하지 않음)
                        ScrollView(.vertical, showsIndicators: false) {
                            ForEach(fireStoreViewModel.challengeHistoryArray, id: \.self) { history
                                in ChallegeListCell(challenge: history)
                            }
                            .foregroundColor(Color("Color2"))
                            .frame(minWidth: g.size.width / 1.2, minHeight: g.size.height / 8)
                            .shadow(color: Color("Shadow3"), radius: 8, x: -9, y: -9)
                            .shadow(color: Color("Shadow"), radius: 8, x: 9, y: 9)
                            .padding(16)
                            .background(Color("Color1"))
                            .cornerRadius(20)
                            .shadow(color: Color("Shadow3"), radius: 8, x: -9, y: -9)
                            .shadow(color: Color("Shadow"), radius: 8, x: 9, y: 9)
                            .padding()
                            .padding(.top, 10)
                            
                            Spacer()
                        } // ScrollView
                    }
                } // VStack
            } // ZStack
        }
        .onAppear{
            Task{
                try await fireStoreViewModel.fetchPreviousGameHistory()
            }
            
        }
    }
}

// 챌린지 리스트 커스텀
struct ChallegeListCell: View {
    @State var challenge: Challenge
    @State var challengeUsers: FireStoreViewModel.ChallengeUserData = []
    // 예시 (추후 데이터 연결 시 필요 없음)
    @EnvironmentObject var fireStoreViewModel: FireStoreViewModel
    
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
                guard let userArray = await fireStoreViewModel.fetchChallengeUsersData(challenge.inviteFriend, challenge.id) else {return}
                self.challengeUsers = userArray
            }
        }
    }
}

struct ChallengeRecordView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeRecordView()
            .environmentObject(FireStoreViewModel())
    }
}
