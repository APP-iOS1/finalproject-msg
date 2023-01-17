//
//  BeforeChallengeView.swift
//  MSG
//
//  Created by 정소희 on 2023/01/17.
//

import SwiftUI

struct BeforeChallengeView: View {
    var body: some View {
        ZStack{ Color("Background").ignoresSafeArea()
            
            challengeGroups
            
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

extension BeforeChallengeView {
    
    private var challengeGroups: some View {
        VStack{
            //개인 챌랜지 시작하기
            Group{
                HStack{
                    Text("개인 챌랜지 시작하기")
                        .fontWeight(.bold)
                        .foregroundColor(Color("Font"))
                        .padding(.bottom, -1)
                    Spacer()
                }
                .frame(width: 330)
                NavigationLink(destination: Text("게임셋팅뷰")) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color("Point1"))
                        .frame(width: 330, height: 120)
                        .padding(.bottom, 30)
                }
            }
            //함께하는 챌랜지 시작하기
            Group{
                HStack{
                    Text("함께하는 챌랜지 시작하기")
                        .foregroundColor(Color("Font"))
                        .padding(.bottom, -1)
                        .fontWeight(.bold)
                    Spacer()
                }
                .frame(width: 330)
                
                NavigationLink(destination: Text("게임셋팅뷰")) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color("Point2"))
                        .frame(width: 330, height: 120)
                        .padding(.bottom, 30)
                }
            }
            //함께 챌린지 할 친구 초대하기
            Group{
                HStack{
                    Text("함께 챌린지 할 친구 초대하기")
                        .foregroundColor(Color("Font"))
                        .padding(.bottom, -1)
                        .fontWeight(.bold)
                    Spacer()
                }
                .frame(width: 330)
                
                NavigationLink(destination: Text("친구초대")) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color("Point1"))
                        .frame(width: 330, height: 120)
                        .padding(.bottom, 30)
                }
            }
        }
    }
}

struct BeforeChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        BeforeChallengeView()
    }
}
