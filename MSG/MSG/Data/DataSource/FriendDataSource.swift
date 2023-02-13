//
//  FriendDataSource.swift
//  MSG
//
//  Created by kimminho on 2023/02/12.
//
import Combine
import Foundation
import FirebaseFirestore

//MARK: Firebase Service
// 어떤 데이터를 받을 것인가에 대한 정의
protocol FriendDataSource {
    func findSearchUser(text: String) -> [Msg]
    func findUser1(text: [Msg]) async -> [Msg]
    func findFriend() async throws -> ([Msg],[String])
    func searchUser(text: String) -> [Msg]
    var database: Firestore { get }
}
