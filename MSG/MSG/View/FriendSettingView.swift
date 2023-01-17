//
//  FriendSettingView.swift
//  MSG
//
//  Created by kimminho on 2023/01/17.
//

import SwiftUI

struct FriendSettingView: View {
    @State private var pickerCase: PickerCase = .alert
    
    enum PickerCase: String,Identifiable, CaseIterable {
        case friend
        case alert
        var id: String { self.rawValue }
    }
    var body: some View {
        VStack {
            Picker("gender",selection: $pickerCase) {
                ForEach(PickerCase.allCases) {myCase in
                    Text(myCase.rawValue.capitalized).tag(myCase)
                }
            }
            .pickerStyle(SegmentedPickerStyle())

            switch pickerCase {
            case .friend:
                FriendView()
            case .alert:
                AlertView()
            }
        }.frame(minWidth: 100, maxWidth: .infinity, minHeight: 100, maxHeight: .infinity)
    }
}

struct FriendSettingView_Previews: PreviewProvider {
    static var previews: some View {
        FriendSettingView()
    }
}
