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

    var body: some View {
        ZStack{
            Color("Background").ignoresSafeArea()
            ScrollView{
                VStack{
                    //타이틀, 날짜 그룹
                    Group{
                        HStack{
                            Text(challenge.gameTitle)
                            Spacer()
                            NavigationLink(destination: ChartView()) {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color("Point2"))
                                    .frame(width: 80, height: 45)
                                    .overlay {
                                        Text("상세내역")
                                    }
                            }
                        }
                        Divider()
                        HStack{
                            Text("\(challenge.startDate.createdDate) ~ \(challenge.endDate.createdDate)")
                                .padding(.bottom, 20)
                            Spacer()
                        }
                    }
                    .padding(.horizontal)
                    .modifier(TextViewModifier(color: "Font"))
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
                                                    .font(.largeTitle)
                                                    .background(content: {Color("Point2") })
                                                .padding(.trailing)
                                            } placeholder: { }
                                        }
                                        Text("\(firestoreViewModel.challengeUsers[index].user.userName)")
                                    }
                                    Text("총 \(firestoreViewModel.challengeUsers[index].totalMoney)원 사용")
                                    Spacer()
                                }
                            }
                            
                        }.padding([.vertical, .horizontal])
                            .modifier(TextViewModifier(color: "Font"))
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
                        .modifier(TextViewModifier(color: "Font"))
                    } else {
                        VStack {
                            Text("총 사용 금액 : ")
                            Text("지출이 가장 많은 태그 : ")
                            Text("지출이 가장 적은 태그 : ")
                        }
                        .modifier(TextViewModifier(color: "Font"))
                    }
                }
            }
            .onAppear{
                Task{
                    await firestoreViewModel.fetchChallengeUsers(challenge.inviteFriend, challenge.id)
         
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
