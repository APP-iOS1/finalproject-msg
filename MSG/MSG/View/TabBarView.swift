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
    
    var body: some View {
        
        GeometryReader { g in
            ZStack {
                Color("Color1")
                    .ignoresSafeArea()
                HStack(spacing: 15) {
                    Button {
                        selectedTabBar = .first
                    } label: {
                        VStack {
                            Image(systemName: "dpad.fill")
                            Text("게임")
                        }
                        .frame(width: g.size.width / 12, height: g.size.height / 2.2)
                        .shadow(color: Color("Shadow3"), radius: 8, x: -9, y: -9)
                        .shadow(color: Color("Shadow"), radius: 8, x: 9, y: 9)
                        .padding(20)
                        .background(Color("Color1"))
                        .cornerRadius(20)
                        .shadow(color: Color("Shadow3"), radius: 8, x: -9, y: -9)
                        .shadow(color: Color("Shadow"), radius: 8, x: 9, y: 9)
                    }
                    .foregroundColor(selectedTabBar == .first ? Color("Color2") : Color(.systemGray2))
                    
                    Button {
                        selectedTabBar = .second
                    } label: {
                        VStack {
                            Image(systemName: "archivebox")
                            Text("기록")
                        }
                        .frame(width: g.size.width / 12, height: g.size.height / 2.2)
                        .shadow(color: Color("Shadow3"), radius: 8, x: -9, y: -9)
                        .shadow(color: Color("Shadow"), radius: 8, x: 9, y: 9)
                        .padding(20)
                        .background(Color("Color1"))
                        .cornerRadius(20)
                        .shadow(color: Color("Shadow3"), radius: 8, x: -9, y: -9)
                        .shadow(color: Color("Shadow"), radius: 8, x: 9, y: 9)
                    }
                    .foregroundColor(selectedTabBar == .second ? Color("Color2") : Color(.systemGray2))
                    
                    Button {
                        selectedTabBar = .third
                    } label: {
                        VStack {
                            Image(systemName: "person.2.fill")
                            Text("친구")
                        }
                        .frame(width: g.size.width / 12, height: g.size.height / 2.2)
                        .shadow(color: Color("Shadow3"), radius: 8, x: -9, y: -9)
                        .shadow(color: Color("Shadow"), radius: 8, x: 9, y: 9)
                        .padding(20)
                        .background(Color("Color1"))
                        .cornerRadius(20)
                        .shadow(color: Color("Shadow3"), radius: 8, x: -9, y: -9)
                        .shadow(color: Color("Shadow"), radius: 8, x: 9, y: 9)
                    }
                    .foregroundColor(selectedTabBar == .third ? Color("Color2") : Color(.systemGray2))
                    
                    Button {
                        selectedTabBar = .fourth
                    } label: {
                        VStack {
                            Image(systemName: "gearshape")
                            Text("설정")
                        }
                        .frame(width: g.size.width / 12, height: g.size.height / 2.2)
                        .shadow(color: Color("Shadow3"), radius: 8, x: -9, y: -9)
                        .shadow(color: Color("Shadow"), radius: 8, x: 9, y: 9)
                        .padding(20)
                        .background(Color("Color1"))
                        .cornerRadius(20)
                        .shadow(color: Color("Shadow3"), radius: 8, x: -9, y: -9)
                        .shadow(color: Color("Shadow"), radius: 8, x: 9, y: 9)
                    }
                    .foregroundColor(selectedTabBar == .fourth ? Color("Color2") : Color(.systemGray2))
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
