//
//  ChallengeRepositoryImpl.swift
//  MSG
//
//  Created by sehooon on 2023/02/13.
//

import Foundation

struct ChallengeRepository: ChallengeRepositoryInterface{
    private let firestoreService: ChallengeDataSource
    
    init(firestoreService: ChallengeDataSource) {
        self.firestoreService = firestoreService
    }
    
    func creatSingleChallenge(_ challenge: Challenge)  async {
        await firestoreService.makeSingleGame(challenge)
    } // 싱글 챌린지 만들기
    func creatMultiChallenge(_ challenge: Challenge) async {
        await firestoreService.makeMultiGame(challenge)
    }
    
}
