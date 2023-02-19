//
//  ChallengeViewModel.swift
//  MSG
//
//  Created by 정소희 on 2023/02/15.
//

import Foundation

protocol ChallengeViewInput {
    // 홈 뷰에서 사용중인 함수
    func fetchGame() async // Challenge Collection에서 진행중인 게임 정보 가져오기
    func fetchGameReturn() async
    func challengefetchUserInfo(_ userId: String) async throws -> Msg? // 유저 정보를 불러오는 함수
    func addGameHistory() async // 진행이 끝난 게임을 gameHistory에 담아주는 함수
    func findUser(inviteId: [String], waitingId: [String]) async
    
    // AfterChallengeView
    func giveUpMultiGame() async // MultiGame 중도포기(개인)
    func deleteSingleGame() async // SingleGame 중도포기(삭제)
    func fetchExpenditure() async // 현재 유저의 지출기록을 가져오기
    func parsingExpenditure(expenditure: [String:[String]])
    
    // BeforeChallengeView
    func findFriend() // 친구 목록 가져오기
    
}

protocol ChallengeViewOutput {
    var userArray: [Msg] { get }
    var currentGame: Challenge? { get }
    var expenditure: Expenditure? { get }
    var expenditureList: [String: [String]] { get }
    var totalMoney: Int { get }
    var invitedArray: [Msg] { get }
    var waitingArray: [Msg] { get }
}

final class ChallengeViewModel: ObservableObject, ChallengeViewInput, ChallengeViewOutput {

    var challengeUseCase = ChallengeViewUseCase(challengeViewRepository: ChallengeViewRepositoryImpl(firestoreService: FirebaseService()))
    
    @Published var userArray: [Msg] = []
    @Published var invitedArray: [Msg] = []
    @Published var waitingArray: [Msg] = []
    
    @Published var currentGame: Challenge?
    @Published var expenditure: Expenditure?
    @Published var expenditureList: [String: [String]] = [:]
    @Published var totalMoney = 0

    init(challegeUsecase: ChallengeViewUseCase? = nil){
        self.challengeUseCase = ChallengeViewUseCase(challengeViewRepository: ChallengeViewRepositoryImpl(firestoreService: FirebaseService()))
    }
    
    @MainActor
    func findUser(inviteId: [String], waitingId: [String]) async {
        let data = await challengeUseCase.findUser(inviteId: inviteId, waitingId: waitingId)
        self.invitedArray = data.0
        self.waitingArray = data.1
    }
    
    func fetchGame() async {
        await challengeUseCase.fetchGame()
    }
    
    @MainActor
    func fetchGameReturn() async {
        self.currentGame = await challengeUseCase.fetchGameReturn()
    }
        
    func challengefetchUserInfo(_ userId: String) async throws -> Msg? {
        let data = try await challengeUseCase.challengefetchUserInfo(userId)
        return data
    }
    
    func addGameHistory() async {
        await challengeUseCase.addGameHistory()
    }
    
    func giveUpMultiGame() async {
        await challengeUseCase.giveUpMultiGame()
    }
    
    func deleteSingleGame() async {
        await challengeUseCase.deleteSingleGame()
    }
    
    func fetchExpenditure() async {
        await challengeUseCase.fetchExpenditure()
    }
    
    func parsingExpenditure(expenditure: [String : [String]]) {
        challengeUseCase.parsingExpenditure(expenditure: expenditure)
    }
    
    func findFriend() {
        challengeUseCase.findFriend()
    }
    
    
}
