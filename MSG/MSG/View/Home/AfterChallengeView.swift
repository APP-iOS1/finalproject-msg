//
//  AfterChallengeView.swift
//  MSG
//
//  Created by 정소희 on 2023/01/17.
//

import SwiftUI

struct AfterChallengeView: View {
    
    @EnvironmentObject var fireStoreViewModel: FireStoreViewModel
    @State private var deleteSingleGame: Bool = false
    let challenge: Challenge
    
    func parsingExpenditure(expenditure: [String:[String]]) {
        print(#function)
        fireStoreViewModel.totalMoney = 0
        for (_ , key) in expenditure {
            for moneyHistory in key {
                for i in moneyHistory.components(separatedBy: "_") {
                    if let money = Int(i) {
                        fireStoreViewModel.totalMoney += money
                        print(money)
                    }
                }
            }
        }
    }
    
    @State private var birthDate = Date()
    var frameWidth = UIScreen.main.bounds.width
    var frameHeight = UIScreen.main.bounds.height
    var body: some View {
        
        GeometryReader { g in
            ZStack{
                Color("Color1").ignoresSafeArea()
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 15) {
                        Group{
                            HStack{
                                Text(challenge.gameTitle)
                                    .modifier(TextTitleBold())
                                Spacer()
                                Button {
                                    deleteSingleGame.toggle()
                                } label: {
                                    Image(systemName: "x.circle.fill")
                                }
                                .buttonStyle(.borderless)
                                .frame(width: g.size.width / 15, height: g.size.height / 30)
                                .clipShape(Circle())
                                .padding(4)
                                .foregroundColor(Color("Color2"))
                                .background(
                                    Circle()
                                        .fill(
                                            .shadow(.inner(color: Color("Shadow2"),radius: 5, x:3, y: 3))
                                            .shadow(.inner(color: Color("Shadow3"), radius:5, x: -3, y: -3))
                                        )
                                        .foregroundColor(Color("Color1")))
                                .alert("게임을 포기하시겠습니까?", isPresented: $deleteSingleGame) {
                                    Button("확인", role: .destructive) {
                                        Task {
                                            if let game = fireStoreViewModel.currentGame {
                                                if !(game.inviteFriend.isEmpty) {
                                                    await fireStoreViewModel.giveUpMultiGame()
                                                } else {
                                                    await fireStoreViewModel.deleteSingleGame()
                                                }
                                                fireStoreViewModel.currentGame = nil
                                            }
                                        }
                                    }
                                    Button("취소", role: .cancel) {}
                                } message: {
                                    Text("지금까지의 기록한 내역이 초기화 됩니다. 그래도 포기하시겠습니까?")
                                }
                            }
                            
                            HStack{
                                Text("제한 금액 : \(challenge.limitMoney)원")
                                Spacer()
                            }
                            HStack{
                                Text("\(challenge.startDate.createdDate) ~ \(challenge.endDate.createdDate)")
                                    .padding(.bottom)
                                Spacer()
                            }
                        }.padding(1)
                        
                        Group{
                            // 싱글게임 멀티게임 다르게 보여주기
                            if challenge.inviteFriend.isEmpty {
                                SingleGameProgressBar(percentage: $fireStoreViewModel.totalMoney, limitMoney: challenge.limitMoney)
                            } else {
                                MultiGameProgressBar(stats: Stats(title: "", currentDate: 0, goal: 0, color: Color.brown))
                            }
                            HStack{
                                Text("지금까지")
                                Text("\(fireStoreViewModel.totalMoney)원")
                                    .underline()
                                Text("사용")
                                
                            }
                            .padding(.top)
                            
                            VStack{
                                //챌린지 시작날짜~오늘날짜 계산
                                CountDownView(endDate: Double(challenge.endDate)!)
                            }
                        }
                        .padding(5)
                        
                        //MARK: - 상세 소비 내역 확인 네비게이션 링크
                        Group{
                            
                            if fireStoreViewModel.expenditure != nil {
                                NavigationLink(destination: ChartView(), label: {
                                    Text("상세 소비 내역 확인하기")
                                        .modifier(TextViewModifier(color: "Color2"))
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
                                Button{ } label: {
                                    Text("상세 소비 내역 확인하기")
                                        .modifier(TextViewModifier(color: "Color2"))
                                        .frame(width: g.size.width / 1.4, height: g.size.height / 34)
                                        .shadow(color: Color("Shadow3"), radius: 8, x: -9, y: -9)
                                        .shadow(color: Color("Shadow"), radius: 8, x: 9, y: 9)
                                        .padding(20)
                                        .background(Color("Color1"))
                                        .cornerRadius(20)
                                }
                                .shadow(color: Color("Shadow3"), radius: 8, x: -9, y: -9)
                                .shadow(color: Color("Shadow"), radius: 8, x: 9, y: 9)
                            }
                            
                            
                            //MARK: - 추가하기 네비게이션 링크
                            NavigationLink(destination: SpendingWritingView(), label: {
                                Text("추가하기")
                                    .modifier(TextViewModifier(color: "Color2"))
                                    .frame(width: g.size.width / 1.4, height: g.size.height / 34)
                                    .shadow(color: Color("Shadow3"), radius: 8, x: -9, y: -9)
                                    .shadow(color: Color("Shadow"), radius: 8, x: 9, y: 9)
                                    .padding(20)
                                    .background(Color("Color1"))
                                    .cornerRadius(20)
                            })
                            .shadow(color: Color("Shadow3"), radius: 8, x: -9, y: -9)
                            .shadow(color: Color("Shadow"), radius: 8, x: 9, y: 9)
                            
                            Spacer()
                        }
                        Spacer()
                    }.foregroundColor(Color("Color2"))
                        .padding(.horizontal)
                }
                .modifier(TextViewModifier(color: "Color2"))
                .padding()
                
            }
            .onChange(of: fireStoreViewModel.expenditureList, perform: { newValue in
                parsingExpenditure(expenditure: fireStoreViewModel.expenditureList)
            })
        }
    }
}

//struct AfterChallengeView_Previews: PreviewProvider {
//    static var previews: some View {
//        AfterChallengeView(challenge: Challenge(id: "", gameTitle: "", limitMoney: 300000, startDate: "2023년01월18일", endDate: "2023년01월31일", inviteFriend: []))
//    }
//}

