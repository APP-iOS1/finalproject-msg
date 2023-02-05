//
//  NotificationNumLabel.swift
//  MSG
//
//  Created by zooey on 2023/02/05.
//

import SwiftUI

struct NotificationNumLabel: View {
    
    @Binding var number : Int
    
    var body: some View {
        
        GeometryReader { g in
            ZStack {
                Capsule()
                    .fill(Color("Color2"))
                    .frame(width: g.size.width / 4 * CGFloat(numOfDigits()), height: g.size.height / 3)
//                    .position(CGPoint(x: g.size.width / 2.6, y: 0))
                Text("\(number)")
                    .foregroundColor(Color.white)
                    .modifier(TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.caption, color: FontCustomColor.color2))
//                    .position(CGPoint(x: g.size.width / 2.6, y: 0))
            }
        }
    }
    func numOfDigits() -> Float {
        let numOfDigits = Float(String(number).count)
        return numOfDigits == 1 ? 1.5 : numOfDigits
    }
}

struct NotificationNumLabel_Previews: PreviewProvider {
    static var previews: some View {
//        NotificationNumLabel(number: .constant(2))
        TabBarView(selectedTabBar: .constant(.first))
    }
}
