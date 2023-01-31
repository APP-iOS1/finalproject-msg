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
                    HStack {
                        Text("챌린지 기록")
                        Spacer()
                    }
                    .modifier(TextTitleBold())
                    .padding()
                    
                    // 챌린지 기록 리스트
                    // (List에 NavigationLink를 사용하면 꺽쇠 > 버튼은 숨길 수 없어서 List를 사용하지 않음)
                    ScrollView {
                       
                            ForEach(fireStoreViewModel.challengeHistoryArray, id: \.self) { history in
                                MyList(challenge: history)
                            }
                            .foregroundColor(Color("Color2"))
                            .frame(width: g.size.width / 1.2, height: g.size.height / 8)
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
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40)
                    .padding([.trailing], 20)
                
                VStack(alignment: .leading){
                    Text("\(challenge.gameTitle)")
                        .modifier(TextTitleBold())
                        .padding(.bottom, 10)
                        .lineLimit(1)
                    
                    // 챌린지에 함께한 친구들
                    if !challenge.inviteFriend.isEmpty {
                        VStack(alignment: .leading) {
                            Text("참여자 :")
                                .modifier(TextViewModifier(color: "Color2"))
                            ForEach(challenge.inviteFriend, id:\.self) { name in
                                Text("\(name)")
                                    .modifier(TextViewModifier(color: "Color2"))
                            }
                        }
                    }
                    
                    // 챌린지 기간(데이터 연결 시에 기간 정렬)
                    VStack(alignment: .leading) {
                        Text("챌린지 기간 : ")
                        Text("\(challenge.startDate.createdDate) ~ \(challenge.endDate.createdDate)")
                    }
                    .modifier(TextViewModifier(color: "Color2"))
                    
                } // VStack
            } // HStack
        } // NavigationLink
    }
}

struct ChallengeRecordView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeRecordView()
            .environmentObject(FireStoreViewModel())
    }
}
