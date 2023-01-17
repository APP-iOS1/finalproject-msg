//
//  FriendView.swift
//  MSG
//
//  Created by kimminho on 2023/01/17.
//

import SwiftUI

struct FriendView: View {
    @State private var text: String = ""
    @State private var testArray: [String] = ["김민호","김철수","김뽀삐"]
    var filterUser: [String] {
        if text.isEmpty {
            //검색을 하지 않았다면 친구목록을 보여주어야 함
            return testArray
        } else {
            return testArray.filter {$0.localizedStandardContains(text)}
        }
    }
    var body: some View {
        NavigationView {
            List(filterUser,id:\.self) {name in
                FriendViewCell(user: name)
                    .frame(height: 50)
                    .listRowSeparator(.hidden)
            }
            .searchable(text: $text,
                         placement: .navigationBarDrawer,
                         prompt: "친구를 검색해보세요")
        }
    }
}

struct FriendView_Previews: PreviewProvider {
    static var previews: some View {
        FriendSettingView()
    }
}
