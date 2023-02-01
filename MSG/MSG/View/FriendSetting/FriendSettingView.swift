//
//  FriendSettingView.swift
//  MSG
//
//  Created by kimminho on 2023/01/17.
//

import SwiftUI

struct FriendSettingView: View {
    
    @EnvironmentObject var firebaseViewModel: FireStoreViewModel
    @State var selection: Int = 0
    let titles: [String] = ["친구", "친구요청", "도전장"]
    
    var body: some View {
        
        ZStack {
            Color("Color1")
                .ignoresSafeArea()
            VStack {
                SegementedControllView(selection: $selection, titles: titles, selectedItemColor: Color("Color2"), backgroundColor: Color(.clear), selectedItemFontColor: Color("Color2"))
//                    .modifier(TextViewModifier(color: "Color2"))
                
                if selection == 0 {
                    FriendView(findFriendToggle: .constant(false))
                } else if selection == 1 {
                    AlertView()
                } else {
                    GameRequestAlertView()
                }
            }
        }
    }
}

struct FriendSettingView_Previews: PreviewProvider {
    static var previews: some View {
        FriendSettingView()
    }
}

