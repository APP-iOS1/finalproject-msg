//
//  AfterChallengeView.swift
//  MSG
//
//  Created by 정소희 on 2023/01/17.
//

import SwiftUI

struct AfterChallengeView: View {
    var body: some View {
        NavigationStack{
            ZStack{
                Color("Background").ignoresSafeArea()
                
                VStack{
                    
                    Group{
                        Text("치킨내기 30일 챌린지!!")
                        Image(systemName: "gamecontroller")
                            .frame(width: 300, height: 300)
                        Text("05:21:29")
                        Text("지금까지 12,310원 사용")
                    }
                    
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
