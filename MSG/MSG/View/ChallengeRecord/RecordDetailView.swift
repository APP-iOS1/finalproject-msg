//
//  RecordDetailView.swift
//  MSG
//
//  Created by 정소희 on 2023/01/18.
//

import SwiftUI

struct RecordDetailView: View {
    @State private var userList:[(nickName: String, totalMoney: Int, profileImage: String)] = []
    @EnvironmentObject private var firestoreViewModel: FireStoreViewModel
    @Binding var challenge: Challenge

    var body: some View {
        ZStack{
            Color("Background").ignoresSafeArea()
            ScrollView{
                VStack{
                    //타이틀, 날짜 그룹
                    Group{
                        HStack{
                            Text(challenge.gameTitle)
                                .font(.title3.bold())
                                .foregroundColor(Color("Font"))
                            Spacer()
                        }
                        Divider()
                        HStack{
                            Text("\(challenge.startDate) ~ \(challenge.endDate)")
                                .padding(.bottom, 20)
                            Spacer()
                        }
                    }.padding(.horizontal)
                        .foregroundColor(Color("Font"))
                    //챌린지 참여인원에 따른 사용금액 그룹
                    if !challenge.inviteFriend.isEmpty {
                        Group{
                            ForEach(userList.indices, id: \.self) { index in
                                HStack{
                                    VStack{
                                        Image(systemName: "person")
                                            .font(.largeTitle)
                                            .background(content: {
                                                Color("Point2")
                                            })
                                            .padding(.trailing)
                                        Text("\(userList[index].nickName)")
                                    }
                                    Text("총 \(userList[index].totalMoney)원 사용")
                                    Spacer()
                                }
                            }
                            
                        }.padding([.vertical, .horizontal])
                            .foregroundColor(Color("Font"))
                        //가장적게 쓴, 많이 쓴 사람 그룹
                        Group{
                            HStack{
                                Text("가장 적게 쓴 사람")
                                    .padding(.trailing)
                                Image(systemName: "person")
                                    .font(.largeTitle)
                                    .background(content: {
                                        Color("Point2")
                                    })
                            }.padding(.top, 20)
                            HStack{
                                Text("가장 많이 쓴 사람")
                                    .padding(.trailing)
                                Image(systemName: "person")
                                    .font(.largeTitle)
                                    .background(content: {
                                        Color("Point2")
                                    })
                            }
                        }
                        .padding([.vertical, .horizontal], 10)
                        .foregroundColor(Color("Font"))
                    }
                }
                
            }
            .onAppear{
                Task{
                    userList.removeAll()
                    try await firestoreViewModel.fetchChallengeTotalMoney("goodGame")
                    print(firestoreViewModel.challengeHistoryUserList)
                    for (user, totalMoney) in firestoreViewModel.challengeHistoryUserList{
                        if let msg = try await firestoreViewModel.fetchUserInfo(user){
                            userList.append((msg.nickName ,totalMoney ,msg.profilImage))
                        }
                    }
                }
            }
            .toolbar { detailViewToolbar() }
        }
    }
    
    func detailViewToolbar() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            NavigationLink(destination: ChartView()) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color("Point2"))
                    .frame(width: 80, height: 45)
                    .overlay {
                        Text("상세내역")
                            .foregroundColor(Color("Font"))
                            .font(.subheadline)
                    }
            }
        }
    }
}

struct RecordDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RecordDetailView(challenge: .constant(Challenge(id: "테스트아이디", gameTitle: "게임해보자", limitMoney: 1000, startDate: "abc", endDate: "def", inviteFriend: ["철수,영희"],waitingFriend: ["철수,영희"])))
    }
}
