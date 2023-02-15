//
//  ChallengeRecordDataSource.swift
//  MSG
//
//  Created by zooey on 2023/02/13.
//

import Foundation
import FirebaseFirestore

// MARK: ChallengeRecord Firebase Service(어떤 데이터를 받을 것인가에 대한 정의)
protocol ChallengeRecordDataSource {
    func challengeRecordfetchUserInfo(_ userId: String) async throws -> Msg?
    func fetchPreviousGameHistory() async throws -> [Challenge]
    func fetchChallengeUsersData(_ users: [String], _ challengeId: String) async -> ChallengeUserData?
    func fetchChallengeUsers(_ users: [String], _ challengeId: String) async -> ChallengeUserData
    func fetchChallengeTotalMoney(_ challengeId: String) async throws
    func fetchHistoryExpenditure(_ gameId: String) async -> Expenditure?
    typealias ChallengeUserData = [(user:(userName: String, userProfile: String), totalMoney: Int)]
    var database: Firestore { get }
}
