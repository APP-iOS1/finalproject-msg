//
//  BeforeChallengeView.swift
//  MSG
//
//  Created by 정소희 on 2023/01/17.
//

import SwiftUI

struct BeforeChallengeView: View {

    @EnvironmentObject var firebaseViewModel: FireStoreViewModel
    
    var body: some View {
        
        ZStack{ Color("Color1").ignoresSafeArea()
            
            challengeGroups
            
        }
    }
}

extension BeforeChallengeView {
    
    private var challengeGroups: some View {
        
        GeometryReader { g in
            VStack{
                //개인 챌랜지 시작하기
                
                Spacer()
                    .frame(width: g.size.width, height: g.size.height / 6)
                Group{
                    HStack{
                        Text("개인 챌린지 시작하기")
                            .modifier(TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.title, color: FontCustomColor.color2))
                            .padding(.bottom, -1)
                        Spacer()
                    }
                    .frame(width: g.size.width / 1.23)
                    NavigationLink(destination: SoloGameSettingView()){
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color("Color1"),
                                        lineWidth: 4)
                                .shadow(color: Color("Shadow"),
                                        radius: 3, x: 5, y: 5)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 15))
                                .shadow(color: Color("Shadow3"), radius: 2, x: -2, y: -2)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 15))
                                .background(Color("Color1"))
                                .cornerRadius(20)
                                .frame(width: g.size.width / 1.1, height: g.size.height / 5)
                            HStack{
                                Image(systemName: "rosette")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: g.size.width / 13, height: g.size.height / 13)
                                    .padding()
                                    .padding(.trailing, 15)
                                VStack(alignment: .leading){
                                    Text("꼭 필요한 습관")
                                        .modifier(TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.title2, color: FontCustomColor.color2))
                                    Text("꾸준한 습관으로 커다란 결과를!")
                                        .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.body, color: FontCustomColor.color2))
                                }
                            }
                        }
                    }
                    .padding(.bottom, 30)
                }
                //함께하는 챌랜지 시작하기
                Group{
                    HStack{
                        Text("함께하는 챌린지 시작하기")
                            .modifier(TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.title, color: FontCustomColor.color2))
                            .padding(.bottom, -1)
                            
                        Spacer()
                    }
                    .frame(width: g.size.width / 1.23)
                    
                    NavigationLink(destination: GameSettingView()) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color("Color1"),
                                        lineWidth: 4)
                                .shadow(color: Color("Shadow"),
                                        radius: 3, x: 5, y: 5)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 15))
                                .shadow(color: Color("Shadow3"), radius: 2, x: -2, y: -2)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 15))
                                .background(Color("Color1"))
                                .cornerRadius(20)
                                .frame(width: g.size.width / 1.1, height: g.size.height / 5)
                            HStack{
                                Image(systemName: "chart.xyaxis.line")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: g.size.width / 13, height: g.size.height / 13)
                                    .padding()
                                    .padding(.trailing, 15)
                                VStack(alignment: .leading){
                                    Text("함께하는 성장")
                                        .modifier(TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.title2, color: FontCustomColor.color2))
                                    Text("목표를 정하고, 서로 체크해요!!")
                                        .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.body, color: FontCustomColor.color2))
                                }
                            }
                        }
                        .padding(.bottom, 30)
                    }
                }
                Spacer()
                    .frame(width: g.size.width, height: g.size.height / 7)
            }
        }
        .onAppear{
            firebaseViewModel.findFriend()
        }
    }
}

struct BeforeChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        BeforeChallengeView()
    }
}
