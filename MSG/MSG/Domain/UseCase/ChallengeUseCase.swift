//
//  ChallengeUseCase.swift
//  MSG
//
//  Created by sehooon on 2023/02/13.
//

import Foundation

//ChallengeUseCaseProtocol
protocol ChallengeUseCase{
    var repository: ChallengeRepositoryInterface { get }
    init(repository: ChallengeRepositoryInterface)
    func excuteMakeSingleChallenge(_ challenge: Challenge) async // 솔로 챌린지 생성
    func excuteMakeMultiChallenge(_ challenge: Challenge) async // 멀티 챌린지 생성
}


struct DefaultChallengeUseCase: ChallengeUseCase{
    //[Property]
    var repository: ChallengeRepositoryInterface
    //[init]
    init(repository: ChallengeRepositoryInterface) { self.repository = repository }
    //[method]
    func excuteMakeSingleChallenge(_ challenge: Challenge)  async { await repository.creatSingleChallenge(challenge) }
    func excuteMakeMultiChallenge(_ challenge: Challenge) async { await repository.creatMultiChallenge(challenge)}
}
