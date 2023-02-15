//
//  FriendUseCase.swift
//  MSG
//
//  Created by kimminho on 2023/02/12.
//
import Combine
import Foundation

//MARK: - Usecase protocol
protocol GetTodos {
    func findSearchUser(text: String) -> [Msg] // 유저검색(1)
    func fetchFriendList() async throws -> ([Msg],[String]) // 친구 목록 가져오기
    func caseNotGameMyFriend(text: [Msg]) async throws -> [Msg] // 게임을 안하고있는 친구목록 가져오기
    
    
    //func findUser1    //
    //func findFriend
    //func searchUser
}


//MARK: - UseCase
struct FriendUseCase: GetTodos {
    
    
    var repo: FriendRepository
    
    func fetchFriendList() async -> ([Msg],[String]){
        print(#function)
        do {
            let friend = try await repo.getFriend()
            return friend
        }catch {
            return ([],[])
        }
    }
    func caseNotGameMyFriend(text: [Msg]) async throws -> [Msg] {
        print(#function)
        let notGameFriend = try await repo.notGameMyFriend(text: text)
        return notGameFriend
    }
    
    func findSearchUser(text: String) -> [Msg] {
        let searchUser = repo.findSearchUser(text: text)
        return searchUser
    }
    
}
