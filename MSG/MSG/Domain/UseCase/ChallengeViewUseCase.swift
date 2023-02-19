//
//  ChallengeViewUseCase.swift
//  MSG
//
//  Created by 정소희 on 2023/02/15.
//

import Foundation

protocol ChallengeUse {
    // 홈 뷰에서 사용중인 함수
    func fetchGame() async // Challenge Collection에서 진행중인 게임 정보 가져오기
    func fetchGameReturn() async -> Challenge?
    func challengefetchUserInfo(_ userId: String) async throws -> Msg? // 유저 정보를 불러오는 함수
    func addGameHistory() async // 진행이 끝난 게임을 gameHistory에 담아주는 함수
    func findUser(inviteId: [String], waitingId: [String]) async -> ([Msg],[Msg])
    
    // AfterChallengeView
    func giveUpMultiGame() async // MultiGame 중도포기(개인)
    func deleteSingleGame() async // SingleGame 중도포기(삭제)
    func fetchExpenditure() async // 현재 유저의 지출기록을 가져오기
    func parsingExpenditure(expenditure: [String:[String]])
    
    // BeforeChallengeView
    func findFriend() // 친구 목록 가져오기
}

struct ChallengeViewUseCase: ChallengeUse {

    var challengeViewRepository: ChallengeViewRepository
    
    func findUser(inviteId: [String], waitingId: [String]) async -> ([Msg],[Msg]){
        let data = await challengeViewRepository.findUser(inviteId: inviteId, waitingId: waitingId)
        return data
    }
    
    func fetchGame() async {
        await challengeViewRepository.fetchGame()
    }
    
    func fetchGameReturn() async -> Challenge? {
        if let data = await challengeViewRepository.fetchGameReturn() {
            return data
        }
        return nil
    }
    
    func challengefetchUserInfo(_ userId: String) async throws -> Msg? {
        let data = try await challengeViewRepository.challengefetchUserInfo(userId)
        return data
    }
    
    func addGameHistory() async {
        await challengeViewRepository.addGameHistory()
    }
    
    func giveUpMultiGame() async {
        await challengeViewRepository.giveUpMultiGame()
    }
    
    func deleteSingleGame() async {
        await challengeViewRepository.deleteSingleGame()
    }
    
    func fetchExpenditure() async {
        await challengeViewRepository.fetchExpenditure()
    }
    
    func parsingExpenditure(expenditure: [String : [String]]) {
        challengeViewRepository.parsingExpenditure(expenditure: expenditure)
    }
    
    func findFriend() {
        challengeViewRepository.findFriend()
    }
    
    
   
    
}
