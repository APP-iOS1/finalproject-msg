//
//  ChallengeRecordViewModel.swift
//  MSG
//
//  Created by zooey on 2023/02/13.
//

import Foundation

protocol ChallengeRecordViewInput {
    func getChallengeHistory() async throws
    func getUserData(user: [String], challengeId: String) async -> ChallengeUserData?
    func getChallengeUser(users: [String], challengeId: String) async
    func getChallengeTotalMoney(challengeId: String) async throws
    func getHistoryExpenditure(gameId: String) async -> Expenditure?
    typealias ChallengeUserData = [(user:(userName: String, userProfile: String), totalMoney: Int)]
}

protocol ChallengeRecordViewOutput {
    var challengeHistoryArray : [Challenge] { get }
    var challengeUsers: ChallengeUserData { get }
    var challengeHistoryUserList : [(userId: String, totalMoney: Int)] { get }
    typealias ChallengeUserData = [(user:(userName: String, userProfile: String), totalMoney: Int)]
}

final class ChallengeRecordViewModel: ObservableObject, ChallengeRecordViewInput, ChallengeRecordViewOutput {
    
    var challengeRecordUseCase = ChallengeRecordUseCase(challengeRepository: ChallengeRecordRepositoryImpl(dataSource: FirebaseService()))
    typealias ChallengeUserData = [(user:(userName: String, userProfile: String), totalMoney: Int)]
    @Published var challengeHistoryArray : [Challenge] = []
    @Published var challengeUsers: ChallengeUserData = []
    @Published var challengeHistoryUserList : [(userId: String, totalMoney: Int)] = []
    
    @MainActor
    func getChallengeHistory() async throws {
        print(#function)
        do {
          challengeHistoryArray  = try await challengeRecordUseCase.getChallengeHistory()
        } catch {
            print("Error")
        }
    }
    
    func getUserData(user: [String], challengeId: String) async -> ChallengeUserData? {
        print(#function)
        let data = await challengeRecordUseCase.getUserData(user: user, challengeId: challengeId)
        return data
    }
    
    @MainActor
    func getChallengeUser(users: [String], challengeId: String) async {
        print(#function)
        challengeUsers = await challengeRecordUseCase.getChallengeUser(users: users, challengeId: challengeId)
    }
    
    func getChallengeTotalMoney(challengeId: String) async throws {
        print(#function)
        do {
            try await challengeRecordUseCase.getChallengeTotalMoney(challengeId: challengeId)
        } catch {
            print("Error")
        }
    }
    
    func getHistoryExpenditure(gameId: String) async -> Expenditure? {
        print(#function)
        let data = await challengeRecordUseCase.getHistoryExpenditure(gameId: gameId)
        return data
    }
}
