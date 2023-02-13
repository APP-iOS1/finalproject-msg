//
//  DarkModeToggle.swift
//  MSG
//
//  Created by zooey on 2023/02/04.
//

import SwiftUI

struct DarkModeToggle: View {
    
    let width : CGFloat
    let height : CGFloat
    let toggleWidthOffset : CGFloat
    let cornerRadius : CGFloat
    let padding : CGFloat
    
    @State var switchWidth : CGFloat = 0.0
    @Binding var darkModeEnabled: Bool
    
    var body: some View {
        ZStack {
            
            DeepConcaveView(cornerRadius: cornerRadius)
                .frame(width: width, height: height)
            
            HStack {
                Text("켜짐")
                //                    .bold()
                    .foregroundColor(.green)
                
                Spacer()
                
                Text("꺼짐")
                //                    .bold()
                    .foregroundColor(.red)
                
            }
            .padding()
            .frame(width: width, height: height)
            
            HStack {
                if darkModeEnabled {
                    Spacer()
                }
                
                RoundedRectangle(cornerRadius: cornerRadius)
                    .padding(padding)
                    .frame(width: switchWidth + toggleWidthOffset, height: height)
                    .animation(.spring(response: 0.5), value: darkModeEnabled)
                    .foregroundColor(Color("Color1"))
                    .shadow(color: Color("Shadow"), radius: 2, x: -3, y: -3)
                    .shadow(color: Color("Shadow2"), radius: 3, x: 3, y: 3)
                
                
                if !darkModeEnabled {
                    Spacer()
                }
            }
            
        }
        .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.caption2, color: FontCustomColor.color2))
        .frame(width: width, height: height)
        .onTapGesture {
            darkModeEnabled = !darkModeEnabled
            withAnimation(.easeInOut(duration: 0.2)) {
                switchWidth = width
            }
            withAnimation(.easeInOut(duration: 0.4)) {
                switchWidth = height
            }
        }
        .onAppear {
            switchWidth = height
        }
        .onChange(of: darkModeEnabled) { _ in
            SystemThemeManager
                .shared
                .handleTheme(darkMode: darkModeEnabled)
        }
    }
}

struct CustomToggle_Previews: PreviewProvider {
    static var previews: some View {
        DarkModeToggle(width: 20, height: 30, toggleWidthOffset: 10, cornerRadius: 10, padding: 10, darkModeEnabled: .constant(true))
    }
}
