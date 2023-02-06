//
//  NotificationToggle.swift
//  MSG
//
//  Created by zooey on 2023/02/05.
//

import SwiftUI

struct NotificationToggle: View {
    
    let width : CGFloat
    let height : CGFloat
    let toggleWidthOffset : CGFloat
    let cornerRadius : CGFloat
    let padding : CGFloat
    
    @State var switchWidth : CGFloat = 0.0
    @Binding var notificationEnabled: Bool
    
    @EnvironmentObject var notiManager: NotificationManager
    
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
                if notificationEnabled {
                    Spacer()
                }
                
                RoundedRectangle(cornerRadius: cornerRadius)
                    .padding(padding)
                    .frame(width: switchWidth + toggleWidthOffset, height: height)
                    .animation(.spring(response: 0.5), value: notificationEnabled)
                    .foregroundColor(Color("Color1"))
                    .shadow(color: Color("Shadow"), radius: 2, x: -3, y: -3)
                    .shadow(color: Color("Shadow2"), radius: 3, x: 3, y: 3)
                
                
                if !notificationEnabled {
                    Spacer()
                }
            }
            
        }
        .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.caption2, color: FontCustomColor.color2))
        .frame(width: width, height: height)
        .onTapGesture {
            notificationEnabled = !notificationEnabled
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
        .onChange(of: notificationEnabled) { _ in
            notiManager.openSetting()
        }
    }
}

struct NotificationToggle_Previews: PreviewProvider {
    static var previews: some View {
        NotificationToggle(width: 1, height: 1, toggleWidthOffset: 1, cornerRadius: 1, padding: 1, notificationEnabled: .constant(true))
    }
}
