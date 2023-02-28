//
//  ChallengeRecordUseCase.swift
//  MSG
//
//  Created by zooey on 2023/02/13.
//

import Foundation

// MARK: - ChallengeRecord Usecase protocol
protocol ChallengeRecordUse {
    func challengeRecordfetchUserInfo(_ userId: String) async throws -> Msg?
    func getChallengeHistory() async throws -> [Challenge]
    func getUserData(user: [String], challengeId: String) async -> ChallengeUserData?
    func getChallengeUser(users: [String], challengeId: String) async -> ChallengeUserData
    func getChallengeTotalMoney(challengeId: String) async throws
    func getHistoryExpenditure(gameId: String) async -> Expenditure?
    typealias ChallengeUserData = [(user:(userName: String, userProfile: String), totalMoney: Int)]
}

// MARK: - ChallengeRecord UseCase
struct ChallengeRecordUseCase: ChallengeRecordUse {
    
    var challengeRepository: ChallengeRecordRepository
    typealias ChallengeUserData = [(user:(userName: String, userProfile: String), totalMoney: Int)]
    
    func challengeRecordfetchUserInfo(_ userId: String) async throws -> Msg? {
        let data = try await challengeRepository.challengeRecordfetchUserInfo(userId)
        return data
    }
    
    // MARK: - 이전 챌린지기록을 모두 가져오는 함수
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
    
    // MARK: - 챌린지 참가자 (유저 정보, 지출) 가져오기
    func getUserData(user: [String], challengeId: String) async -> ChallengeUserData? {
        print(#function)
        let challengeUserData = await challengeRepository.getUserData(user: user, challengeId: challengeId)
        return challengeUserData
    }
    
    // MARK: - 챌린지 참가자 (유저 정보, 지출) 가져오기
    func getChallengeUser(users: [String], challengeId: String) async -> ChallengeUserData {
        print(#function)
        let challengeUser = await challengeRepository.getChallengeUser(users: users, challengeId: challengeId)
        return challengeUser
    }
    
    // MARK: - 챌린지 이력의 리스트 셀을 선택했을 시, 각 유저별 토탈 금액 가져오는 함수
    func getChallengeTotalMoney(challengeId: String) async throws {
        print(#function)
        do {
            try await challengeRepository.getChallengeTotalMoney(challengeId: challengeId)
        } catch {
            print("Error: Failed to get user total amount.")
        }
    }
    
    //MARK: - 해당 유저의 특정 과거 게임 지출 기록 가져오기
    func getHistoryExpenditure(gameId: String) async -> Expenditure? {
        print(#function)
        let challengeExpenditure = await challengeRepository.getHistoryExpenditure(gameId: gameId)
        return challengeExpenditure
    }
}

