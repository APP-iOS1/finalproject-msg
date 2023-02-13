//
//  ChallengeRecordRepositoryImpl.swift
//  MSG
//
//  Created by zooey on 2023/02/13.
//

import Foundation

struct ChallengeRecordRepositoryImpl: ChallengeRecordRepository {
    var dataSource: ChallengeRecordDataSource
    typealias ChallengeUserData = [(user:(userName: String, userProfile: String), totalMoney: Int)]
    
    func getChallengeHistory() async throws -> [Challenge] {
        print(#function)
        do {
           let data = try await dataSource.fetchPreviousGameHistory()
            return data
        } catch {
            print("Error: Failed to get challenge history.")
            return []
        }
    }
    
    func getUserData(user: [String], challengeId: String) async -> ChallengeUserData? {
        print(#function)
        let data = await dataSource.fetchChallengeUsersData(user, challengeId)
        return data
    }
    
    func getChallengeUser(users: [String], challengeId: String) async -> ChallengeUserData {
        print(#function)
       let data = await dataSource.fetchChallengeUsers(users, challengeId)
        return data
    }
    
    func getChallengeTotalMoney(challengeId: String) async throws {
        print(#function)
        do {
            try await dataSource.fetchChallengeTotalMoney(challengeId)
        } catch {
            print("Error: Failed to get user total amount.")
        }
    }
    
    func getHistoryExpenditure(gameId: String) async -> Expenditure? {
        let data = await dataSource.fetchHistoryExpenditure(gameId)
        return data
    }
}
