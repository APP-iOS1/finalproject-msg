//
//  GameRequestAlertView.swift
//  MSG
//
//  Created by sehooon on 2023/01/25.
//

import SwiftUI

struct GameRequestAlertView: View {
    @EnvironmentObject private var realtimeViewModel: RealtimeViewModel
    var body: some View {
        
        GeometryReader { g in
            ZStack{
                Color("Color1").ignoresSafeArea()
                if realtimeViewModel.requsetGameArr.isEmpty{
                    Text("비어있습니다.")
                        .modifier(TextTitleBold())
                }
                
                ScrollView{
                    Color("Color1").ignoresSafeArea()
                    
                    ForEach(realtimeViewModel.requsetGameArr){ sendUser in
                        GameRequestAlertViewCell(sendUser: sendUser, g: g)
                    }
                }
                .modifier(TextViewModifier(color: "Font"))
            }
        }
        .onAppear{
            Task {
                await realtimeViewModel.fetchGameRequest()
            }
        }
    }
}

struct GameRequestAlertView_Previews: PreviewProvider {
    static var previews: some View {
        GameRequestAlertView()
    }
}
