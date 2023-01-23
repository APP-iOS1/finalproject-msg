//
//  SingleGameProgressBar.swift
//  MSG
//
//  Created by zooey on 2023/01/23.
//

import SwiftUI

struct SingleGameProgressBar: View {
    
    var body: some View {
            ZStack {
                Circle()
                    .stroke(lineWidth: 30)
                    .opacity(0.3)
                Circle()
                    .trim(from: 0.0, to: 0.3)
                    .stroke(style: StrokeStyle(lineWidth: 30.0, lineCap: .round, lineJoin: .round))
                    .foregroundColor(Color("Point2"))
                    .rotationEffect(Angle(degrees: 270.0))
                    .animation(.linear)
            }
            .frame(width: UIScreen.main.bounds.width / 1.6)
    }
}

struct GameProgressBarView_Previews: PreviewProvider {
    static var previews: some View {
        SingleGameProgressBar()
    }
}
