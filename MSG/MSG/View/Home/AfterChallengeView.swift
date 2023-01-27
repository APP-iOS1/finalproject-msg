//
//  AfterChallengeView.swift
//  MSG
//
//  Created by 정소희 on 2023/01/17.
//

import SwiftUI

struct AfterChallengeView: View {
    
    let challenge: Challenge
    
    func dateCheck(startDate: String) -> Date {
        let formatter = DateFormatter()
        
        let dateString = startDate  //여기에다가 챌린지 시작날짜 받으면 괜찮지 않을까??
        
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        formatter.dateFormat = "yyyy년M월d일"
        
        let date = formatter.date(from: dateString) ?? Date()
        
        return date
    }
    
    // 챌린지가 끝나는 날을 알려면 이걸 쓰면 되나??
    func isChatTomorrowWithString(startDate: String, endDate: String) -> Bool {
        
        let firebaseFormat = "yyyy년 MM월 dd일"
        let formatter = DateFormatter()
        formatter.dateFormat = firebaseFormat
        formatter.locale = Locale(identifier: "ko")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        
        guard let tempDate1 = formatter.date(from: endDate) else {
            return false
        }
        guard let tempDate2 = formatter.date(from: startDate) else {
            return false
        }
        
        let date1 = Calendar.current.dateComponents([.year, .month, .day], from: tempDate1)
        let date2 = Calendar.current.dateComponents([.year, .month, .day], from: tempDate2)
        
        if date1.year == date2.year && date1.month == date2.month && date1.day == date2.day {
            //날짜 같으면 false
            return false
        } else {
            //날짜 다르면 false
            return true
        }
        
    }
    
    @State private var birthDate = Date()
    var frameWidth = UIScreen.main.bounds.width
    var frameHeight = UIScreen.main.bounds.height
    var body: some View {
        
        ZStack{
            Color("Background").ignoresSafeArea()
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 15) {
                    Group{
                        HStack{
                            Text(challenge.gameTitle)
                                .font(.title2.bold())
                            Spacer()
                        }
                        
                        HStack{
                            Text("제한 금액 : \(challenge.limitMoney)원")
                                .font(.title3.bold())
                            Spacer()
                        }
                        HStack{
                            Text("\(challenge.startDate.createdDate) ~ \(challenge.endDate.createdDate)")
                                .fontWeight(.medium)
                                .padding(.bottom)
                            Spacer()
                        }
                    }.padding(1)
                    
                    Group{
                        // 싱글게임 멀티게임 다르게 보여주기
                        if challenge.inviteFriend.isEmpty {
                            SingleGameProgressBar()
                        } else {
                            MultiGameProgressBar(stats: Stats(title: "", currentDate: 0, goal: 0, color: Color.brown))
                        }
                        HStack{
                            Text("지금까지")
                            Text("75,500원")
                                .underline()
                            Text("사용")
                            
                        }
                        .padding(.top)
                        
                        VStack{
                            //챌린지 시작날짜~오늘날짜 계산
//                            Text(dateCheck(startDate: challenge.startDate), style: .offset)
                            CountDownView(endDate: Double(challenge.endDate)!)
                        }
                    }.font(.title3.bold())
                        .padding(5)
                    
                    //MARK: - 상세 소비 내역 확인 네비게이션 링크
                    Group{
                        NavigationLink(destination: ChartView(), label: {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("Point2"))
                                .frame(width: frameWidth / 1.38, height: frameHeight / 16.5)
                                .overlay {
                                    Text("상세 소비 내역 확인하기")
                                        .foregroundColor(Color("Font2"))
                                }
                                .padding(.bottom, 3)
                        })
                        
                        //MARK: - 추가하기 네비게이션 링크
                        NavigationLink(destination: SpendingWritingView(), label: {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("Point2"))
                                .frame(width: frameWidth / 1.38, height: frameHeight / 16.5)
                                .overlay {
                                    Text("추가하기")
                                        .foregroundColor(Color("Font2"))
                                }
                        })
                        Spacer()
                    }
                    Spacer()
                }.foregroundColor(Color("Font"))
                    .padding(.horizontal)
            }

                .padding()

        }
    }
}

struct AfterChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        AfterChallengeView(challenge: Challenge(id: "", gameTitle: "", limitMoney: 300000, startDate: "2023년01월18일", endDate: "2023년01월31일", inviteFriend: []))
    }
}
