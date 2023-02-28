//
//  ChallengeRecordRepository.swift
//  MSG
//
//  Created by zooey on 2023/02/13.
//

import Foundation

// MARK: - ChallengeRecord Repository protocol (UseCase와 Repository 사이의 매개체 역할을 담당하는 프로토콜)
protocol ChallengeRecordRepository {
    func challengeRecordfetchUserInfo(_ userId: String) async throws -> Msg?
    func getChallengeHistory() async throws -> [Challenge]
    func getUserData(user: [String], challengeId: String) async -> ChallengeUserData?
    func getChallengeUser(users: [String], challengeId: String) async -> ChallengeUserData
    func getChallengeTotalMoney(challengeId: String) async throws
    func getHistoryExpenditure(gameId: String) async -> Expenditure?
    typealias ChallengeUserData = [(user:(userName: String, userProfile: String), totalMoney: Int)]
}
