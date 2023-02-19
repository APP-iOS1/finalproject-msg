//
//  ChallengeViewRepositoryImpl.swift
//  MSG
//
//  Created by 정소희 on 2023/02/15.
//

import Foundation

struct ChallengeViewRepositoryImpl: ChallengeViewRepository {

    let firestoreService: ChallengeViewDataSource
    
    func findUser(inviteId: [String], waitingId: [String]) async -> ([Msg],[Msg]) {
        let data = await firestoreService.findUser(inviteId: inviteId, waitingId: waitingId)
        return data
    }
    
    func fetchGame() async {
       await firestoreService.fetchGame()
    }
    
    func fetchGameReturn() async -> Challenge? {
        if let data = await firestoreService.fetchGameReturn() {
            return data
        }
        return nil
    }
    
    func challengefetchUserInfo(_ userId: String) async throws -> Msg? {
        let data = try await firestoreService.challengefetchUserInfo(userId)
        return data
    }
    
    func addGameHistory() async {
        await firestoreService.addGameHistory()
    }
    
    func giveUpMultiGame() async {
        await firestoreService.giveUpMultiGame()
    }
    
    func deleteSingleGame() async {
        await firestoreService.deleteSingleGame()
    }
    
    func fetchExpenditure() async -> Expenditure?{
        let data = await firestoreService.fetchExpenditure()
        return data
    }
    
    func parsingExpenditure(expenditure: [String : [String]]) {
        firestoreService.parsingExpenditure(expenditure: expenditure)
    }
    
    func findFriend() {
        firestoreService.findFriend()
    }
    
    
   
    
    
}
