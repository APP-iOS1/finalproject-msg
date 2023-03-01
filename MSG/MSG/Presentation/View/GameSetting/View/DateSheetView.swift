//
//  DateSheetView.swift
//  MSG
//
//  Created by sehooon on 2023/02/14.
//

import SwiftUI

struct DateSheetView: View{
    @ObservedObject var gameSettingViewModel: GameSettingViewModel
    @State var parentScreen: GeometryProxy
    var body: some View{
            ZStack {
                Color("Color1").ignoresSafeArea()
                VStack {
                    Spacer()
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(gameSettingViewModel.dayArray.indices, id: \.self) { index in
                                Button {
                                    gameSettingViewModel.selectChallengeDay(index)
                                } label: {
                                    Text("\(gameSettingViewModel.dayArray[index])")
                                        .frame(width: parentScreen.size.width / 7, height: parentScreen.size.height / 20)
                                        .shadow(color: Color("Shadow3"), radius: 6, x: -7, y: -7)
                                        .shadow(color: Color("Shadow"), radius: 6, x: 7, y: 7)
                                        .padding(8)
                                        .background(Color("Color1"))
                                        .cornerRadius(10)
                                        .shadow(color: Color("Shadow3"), radius: 6, x: -7, y: -7)
                                        .shadow(color: Color("Shadow"), radius: 6, x: 7, y: 7)
                                        .foregroundColor( gameSettingViewModel.daySelection == index ? Color("Color2") : Color("Color3"))
                                }
                                .frame(width: parentScreen.size.width / 4.3, height: parentScreen.size.height / 15)
                            }
                            .frame(maxHeight: .infinity)
                        }
                    }
                    Spacer()
                    Divider()
                    Button {
                        gameSettingViewModel.showingDaySelection.toggle()
                    } label: {
                        Text("닫기")
                            .modifier(TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.title3, color: FontCustomColor.color2))
                    }
                    
                } // VStack
       
            }

    }
    
}
