//
//  GameRequestAlertView.swift
//  MSG
//
//  Created by sehooon on 2023/01/25.
//

import SwiftUI

struct GameRequestAlertView: View {
    @EnvironmentObject private var realtimeViewModel: RealtimeViewModel
    @Binding var selectedTabBar: SelectedTab
    var body: some View {
        
        GeometryReader { g in
            ZStack{
                Color("Color1").ignoresSafeArea()
                if realtimeViewModel.requsetGameArr.isEmpty{
                    Text("비어있습니다.")
                        .modifier(TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.title, color: FontCustomColor.color2))
                }
                
                ScrollView{
                    Color("Color1").ignoresSafeArea()
                    
                    ForEach(realtimeViewModel.requsetGameArr){ sendUser in
                        GameRequestAlertViewCell(selectedTabBar: $selectedTabBar, sendUser: sendUser, g: g)
                    }
                }
                .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.body, color: FontCustomColor.color2))
            }
        }
        .onAppear{
            Task {
                await realtimeViewModel.fetchGameRequest()
            }
        }
    }
}

//struct GameRequestAlertView_Previews: PreviewProvider {
//    static var previews: some View {
//        GameRequestAlertView()
//    }
//}
