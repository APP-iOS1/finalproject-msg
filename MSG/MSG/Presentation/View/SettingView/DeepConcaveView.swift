//
//  DeepConcaveView.swift
//  MSG
//
//  Created by zooey on 2023/02/04.
//

import SwiftUI

struct DeepConcaveView: View {
    
    let cornerRadius : CGFloat
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Color("Color1"))
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(Color("Shadow"), lineWidth: 2)
                .blur(radius: 0.5)
                .offset(x: 1, y: 1)
                .mask(RoundedRectangle(cornerRadius: cornerRadius).fill(LinearGradient(colors:[Color("Shadow"), Color.clear], startPoint: .top, endPoint: .bottom)))
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(Color("Shadow"), lineWidth: 6)
                .blur(radius: 3)
                .offset(x: 3, y: 3)
                .mask(RoundedRectangle(cornerRadius: cornerRadius).fill(LinearGradient(colors: [Color("Shadow"), Color.clear], startPoint: .top, endPoint: .bottom)))
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(Color("Shadow3"), lineWidth: 2)
                .blur(radius: 0.5)
                .offset(x: -1, y: -1)
                .mask(RoundedRectangle(cornerRadius: cornerRadius).fill(LinearGradient(colors: [Color.clear, Color("Shadow3")], startPoint: .top, endPoint: .bottom)))
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(Color("Shadow3"), lineWidth: 6)
                .blur(radius: 3)
                .offset(x: -3, y: -3)
                .mask(RoundedRectangle(cornerRadius: cornerRadius).fill(LinearGradient(colors: [Color.clear, Color("Shadow3")], startPoint: .top, endPoint: .bottom)))
        }
    }
}

struct DeepConcaveView_Previews: PreviewProvider {
    static var previews: some View {
        DeepConcaveView(cornerRadius: 10)
    }
}
