//
//  AddFriendRepository.swift
//  MSG
//
//  Created by 김민호 on 2023/02/13.
//

import Foundation

protocol AddFriendRepository {
    func myInfo() async throws -> Msg?
    func addBothWithFriend(user: Msg, me: Msg)
    func deleteWaitingFriend(userId: String) async
    
    //RealTime
    func acceptAddFriend(friend: Msg)
    func sendFriendRequest(to: Msg, from: Msg)
}
