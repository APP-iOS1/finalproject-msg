//
//  ChallengeRecordUseCase.swift
//  MSG
//
//  Created by zooey on 2023/02/13.
//

import Foundation

protocol ChallengeRecordUse {
    func getChallengeHistory() async throws -> [Challenge]
    func getUserData(user: [String], challengeId: String) async -> ChallengeUserData?
    func getChallengeUser(users: [String], challengeId: String) async -> ChallengeUserData
    func getChallengeTotalMoney(challengeId: String) async throws
    func getHistoryExpenditure(gameId: String) async -> Expenditure?
    typealias ChallengeUserData = [(user:(userName: String, userProfile: String), totalMoney: Int)]
}

struct ChallengeRecordUseCase: ChallengeRecordUse {
    
    var challengeRepository: ChallengeRecordRepository
    typealias ChallengeUserData = [(user:(userName: String, userProfile: String), totalMoney: Int)]
    
    func getChallengeHistory() async throws -> [Challenge] {
        print(#function)
        do {
           let challenge = try await challengeRepository.getChallengeHistory()
            return challenge
        } catch {
            print("Error: Failed to get challenge history.")
            return []
        }
    }
    
    func getUserData(user: [String], challengeId: String) async -> ChallengeUserData? {
        print(#function)
        let challengeUserData = await challengeRepository.getUserData(user: user, challengeId: challengeId)
        return challengeUserData
    }
    
    func getChallengeUser(users: [String], challengeId: String) async -> ChallengeUserData {
        print(#function)
        let challengeUser = await challengeRepository.getChallengeUser(users: users, challengeId: challengeId)
        return challengeUser
    }
    
    func getChallengeTotalMoney(challengeId: String) async throws {
        print(#function)
        do {
            try await challengeRepository.getChallengeTotalMoney(challengeId: challengeId)
        } catch {
            print("Error: Failed to get user total amount.")
        }
    }
    
    func getHistoryExpenditure(gameId: String) async -> Expenditure? {
        print(#function)
        let challengeExpenditure = await challengeRepository.getHistoryExpenditure(gameId: gameId)
        return challengeExpenditure
    }
}

