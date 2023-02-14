//
//  FriendSettingView.swift
//  MSG
//
//  Created by kimminho on 2023/01/17.
//

import SwiftUI

struct FriendSettingView: View {
    @Binding var selectedTabBar: SelectedTab
    @EnvironmentObject var firebaseViewModel: FireStoreViewModel
    @State var selection: Int = 0
    let titles: [String] = ["친구", "친구요청", "도전장"]
    
    @Binding var friendCount: Int
    @Binding var requsetCount: Int
    func numOfDigits() -> Float {
        let numOfDigits = Float(String(friendCount + requsetCount).count)
        return numOfDigits == 1 ? 1.5 : numOfDigits
    }
    
    var body: some View {
        
        GeometryReader { g in
            ZStack {
                Color("Color1")
                    .ignoresSafeArea()
                VStack {
                    SegementedControllView(selection: $selection, titles: titles, selectedItemColor: Color("Color2"), backgroundColor: Color(.clear), selectedItemFontColor: Color("Color2"))
                    
                    if selection == 0 {
                        DivideFriendView()
                    } else if selection == 1 {
                        AlertView()
                    } else {
                        GameRequestAlertView(selectedTabBar: $selectedTabBar)
                    }
                }
                .overlay{
                    if friendCount != 0 {
                        ZStack {
                            Capsule()
                                .fill(.red)
                                .frame(width: g.size.width / 30 * CGFloat(numOfDigits()), height: g.size.height / 35)
                                .position(CGPoint(x: g.size.width / 1.65, y: g.size.height / 30))
                            Text("\(friendCount)")
                                .foregroundColor(Color.white)
                                .modifier(TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.caption2, color: FontCustomColor.color2))
                                .position(CGPoint(x: g.size.width / 1.65, y: g.size.height / 30))
                        }
                    }
                }
                .overlay{
                    if requsetCount != 0 {
                        ZStack {
                            Capsule()
                                .fill(.red)
                                .frame(width: g.size.width / 30 * CGFloat(numOfDigits()), height: g.size.height / 35)
                                .position(CGPoint(x: g.size.width / 1.11, y: g.size.height / 30))
                            Text("\(requsetCount)")
                                .foregroundColor(Color.white)
                                .modifier(TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.caption2, color: FontCustomColor.color2))
                                .position(CGPoint(x: g.size.width / 1.11, y: g.size.height / 30))
                        }
                    }
                }
            }
        }
    }
}

struct FriendSettingView_Previews: PreviewProvider {
    static var previews: some View {
        FriendSettingView(selectedTabBar: .constant(.third), friendCount: .constant(1), requsetCount: .constant(1))
    }
}

