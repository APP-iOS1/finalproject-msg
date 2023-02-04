//
//  CustomToggle.swift
//  MSG
//
//  Created by zooey on 2023/02/04.
//

import SwiftUI

struct CustomToggle: View {
    
    let width : CGFloat
    let height : CGFloat
    let toggleWidthOffset : CGFloat
    let cornerRadius : CGFloat
    let padding : CGFloat
    
    @State var isToggled = false
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
                if isToggled {
                    Spacer()
                }
                
                RoundedRectangle(cornerRadius: cornerRadius)
                    .padding(padding)
                    .frame(width: switchWidth + toggleWidthOffset, height: height)
                    .animation(.spring(response: 0.5), value: isToggled)
                    .foregroundColor(Color("Color1"))
                    .shadow(color: Color("Shadow"), radius: 2, x: -3, y: -3)
                    .shadow(color: Color("Shadow2"), radius: 3, x: 3, y: 3)
                
                
                if !isToggled {
                    Spacer()
                }
            }
            
        }
        .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.caption2, color: FontCustomColor.color2))
        .frame(width: width, height: height)
        .onTapGesture {
            isToggled = !isToggled
            withAnimation(.easeInOut(duration: 0.2)) {
                switchWidth = width
            }
            withAnimation(.easeInOut(duration: 0.4)) {
                switchWidth = height
            }
            darkModeEnabled = isToggled
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
        CustomToggle(width: 20, height: 10, toggleWidthOffset: 10, cornerRadius: 10, padding: 10, darkModeEnabled: .constant(true))
    }
}
