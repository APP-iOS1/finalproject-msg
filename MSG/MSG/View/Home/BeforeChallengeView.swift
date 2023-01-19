//
//  BeforeChallengeView.swift
//  MSG
//
//  Created by 정소희 on 2023/01/17.
//

import SwiftUI

struct BeforeChallengeView: View {

    @EnvironmentObject var firebaseViewModel: FireStoreViewModel
    @Binding var challengeState: Bool
    var frameWidth = UIScreen.main.bounds.width
    var frameHeight = UIScreen.main.bounds.height
    var body: some View {
        ZStack{ Color("Background").ignoresSafeArea()
            
            challengeGroups
            
        }
    }
}

extension BeforeChallengeView {
    
    private var challengeGroups: some View {
        VStack{
            //개인 챌랜지 시작하기
            Spacer()
                .frame(width: frameWidth / 1, height: frameHeight / 20)
            Group{
                
                HStack{
                    Text("개인 챌랜지 시작하기")
                        .fontWeight(.bold)
                        .foregroundColor(Color("Font"))
                        .padding(.bottom, -1)
                    Spacer()
                }
                .frame(width: frameWidth / 1.23)
                NavigationLink(destination: GameSettingView()){
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color("Point1"))
                        .frame(width: frameWidth / 1.21, height: frameHeight / 7)
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
                .frame(width: frameWidth / 1.23)
                
                NavigationLink(destination: GameSettingView()) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color("Point2"))
                        .frame(width: frameWidth / 1.21, height: frameHeight / 7)
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
                .frame(width: frameWidth / 1.23)
                
                NavigationLink(destination: FriendView(fireStoreViewModel: firebaseViewModel)) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color("Point1"))
                        .frame(width: frameWidth / 1.21, height: frameHeight / 7)
                        .padding(.bottom, 30)
                }
            }
            Spacer()
               
        }
    }
}

struct BeforeChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        BeforeChallengeView(challengeState: .constant(true))
    }
}
