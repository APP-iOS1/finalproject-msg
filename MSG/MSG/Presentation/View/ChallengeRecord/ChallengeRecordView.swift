//
//  ChallengeRecordView.swift
//  MSG
//
//  Created by 전준수 on 2023/01/17.
//

import SwiftUI

// 유저의 챌린지 기록 View
struct ChallengeRecordView: View {
    
    @StateObject var challengeRecordVM = ChallengeRecordViewModel()
    
    var body: some View {
        
        GeometryReader { g in
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
                    
                    if challengeRecordVM.challengeHistoryArray.isEmpty {
                        Spacer()
                        Text("비어있습니다.")
                            .modifier(TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.title, color: FontCustomColor.color2))
                        Spacer()
                    } else {
                        // 챌린지 기록 리스트
                        // (List에 NavigationLink를 사용하면 꺽쇠 > 버튼은 숨길 수 없어서 List를 사용하지 않음)
                        ScrollView(.vertical, showsIndicators: false) {
                            ForEach(challengeRecordVM.challengeHistoryArray, id: \.self) { history
                                in ChallengeRecordListCell(challenge: history)
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
                try await challengeRecordVM.getChallengeHistory()
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
