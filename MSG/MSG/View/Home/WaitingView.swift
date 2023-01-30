//
//  WaitingView.swift
//  MSG
//
//  Created by kimminho on 2023/01/30.
//

import SwiftUI

struct WaitingView: View {
    @State var waitingFriend: [String]
    @State var allowFriend: [String]
    var body: some View {

            VStack {
                Text("초대 수락한 친구")
                List(allowFriend, id:\.self) {friend in
                    Text(friend)
                }
                Divider()
                Text("대기중인 친구")
                List(waitingFriend, id:\.self) {friend in
                    Text(friend)
                }
            }
        
    }
}

struct WaitingView_Previews: PreviewProvider {
    static var previews: some View {
        WaitingView(waitingFriend: ["철수","영희"], allowFriend: ["뽀로로"])
    }
}
