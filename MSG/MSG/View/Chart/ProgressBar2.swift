//
//  ProgressBar2.swift
//  MSG
//
//  Created by kimminho on 2023/02/03.
//

import SwiftUI

struct ProgressBar2: View {
    @Binding var value: Float
    @State var percent: CGFloat = 40.0
    
    var body: some View {
        GeometryReader { geometry in
            let multiplier = geometry.size.width / 100
            VStack(alignment: .leading) {
                Image(systemName: "person")
                    .padding(.leading,multiplier * percent)
                ZStack(alignment: .leading) {
                    Rectangle().frame(width: geometry.size.width , height: geometry.size.height)
                        .opacity(0.3)
                        .foregroundColor(Color(UIColor.systemTeal))
                    
                    
                    //MARK: %가 100이 넘으면 뚫고 나가지 않게 방지
                    if percent >= 100 {
                        Rectangle().frame(width: geometry.size.width, height: geometry.size.height)
                            .opacity(0.3)
                            .foregroundColor(Color(UIColor.systemBlue))
                    }else {
                        Rectangle().frame(width: multiplier * percent, height: geometry.size.height)
                            .opacity(0.3)
                            .foregroundColor(Color(UIColor.systemBlue))
                    }
//                    Image(systemName: "person")
//                        .frame(width: multiplier * (percent) * 2)
                }.cornerRadius(45.0)
                
            }

        }
    }
}

struct ProgressBar2_Previews: PreviewProvider {
    static var previews: some View {
//        ProgressBar2(value: .constant(1.0))
        ChallengeProgressView()
    }
}
