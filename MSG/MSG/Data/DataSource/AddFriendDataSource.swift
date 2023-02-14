//
//  AddFriendDataSource.swift
//  MSG
//
//  Created by 김민호 on 2023/02/13.
//

import Foundation


//MARK: Firebase
protocol AddFriendDataSource {
    func myInfo() async throws -> Msg?
    func addBothWithFriend(user: Msg, me: Msg)
    func deleteWaitingFriend(userId: String) async
}
//MARK: Realtime
protocol AddFriendDataSourceWithRealTimeDB {
    func acceptAddFriend(friend: Msg) //친구요청을 수락합니다
    func sendFriendRequest(to: Msg, from: Msg) //친구요청을 보냅니다
}
