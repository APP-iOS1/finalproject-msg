//
//  BeforeChallengeView.swift
//  MSG
//
//  Created by 정소희 on 2023/01/17.
//

import SwiftUI

struct BeforeChallengeView: View {

    @EnvironmentObject var firebaseViewModel: FireStoreViewModel
 
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
                    Text("개인 챌린지 시작하기")
                        .fontWeight(.bold)
                        .foregroundColor(Color("Font"))
                        .padding(.bottom, -1)
                    Spacer()
                }
                .frame(width: frameWidth / 1.23)
                NavigationLink(destination: SoloGameSettingView()){
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color("Point1"))
                        .frame(width: frameWidth / 1.21, height: frameHeight / 7)
                        .overlay {
                            HStack{
                                Image(systemName: "rosette")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(Color("Point2"))
                                    .frame(width: frameWidth / 13, height: frameHeight / 13)
                                    .padding(.trailing, 5)
                                VStack(alignment: .leading){
                                    Text("꼭 필요한 습관").font(.title3).bold()
                                    Text("꾸준한 습관으로 커다란 결과를!")
                                } .foregroundColor(Color("Font2"))
                            }
                        }
                        
                }.padding(.bottom, 30)
                
                
            }
            //함께하는 챌랜지 시작하기
            Group{
                HStack{
                    Text("함께하는 챌린지 시작하기")
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
                        .overlay {
                            HStack{
                                Image(systemName: "chart.xyaxis.line")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(Color("Point1"))
                                    .frame(width: frameWidth / 13, height: frameHeight / 13)
                                    .padding(.trailing, 5)
                                VStack(alignment: .leading){
                                    Text("함께하는 성장").font(.title3).bold()
                                    Text("목표를 정하고, 서로 체크해요!")
                                } .foregroundColor(Color("Font2"))
                            }
                        }
                        
                        .padding(.bottom, 30)
                }
            }

            Spacer()
                .frame(width: frameWidth / 1, height: frameHeight / 7)
               
        }
    }
}

struct BeforeChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        BeforeChallengeView()
    }
}
