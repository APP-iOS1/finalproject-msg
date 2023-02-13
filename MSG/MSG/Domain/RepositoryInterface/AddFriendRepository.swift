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
    func acceptAddFriend(friend: Msg)
}
