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
        await dataSourceFirebase.acceptGame(gameId)
    }
    
    func fetchChallengeInformation(_ challengeId: String) async -> Challenge? {
        let data = await dataSourceFirebase.fetchChallengeInformation(challengeId)
        return data
    }
    
    func waitingLogic(data: Challenge?) async {
        await dataSourceFirebase.waitingLogic(data: data)
    }
    
    func doSomeThing(data: Challenge) async -> Challenge?{
        if let data = await dataSourceFirebase.doSomeThing(data: data) {
            return data
        }
        return nil
    }
    
    func notAllowChallegeStep1(data: [Msg]?) async {
        await dataSourceFirebase.notAllowChallegeStep1(data: data)
    }
    
    func notAllowChallegeStep2(data: Challenge) async{
        await dataSourceFirebase.notAllowChallegeStep2(data: data)
    }
    
    
    
    //MARK: -Realtime
    func acceptGameRequest(friend: Msg) async {
        await dataSourceRealtimeDB.acceptGameRequest(friend: friend)
    }
    func afterFiveMinuteDeleteChallenge(friend: Msg) async {
        await dataSourceRealtimeDB.afterFiveMinuteDeleteChallenge(friend: friend)
    }
    func afterFiveMinuteDeleteChallenge(friend: String) async {
        await dataSourceRealtimeDB.afterFiveMinuteDeleteChallenge(friend: friend)
    }
    func sendFightRequest(to: [Msg], from: Msg, isFight: Bool) {
        dataSourceRealtimeDB.sendFightRequest(to: to, from: from, isFight: isFight)
    }
    
}
