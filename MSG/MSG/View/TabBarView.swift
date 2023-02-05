//
//  TabBarView.swift
//  MSG
//
//  Created by zooey on 2023/01/31.
//

import SwiftUI

enum SelectedTab {
    case first
    case second
    case third
    case fourth
}

struct TabBarView: View {
    
    @Binding var selectedTabBar: SelectedTab
    @State var labelNumber = 1
    
    var body: some View {
        
        GeometryReader { g in
            ZStack {
                Color("Color1")
                    .ignoresSafeArea()
                HStack(spacing: 25) {
                    Button {
                        selectedTabBar = .first
                    } label: {
                        VStack {
                            Image(systemName: "dpad.fill")
                            Text("게임")
                        }
                        .frame(minWidth: g.size.width / 14.4, minHeight: g.size.height / 22)
                        .shadow(color: Color("Shadow3"), radius: 8, x: -9, y: -9)
                        .shadow(color: Color("Shadow"), radius: 8, x: 9, y: 9)
                        .padding(15)
                        .background(Color("Color1"))
                        .cornerRadius(10)
                        .shadow(color: Color("Shadow3"), radius: 8, x: -9, y: -9)
                        .shadow(color: Color("Shadow"), radius: 8, x: 9, y: 9)
                    }
                    .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.caption, color: selectedTabBar == .first ? FontCustomColor.color2 : FontCustomColor.color3))
                    
                    Button {
                        selectedTabBar = .second
                    } label: {
                        VStack {
                            Image(systemName: "archivebox")
                            Text("기록")
                        }
                        .frame(minWidth: g.size.width / 14.4, minHeight: g.size.height / 22)
                        .shadow(color: Color("Shadow3"), radius: 8, x: -9, y: -9)
                        .shadow(color: Color("Shadow"), radius: 8, x: 9, y: 9)
                        .padding(15)
                        .background(Color("Color1"))
                        .cornerRadius(10)
                        .shadow(color: Color("Shadow3"), radius: 8, x: -9, y: -9)
                        .shadow(color: Color("Shadow"), radius: 8, x: 9, y: 9)
                    }
                    .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.caption, color: selectedTabBar == .second ? FontCustomColor.color2 : FontCustomColor.color3))
                    
                    Button {
                        selectedTabBar = .third
                    } label: {
                        VStack {
                            Image(systemName: "person.2.fill")
                            Text("친구")
                        }
                        .frame(minWidth: g.size.width / 14.4, minHeight: g.size.height / 22)
                        .shadow(color: Color("Shadow3"), radius: 8, x: -9, y: -9)
                        .shadow(color: Color("Shadow"), radius: 8, x: 9, y: 9)
                        .padding(15)
                        .background(Color("Color1"))
                        .cornerRadius(10)
                        .shadow(color: Color("Shadow3"), radius: 8, x: -9, y: -9)
                        .shadow(color: Color("Shadow"), radius: 8, x: 9, y: 9)
                    }
                    .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.caption, color: selectedTabBar == .third ? FontCustomColor.color2 : FontCustomColor.color3))
                    .overlay{
                        if labelNumber != 0 {
                            NotificationNumLabel(number: $labelNumber)
                                .position(x: g.size.width / 5.8, y: g.size.height / 28)
                        }
                    }
                    
                    Button {
                        selectedTabBar = .fourth
                    } label: {
                        VStack {
                            Image(systemName: "gearshape")
                            Text("설정")
                        }
                        .frame(minWidth: g.size.width / 14.4, minHeight: g.size.height / 22)
                        .shadow(color: Color("Shadow3"), radius: 8, x: -9, y: -9)
                        .shadow(color: Color("Shadow"), radius: 8, x: 9, y: 9)
                        .padding(15)
                        .background(Color("Color1"))
                        .cornerRadius(10)
                        .shadow(color: Color("Shadow3"), radius: 8, x: -9, y: -9)
                        .shadow(color: Color("Shadow"), radius: 8, x: 9, y: 9)
                    }
                    .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.caption, color: selectedTabBar == .fourth ? FontCustomColor.color2 : FontCustomColor.color3))
                }
            }
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView(selectedTabBar: .constant(.first))
    }
}
