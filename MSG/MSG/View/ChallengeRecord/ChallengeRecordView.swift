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
        ZStack {
            // 백그라운드
            Color("Background")
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                
                // 타이틀
                Text("챌린지 기록")
                    .foregroundColor(Color("Font"))
                    .font(.title.bold())
                    .padding()
                
                // 챌린지 기록 리스트
                // (List에 NavigationLink를 사용하면 꺽쇠 > 버튼은 숨길 수 없어서 List를 사용하지 않음)
                ScrollView {
                    Section {
                        ForEach(fireStoreViewModel.challengeHistoryArray, id: \.self) { history in
                            MyList(challenge: history)
                        }
                    }
                    .listRowBackground(Color("Background"))
                    .listRowInsets(EdgeInsets.init(top: 10, leading: 10, bottom: 10, trailing: 10))
                    .padding(.bottom, 10)
                    
                    Spacer()
                } // ScrollView
            } // VStack
        } // ZStack
        .onAppear{
            Task{
                try await fireStoreViewModel.fetchPreviousGameHistory()
            }
            
        }
    }
}

// 챌린지 리스트 커스텀
struct MyList: View {
    @State var challenge: Challenge
    // 예시 (추후 데이터 연결 시 필요 없음)
    
    var body: some View {
        
        NavigationLink {
            // 넘어갈 뷰 연결 부분
            RecordDetailView(challenge: $challenge)
        } label: {
            HStack {
                
                Image(systemName: "magazine.fill")
                    .font(.system(size: 40))
                    .foregroundColor(Color("Font"))
                    .frame(width: 60)
                    .padding()
                
                VStack(alignment: .leading, spacing: 0){
                    
                    Divider().opacity(0)
                    
                    Text("\(challenge.gameTitle)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color("Font"))
                        .padding(.bottom, 10)
                        .lineLimit(1)
                    
                    // 챌린지에 함께한 친구들
                    if !challenge.inviteFriend.isEmpty {
                        HStack{
                            Text("참여자 :")
                                .font(.footnote)
                                .foregroundColor(Color("Font"))
                            ForEach(challenge.inviteFriend, id:\.self) { name in
                                Text("\(name)")
                                    .font(.footnote)
                                    .foregroundColor(Color("Font"))
                            }
                        }
                    }
                  
                    
                    // 챌린지 기간(데이터 연결 시에 기간 정렬)
                    HStack{
                        Text("챌린지 기간 : \(challenge.startDate) ~ \(challenge.endDate)")
                            .font(.footnote)
                            .foregroundColor(Color("Font"))
                    }
                  
                    
                } // VStack
            } // HStack
            .frame(width: 350,height: 110, alignment: .center)
            .background(Color("Point2"))
            .cornerRadius(10)
        } // NavigationLink
    }
}

struct ChallengeRecordView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeRecordView()
            .environmentObject(FireStoreViewModel())
    }
}
