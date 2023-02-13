//
//  ChallengeRecordRepositoryImpl.swift
//  MSG
//
//  Created by zooey on 2023/02/13.
//

import Foundation

// MARK: - ChallengeRecord Repository
struct ChallengeRecordRepositoryImpl: ChallengeRecordRepository {
    
    var dataSource: ChallengeRecordDataSource
    typealias ChallengeUserData = [(user:(userName: String, userProfile: String), totalMoney: Int)]
    
    // MARK: - 이전 챌린지기록을 모두 가져오는 함수
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
    
    // MARK: - 챌린지 참가자 (유저 정보, 지출) 가져오기
    func getUserData(user: [String], challengeId: String) async -> ChallengeUserData? {
        print(#function)
        let data = await dataSource.fetchChallengeUsersData(user, challengeId)
        return data
    }
    
    // MARK: - 챌린지 참가자 (유저 정보, 지출) 가져오기
    func getChallengeUser(users: [String], challengeId: String) async -> ChallengeUserData {
        print(#function)
       let data = await dataSource.fetchChallengeUsers(users, challengeId)
        return data
    }
    
    // MARK: - 챌린지 이력의 리스트 셀을 선택했을 시, 각 유저별 토탈 금액 가져오는 함수
    func getChallengeTotalMoney(challengeId: String) async throws {
        print(#function)
        do {
            try await dataSource.fetchChallengeTotalMoney(challengeId)
        } catch {
            print("Error: Failed to get user total amount.")
        }
    }
    
    //MARK: - 해당 유저의 특정 과거 게임 지출 기록 가져오기
    func getHistoryExpenditure(gameId: String) async -> Expenditure? {
        let data = await dataSource.fetchHistoryExpenditure(gameId)
        return data
    }
}
