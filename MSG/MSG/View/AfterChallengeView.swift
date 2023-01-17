//
//  AfterChallengeView.swift
//  MSG
//
//  Created by 정소희 on 2023/01/17.
//

import SwiftUI

struct AfterChallengeView: View {
    
    var dateFormatter : DateFormatter {
        let formatter = DateFormatter()
        
        //한국 시간으로 표시
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        //형태 변환
        formatter.dateFormat = "yyyy년 M월 d일"
        
        return formatter
    }
    
    func dateCheck(startDate: String) -> Date {
        let formatter = DateFormatter()
        
        let dateString = startDate  //여기에다가 챌린지 시작날짜 받으면 괜찮지 않을까??
        
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        formatter.dateFormat = "yyyy년 M월 d일"
        
        let date = formatter.date(from:dateString)!
        
        return date
    }
    
    // 챌린지가 끝나는 날을 알려면 이걸 쓰면 되나??
    func isChatTomorrowWithString(dateString: String) -> Bool {
            let firebaseFormat = "yyyy년 M월 d일"
            let formatter = DateFormatter()
            formatter.dateFormat = firebaseFormat
            formatter.locale = Locale(identifier: "ko")
            formatter.timeZone = TimeZone(abbreviation: "KST")
            
            guard let tempDate1 = formatter.date(from: "2023년 1월 17일") else {
                return false
            }
            guard let tempDate2 = formatter.date(from: dateString) else {
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
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color("Background").ignoresSafeArea()
                
                VStack{
                    DatePicker(selection: $birthDate, displayedComponents: .date, label: { Text("시작날짜선택")
                        Text("\(birthDate, formatter: dateFormatter)")
                    })

                    Group{
                        Text(isChatTomorrowWithString(dateString: "2023년 1월 17일") ? "날짜 다름" : "날짜 같음")
                        Text("치킨내기 30일 챌린지!!")
                        Image(systemName: "gamecontroller")
                            .frame(width: 300, height: 300)
                        Text("지금까지 12,310원 사용")
                        
                        Text(dateCheck(startDate: "2023년 01월 12일"), style: .offset) //시작날짜~오늘날짜 계산
                            Text(Date(), style: .relative) // 지금으로부터 시간
                            Text(Date(), style: .offset) // 지금으로부터 지난 날짜
                    }
                    //MARK: - 상세 소비 내역 확인 네비게이션 링크
                    Group{
                        NavigationLink(destination: Text("상세 소비 내역 확인하기"), label: {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color("Font") , lineWidth: 1)
                                .frame(width: 330, height: 70)
                                .overlay {
                                    Text("상세 소비 내역 확인하기")
                                }
                                .padding(.bottom)
                        })
                        //MARK: - 추가하기 네비게이션 링크
                        NavigationLink(destination: Text("추가하기"), label: {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color("Font") , lineWidth: 1)
                                .frame(width: 330, height: 70)
                                .overlay {
                                    Text("추가하기")
                                }
                        })
                        
                    }
                        .font(.title3.bold())
                }.foregroundColor(Color("Font"))
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("MSG")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color("Font"))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: Text("프로필뷰")) {
                        Image(systemName: "person.circle")
                            .font(.title2)
                            .foregroundColor(Color("Font"))
                    }
                   
                }
            }
        }
    }
}

struct AfterChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        AfterChallengeView()
    }
}

//    var dateCheck: Date {
//        let formatter = DateFormatter()
//
//        let dateString = "2023년 01월 16일" //여기에다가 날짜 받으면 괜찮지 않을까??
//
//        formatter.locale = Locale(identifier: "ko_kr")
//        formatter.timeZone = TimeZone(abbreviation: "KST")
//        formatter.dateFormat = "yyyy년 mm월 d일"
//
//        let date = formatter.date(from:dateString)!
//
//        return date
//    }
