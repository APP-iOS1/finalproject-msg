//
//  AfterChallengeView.swift
//  MSG
//
//  Created by 정소희 on 2023/01/17.
//

import SwiftUI

struct AfterChallengeView: View {
    @EnvironmentObject var fireStoreViewModel: FireStoreViewModel
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
                                Spacer()
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
                            .modifier(TextViewModifier(color: "Color2"))
                        
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
                        }.modifier(TextViewModifier(color: "Color2"))
                            .padding(5)
                        
                        //MARK: - 상세 소비 내역 확인 네비게이션 링크
                        Group{
                            
                            if fireStoreViewModel.expenditure != nil {
                                NavigationLink(destination: ChartView(), label: {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color("Point2"))
                                        .frame(width: frameWidth / 1.38, height: frameHeight / 16.5)
                                        .overlay {
                                            Text("상세 소비 내역 확인하기")
                                                .foregroundColor(Color("Color2"))
                                        }
                                        .padding(.bottom, 3)
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
                                    
                                    //                                RoundedRectangle(cornerRadius: 10)
                                    //                                    .fill(Color("Point3"))
                                    //                                    .frame(width: frameWidth / 1.38, height: frameHeight / 16.5)
                                    //                                    .overlay {
                                    //
                                    //                                            .foregroundColor(Color("Color2"))
                                    //                                    }
                                    //                                    .padding(.bottom, 3)
                                }
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
                                //
                                //                            RoundedRectangle(cornerRadius: 10)
                                //                                .fill(Color("Point2"))
                                //                                .frame(width: frameWidth / 1.38, height: frameHeight / 16.5)
                                //                                .overlay {
                                //
                                //                                        .foregroundColor(Color("Color2"))
                                //                                }
                            })
                            Spacer()
                        }
                        Spacer()
                    }.foregroundColor(Color("Color2"))
                        .padding(.horizontal)
                }
                
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
