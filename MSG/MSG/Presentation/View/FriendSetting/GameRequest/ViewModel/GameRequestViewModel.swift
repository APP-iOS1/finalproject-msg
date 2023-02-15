//
//  GameRequestViewModel.swift
//  MSG
//
//  Created by 김민호 on 2023/02/15.
//

import Foundation

protocol GameRequestInput {
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


class GameRequestViewModel: ObservableObject, GameRequestInput {
    var gameRequestUseCase = GameRequestUseCase(repo:GameRequestRepositoryImpl(dataSourceFirebase: FirebaseService(), dataSourceRealtimeDB: Real()))
    func acceptGame(_ gameId: String) async {
        gameRequestUseCase.acceptGame(gameId)
    }
    
    func fetchChallengeInformation(_ challengeId: String) async -> Challenge? {
        let data = gameRequestUseCase.fetchChallengeInformation(challengeId)
        return data
    }
    
    func waitingLogic(data: Challenge?) async {
        gameRequestUseCase.waitingLogic(data: data)
    }
    
    func doSomeThing(data: Challenge) async {
        gameRequestUseCase.doSomeThing(data: data)
    }
    
    func notAllowChallegeStep1(data: [Msg]?) async {
        gameRequestUseCase.notAllowChallegeStep1(data: data)
    }
    
    func notAllowChallegeStep2(data: Challenge) {
        gameRequestUseCase.notAllowChallegeStep2(data: data)
    }
    
    func afterFiveMinuteDeleteChallenge(friend: Msg) async {
        gameRequestUseCase.afterFiveMinuteDeleteChallenge(friend: friend)
    }
    
    func afterFiveMinuteDeleteChallenge(friend: String) async {
        gameRequestUseCase.afterFiveMinuteDeleteChallenge(friend: friend)
    }
    
    func acceptGameRequest(friend: Msg) async {
        gameRequestUseCase.acceptGameRequest(friend: friend)
    }
    
    
}
