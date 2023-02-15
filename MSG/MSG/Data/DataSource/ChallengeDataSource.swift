//
//  ChallengeDataSource.swift
//  MSG
//
//  Created by sehooon on 2023/02/13.
//

import Foundation

protocol ChallengeDataSource{
    func makeSingleGame(_ singleGame: Challenge) async //싱글 챌린지 생성함수
    func fetchChallengeId() async -> String?    // 현재 유저가 진행중인 챌린지 ID를 가져오는 함수
    func updateUserGame(gameId: String) async   // 유저의 챌린지 ID를 업데이트 하는 함수
}
