//
//  FriendRepository.swift
//  MSG
//
//  Created by kimminho on 2023/02/12.
//
import Foundation

//MARK: - Repository protocol
//UseCase와 Repository 사이의 매개체 역할을 담당하는 프로토콜
protocol FriendRepository {
    func findSearchUser(text: String) -> [Msg]
    func getFriend() async throws -> ([Msg],[String])
    func notGameMyFriend(text: [Msg]) async throws -> [Msg]
    func searchUserInText(text: String) -> [Msg]
}

protocol DivideFriendRepository {
    func makeProfile(_ userIdArray:[String]) async -> [Msg]?
    func fetchUserInfo(_ userId: String) async throws -> Msg?
    func findUser(text: String) async throws -> [String]
    func uploadSendToFriend(_ userId: String, sendToFriendArray: [String])
}

