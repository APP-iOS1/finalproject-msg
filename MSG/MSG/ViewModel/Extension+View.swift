//
//  Extension+View.swift
//  MSG
//
//  Created by zooey on 2023/02/03.
//

import SwiftUI

// 키보드가 없는 화면 눌렀을시 키보드를 내려주는 메서드
extension View {
    func endTextEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
