//
//  GameRequestAlertView.swift
//  MSG
//
//  Created by sehooon on 2023/01/25.
//

import SwiftUI

struct GameRequestAlertView: View {
    @EnvironmentObject private var realtimeViewModel: RealtimeViewModel
    @StateObject var gameRequestViewModel = GameRequestViewModel()
    @EnvironmentObject private var realtimeService: RealtimeService
    @Binding var selectedTabBar: SelectedTab
    var body: some View {
        
        GeometryReader { g in
            ZStack{
                Color("Color1").ignoresSafeArea()
                if realtimeService.requsetGameArr.isEmpty{
                    Text("비어있습니다.")
                        .modifier(TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.title, color: FontCustomColor.color2))
                }
                
                ScrollView{
                    Color("Color1").ignoresSafeArea()
                    
                    ForEach(realtimeService.requsetGameArr){ sendUser in
                        GameRequestAlertViewCell(selectedTabBar: $selectedTabBar, sendUser: sendUser, g: g,gameRequestViewModel:gameRequestViewModel)
                    }
                }
                .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.body, color: FontCustomColor.color2))
            }
        }
        .onAppear{
            Task {
//                await realtimeService.fetchGameRequest()
                realtimeService.fetchRequest()
            }
        }
    }
}

//struct GameRequestAlertView_Previews: PreviewProvider {
//    static var previews: some View {
//        GameRequestAlertView()
//    }
//}
