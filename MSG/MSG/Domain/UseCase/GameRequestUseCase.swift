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
    func doSomeThing(data: Challenge) async -> Challenge?
    func notAllowChallegeStep1(data: [Msg]?) async
    func notAllowChallegeStep2(data: Challenge) async
    
    //realtime
//    func fetchGameRequest() async
    func afterFiveMinuteDeleteChallenge(friend: Msg) async
    func afterFiveMinuteDeleteChallenge(friend: String) async
    func acceptGameRequest(friend: Msg) async
    func sendFightRequest(to: [Msg], from: Msg, isFight: Bool)
}

struct GameRequestUseCase: GameRequest {
    
    var repo: GameRequestRepository
    
    func acceptGame(_ gameId: String) async {
        await repo.acceptGame(gameId)
    }
    
    func fetchChallengeInformation(_ challengeId: String) async -> Challenge? {
        let data = await repo.fetchChallengeInformation(challengeId)
        return data
    }
    
    func waitingLogic(data: Challenge?) async {
        await repo.waitingLogic(data: data)
    }
    
    func doSomeThing(data: Challenge) async -> Challenge?{
        if let data = await repo.doSomeThing(data: data) {
            return data
        }
        return nil
    }
    
    func notAllowChallegeStep1(data: [Msg]?) async {
        await repo.notAllowChallegeStep1(data: data)
    }
    
    func notAllowChallegeStep2(data: Challenge) async {
        await repo.notAllowChallegeStep2(data: data)
    }
    
    func afterFiveMinuteDeleteChallenge(friend: Msg) async {
        await repo.afterFiveMinuteDeleteChallenge(friend: friend)
    }
    
    func afterFiveMinuteDeleteChallenge(friend: String) async {
        await repo.afterFiveMinuteDeleteChallenge(friend: friend)
    }
    
    func acceptGameRequest(friend: Msg) async {
        await repo.acceptGameRequest(friend: friend)
    }
    func sendFightRequest(to: [Msg], from: Msg, isFight: Bool) {
        repo.sendFightRequest(to: to, from: from, isFight: isFight)
    }
    
}
