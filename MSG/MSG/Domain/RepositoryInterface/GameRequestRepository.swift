//
//  GameRequestRepository.swift
//  MSG
//
//  Created by 김민호 on 2023/02/15.
//

import Foundation

protocol GameRequestRepository {
    func acceptGame(_ gameId: String) async //수락을 눌렀을 때 해당유저의 game에 초대받은 game의 id를 넣습니다
    func fetchChallengeInformation(_ challengeId: String) async -> Challenge? // 초대받은 챌린지의 정보를 가져오는 함수
    func waitingLogic(data: Challenge?) async
    func doSomeThing(data: Challenge) async -> Challenge?
    func notAllowChallegeStep1(data: [Msg]?) async
    func notAllowChallegeStep2(data: Challenge) async
    
    //realtime
//    func fetchGameRequest() async
    func afterFiveMinuteDeleteChallenge(friend: Msg) async
    func acceptGameRequest(friend: Msg) async
    func afterFiveMinuteDeleteChallenge(friend: String) async
    func sendFightRequest(to: [Msg], from: Msg, isFight: Bool)
}
