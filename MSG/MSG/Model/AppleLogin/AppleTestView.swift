//
//  AppleTestView.swift
//  MSG
//
//  Created by 전준수 on 2023/01/18.
//

import SwiftUI

struct AppleTestView: View {
    var body: some View {
        ZStack {
            Color.green
                .ignoresSafeArea()
            Text("애플로그인 성공")
        }
    }
}

struct AppleTestView_Previews: PreviewProvider {
    static var previews: some View {
        AppleTestView()
    }
}
