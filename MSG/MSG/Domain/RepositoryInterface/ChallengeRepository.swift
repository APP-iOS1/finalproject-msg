//
//  ChallengeRepository.swift
//  MSG
//
//  Created by sehooon on 2023/02/13.
//

import Foundation

protocol ChallengeRepositoryInterface{
    func creatSingleChallenge(_ challenge: Challenge) async
    func creatMultiChallenge(_ challenge: Challenge) async
}
