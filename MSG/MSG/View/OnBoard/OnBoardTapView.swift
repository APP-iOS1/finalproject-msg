//
//  OnBoardTapView.swift
//  MSG
//
//  Created by kimminho on 2023/01/18.
//

import SwiftUI

struct OnBoardTapView: View {
    @Binding var isFirstLaunching: Bool
    var body: some View {
        
        TabView {
            OnBoardView1()
            OnBoardView2()
            OnBoardView3()
            OnBoardView4()
            OnBoardView5(isFirstLaunching: $isFirstLaunching)
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}

//struct OnBoardTapView_Previews: PreviewProvider {
//    static var previews: some View {
//        OnBoardTapView()
//    }
//}
