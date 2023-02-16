//
//  AfterChallengeView.swift
//  MSG
//
//  Created by 정소희 on 2023/01/17.
//

import SwiftUI

struct AfterChallengeView: View {
    
    @ObservedObject var challengeViewModel: ChallengeViewModel
    @State private var giveUpGame: Bool = false
    @EnvironmentObject var notiManager: NotificationManager
    
    @State private var birthDate = Date()
    @State private var showingAlert: Bool = false
    var body: some View {
        
        GeometryReader { g in
            ZStack{
                Color("Color1").ignoresSafeArea()
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 15) {
                        Group{
                            HStack {
                                Text(challengeViewModel.currentGame!.gameTitle)
                                    .modifier(TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.largeTitle, color: FontCustomColor.color2))
                                Spacer()
                            }
                            
                            HStack{
                                Text("제한 금액 : \(challengeViewModel.currentGame!.limitMoney)원")
                                    .modifier(TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.title3, color: FontCustomColor.color2))
                                Spacer()
                            }
                            HStack{
                                Text("\(challengeViewModel.currentGame!.startDate.createdDate) ~ \(challengeViewModel.currentGame!.endDate.createdDate)")
                                    .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.body, color: FontCustomColor.color2))
                                    .padding(.bottom)
                                Spacer()
                            }
                        }.padding(1)
                        
                        Group{
                            // 싱글게임 멀티게임 다르게 보여주기
                            if challengeViewModel.currentGame!.inviteFriend.isEmpty {
                                ProgressBar2(percentage: $challengeViewModel.totalMoney,limitMoney: challengeViewModel.currentGame!.limitMoney)
                                    .frame(height:30)
                            } else {
                                ForEach(challengeViewModel.currentGame!.inviteFriend,id:\.self) {friend in
                                    MultiProgressBar(friend: friend, limitMoney: challengeViewModel.currentGame!.limitMoney)
                                }
                            }
                            Spacer()
                            HStack{
                                Text("지금까지")
                                Text("\(challengeViewModel.expenditure?.totalMoney ?? 0)원")
                                    .underline()
                                Text("사용")
                                
                            }
                            .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.body, color: FontCustomColor.color2))
                            .padding(.top)
                            VStack{
                                //챌린지 시작날짜~오늘날짜 계산
                                CountDownView(endDate: Double(challengeViewModel.currentGame!.endDate)!)
                                    .modifier(TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.title3, color: FontCustomColor.color2))
                            }
                        }
                        .padding(.top, g.size.height / 40)
                        
                        //MARK: - 상세 소비 내역 확인 네비게이션 링크
                        Group{
                            
                            if challengeViewModel.expenditure != nil {
                               
                                NavigationLink(destination:   ChartView(expenditure: challengeViewModel.expenditure!, limitMoney: Float(challengeViewModel.currentGame!.limitMoney)), label: {
                                    Text("상세 소비 내역 확인하기")
                                        .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.body, color: FontCustomColor.color2))
                                        .frame(width: g.size.width / 1.4, height: g.size.height / 34)
                                        .shadow(color: Color("Shadow3"), radius: 8, x: -9, y: -9)
                                        .shadow(color: Color("Shadow"), radius: 8, x: 9, y: 9)
                                        .padding(20)
                                        .background(Color("Color1"))
                                        .cornerRadius(20)
                                        .shadow(color: Color("Shadow3"), radius: 8, x: -9, y: -9)
                                        .shadow(color: Color("Shadow"), radius: 8, x: 9, y: 9)
                                })
                            } else {
                                Button{
                                    self.showingAlert = true
                                } label: {
                                    Text("상세 소비 내역 확인하기")
                                        .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.body, color: FontCustomColor.color2))
                                        .frame(width: g.size.width / 1.4, height: g.size.height / 34)
                                        .shadow(color: Color("Shadow3"), radius: 8, x: -9, y: -9)
                                        .shadow(color: Color("Shadow"), radius: 8, x: 9, y: 9)
                                        .padding(20)
                                        .background(Color("Color1"))
                                        .cornerRadius(20)
                                }
                                .shadow(color: Color("Shadow3"), radius: 8, x: -9, y: -9)
                                .shadow(color: Color("Shadow"), radius: 8, x: 9, y: 9)
                                .alert("소비내역없음", isPresented: $showingAlert) {
                                    Button {
                                    } label: {
                                        Text("확인")
                                    }
                                } message: {
                                    Text("지출항목을 추가해 주세요")
                                        .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.body, color: FontCustomColor.color2))
                                }

                            }
                            
                            
                            //MARK: - 추가하기 네비게이션 링크
                            NavigationLink(destination: SpendingWritingView(), label: {
                                Text("지출 추가하기")
                                    .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.body, color: FontCustomColor.color2))
                                    .frame(width: g.size.width / 1.4, height: g.size.height / 34)
                                    .shadow(color: Color("Shadow3"), radius: 8, x: -9, y: -9)
                                    .shadow(color: Color("Shadow"), radius: 8, x: 9, y: 9)
                                    .padding(20)
                                    .background(Color("Color1"))
                                    .cornerRadius(20)
                            })
                            .shadow(color: Color("Shadow3"), radius: 8, x: -9, y: -9)
                            .shadow(color: Color("Shadow"), radius: 8, x: 9, y: 9)
                            
                        Button {
                            giveUpGame.toggle()
                        } label: {
                            if let game = challengeViewModel.currentGame {
                                if !(game.inviteFriend.isEmpty) {
                                    Text("도망가기")
                                } else {
                                    Text("포기하기")
                                }
                            }
                        }
                        .foregroundColor(.red)
                        .alert("게임을 포기하시겠습니까?", isPresented: $giveUpGame) {
                            Button("확인", role: .destructive) {
                                Task {
                                    if let game = challengeViewModel.currentGame {
                                        if !(game.inviteFriend.isEmpty) {
                                            await challengeViewModel.giveUpMultiGame()
                                        } else {
                                            await challengeViewModel.deleteSingleGame()
                                        }
                                        challengeViewModel.currentGame = nil
                                        challengeViewModel.expenditure = nil
                                        challengeViewModel.expenditureList = [:]
                                    }
                                }
                            }
                            Button("취소", role: .cancel) {}
                        } message: {
                            Text("지금까지의 기록한 내역이 초기화 됩니다. 그래도 포기하시겠습니까?")
                        }
                            
                            Spacer()
                        }
                        .padding(.top, g.size.height / 34)
                        Spacer()
                    }.foregroundColor(Color("Color2"))
                        .padding(.horizontal)
                }
                .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.body, color: FontCustomColor.color2))
                .padding()
                
            }
            .task { await challengeViewModel.fetchExpenditure() }
            .onChange(of: challengeViewModel.expenditureList, perform: { newValue in
                challengeViewModel.parsingExpenditure(expenditure: challengeViewModel.expenditureList)
            })
            .onAppear {
                Task {
                    await challengeViewModel.fetchGame()
                }
            }
        }
    }
}

//struct AfterChallengeView_Previews: PreviewProvider {
//    static var previews: some View {
//        AfterChallengeView(challenge: Challenge(id: "", gameTitle: "", limitMoney: 300000, startDate: "2023년01월18일", endDate: "2023년01월31일", inviteFriend: []))
//    }
//}

