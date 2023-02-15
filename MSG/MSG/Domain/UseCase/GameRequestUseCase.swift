//
//  GameRequestUseCase.swift
//  MSG
//
//  Created by 김민호 on 2023/02/15.
//

import Foundation

protocol GameRequest {
    func acceptGame(_ gameId: String) async //수락을 눌렀을 때 해당유저의 game에 초대받은 game의 id를 넣습니다
    func fetchChallengeInformation(_ challengeId: String) async -> Challenge? // 초대받은 챌린지의 정보를 가져오는 함수
    func waitingLogic(data: Challenge?) async
    func doSomeThing(data: Challenge) async
    func notAllowChallegeStep1(data: [Msg]?) async
    func notAllowChallegeStep2(data: Challenge)
    
    //realtime
//    func fetchGameRequest() async
    func afterFiveMinuteDeleteChallenge(friend: Msg) async
    func afterFiveMinuteDeleteChallenge(friend: String) async
    func acceptGameRequest(friend: Msg) async
}

struct GameRequestUseCase: GameRequest {
    var repo: GameRequestRepository
    
    func acceptGame(_ gameId: String) async {
        repo.acceptGame(gameId)
    }
    
    func fetchChallengeInformation(_ challengeId: String) async -> Challenge? {
        let data = repo.fetchChallengeInformation(challengeId)
        return data
    }
    
    func waitingLogic(data: Challenge?) async {
        repo.waitingLogic(data: data)
    }
    
    func doSomeThing(data: Challenge) async {
        repo.doSomeThing(data: data)
    }
    
    func notAllowChallegeStep1(data: [Msg]?) async {
        repo.notAllowChallegeStep2(data: data)
    }
    
    func notAllowChallegeStep2(data: Challenge) {
        repo.notAllowChallegeStep1(data: data)
    }
    
    func afterFiveMinuteDeleteChallenge(friend: Msg) async {
        repo.afterFiveMinuteDeleteChallenge(friend: friend)
    }
    
    func afterFiveMinuteDeleteChallenge(friend: String) async {
        repo.afterFiveMinuteDeleteChallenge(friend: friend)
    }
    
    func acceptGameRequest(friend: Msg) async {
        repo.acceptGameRequest(friend: friend)
    }
    
    
}
