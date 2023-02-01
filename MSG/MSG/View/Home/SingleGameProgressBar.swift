//
//  SingleGameProgressBar.swift
//  MSG
//
//  Created by zooey on 2023/01/23.
//

import SwiftUI

struct SingleGameProgressBar: View {
    
    @EnvironmentObject var fireStoreViewModel: FireStoreViewModel
    @EnvironmentObject var loginViewModel: LoginViewModel
    @Binding var percentage: Int
    let limitMoney: Int

    var body: some View {
        
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 30)
            Circle()
                .trim(from: 0.0, to: Double(percentage) / Double(limitMoney))
                .stroke(style: StrokeStyle(lineWidth: 30.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color("Color2"))
                .rotationEffect(Angle(degrees: 270.0))
             
            //                    .animation(.linear)
            VStack {
                Text(loginViewModel.currentUserProfile!.nickName)
//                Text("\(Double(percentage) / Double(limitMoney))%")
                Text("\(String(format:"%.1f",Double(percentage) / Double(limitMoney) * 100))%")
            }
            .modifier(TextViewModifier(color: "Color2"))
        }
        .frame(width: UIScreen.main.bounds.width / 1.6)
        .onAppear {
            Task {
                await fireStoreViewModel.fetchExpenditure()
                print("percengate:\(self.percentage), limitMoney:\(self.limitMoney)")
            }
        }
    }
}

struct GameProgressBarView_Previews: PreviewProvider {
    static var previews: some View {
        SingleGameProgressBar(percentage: .constant(Int(0.3)), limitMoney: 0)
    }
}
