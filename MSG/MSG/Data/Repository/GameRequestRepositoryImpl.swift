//
//  GameRequestRepositoryImpl.swift
//  MSG
//
//  Created by 김민호 on 2023/02/15.
//

import Foundation

struct GameRequestRepositoryImpl: GameRequestRepository {
    var dataSourceFirebase: GameRequestDataSourceWithFirebase
    var dataSourceRealtimeDB: GameRequestDataSourceWithRealtimeDB
    
    func acceptGame(_ gameId: String) async {
        dataSourceFirebase.acceptGame(gameId)
    }
    
    func fetchChallengeInformation(_ challengeId: String) async -> Challenge? {
        let data = dataSourceFirebase.fetchChallengeInformation(challengeId)
        return data
    }
    
    func waitingLogic(data: Challenge?) async {
        dataSourceFirebase.waitingLogic(data: data)
    }
    
    func doSomeThing(data: Challenge) async {
        dataSourceFirebase.doSomeThing(data: data)
    }
    
    func notAllowChallegeStep1(data: [Msg]?) async {
        dataSourceFirebase.notAllowChallegeStep1(data: data)
    }
    
    func notAllowChallegeStep2(data: Challenge) {
        dataSourceFirebase.notAllowChallegeStep2(data: data)
    }
    
    
    
    //MARK: -Realtime
    func acceptGameRequest(friend: Msg) async {
        dataSourceRealtimeDB.acceptGameRequest(friend: friend)
    }
    func afterFiveMinuteDeleteChallenge(friend: Msg) async {
        dataSourceRealtimeDB.afterFiveMinuteDeleteChallenge(friend: friend)
    }
    func afterFiveMinuteDeleteChallenge(friend: String) async {
        dataSourceRealtimeDB.afterFiveMinuteDeleteChallenge(friend: friend)
    }
    
}
