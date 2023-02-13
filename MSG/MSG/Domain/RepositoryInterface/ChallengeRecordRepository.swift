//
//  ChallengeRecordRepository.swift
//  MSG
//
//  Created by zooey on 2023/02/13.
//

import Foundation

protocol ChallengeRecordRepository {
    func getChallengeHistory() async throws -> [Challenge]
    func getUserData(user: [String], challengeId: String) async -> ChallengeUserData?
    func getChallengeUser(users: [String], challengeId: String) async -> ChallengeUserData
    func getChallengeTotalMoney(challengeId: String) async throws
    func getHistoryExpenditure(gameId: String) async -> Expenditure?
    typealias ChallengeUserData = [(user:(userName: String, userProfile: String), totalMoney: Int)]
}
