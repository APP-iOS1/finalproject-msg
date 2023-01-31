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
        
        GeometryReader { g in
            ZStack{
                Color("Color1").ignoresSafeArea()
                ScrollView{
                    VStack{
                        //타이틀, 날짜 그룹
                        Group{
                            HStack{
                                Text(challenge.gameTitle)
                                    .font(.title3.bold())
                                Spacer()
                                NavigationLink(destination: ChartView()) {
                                    
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
                                    .padding(.bottom, 20)
                                Spacer()
                            }
                        }.padding(.horizontal)
                        //챌린지 참여인원에 따른 사용금액 그룹
                        if !challenge.inviteFriend.isEmpty {
                            Group{
                                ForEach(firestoreViewModel.challengeUsers.indices, id: \.self) { index in
                                    HStack{
                                        VStack{
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
                                                .padding(.trailing)
                                            Text("\(firestoreViewModel.challengeUsers[index].user.userName)")
                                        }
                                        Text("총 \(firestoreViewModel.challengeUsers[index].totalMoney)원 사용")
                                        Spacer()
                                    }
                                }
                                
                            }.padding([.vertical, .horizontal])
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
                        } else {
                            VStack {
                                Text("총 사용 금액 : ")
                                Text("지출이 가장 많은 태그 : ")
                                Text("지출이 가장 적은 태그 : ")
                            }
                        }
                    }
                }
                .onAppear{
                    Task{
                        await firestoreViewModel.fetchChallengeUsers(challenge.inviteFriend, challenge.id)
                        
                    }
                }
            }
            .foregroundColor(Color("Color2"))
        }
    }
}

struct RecordDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RecordDetailView(challenge: .constant(Challenge(id: "테스트아이디", gameTitle: "게임해보자", limitMoney: 1000, startDate: "abc", endDate: "def", inviteFriend: ["철수,영희"],waitingFriend: ["철수,영희"])))
    }
}
