//
//  WaitingUseCase.swift
//  MSG
//
//  Created by 김민호 on 2023/02/19.
//

import Foundation

protocol Waiting {
    func addMultiGameDeleteWaitUserFiveMinute(_ challenge: Challenge) async -> Challenge?
}

struct WaitingUseCase: Waiting {
    
    let repo: WaitingRepository
    
    func addMultiGameDeleteWaitUserFiveMinute(_ challenge: Challenge) async -> Challenge? {
        if let data = await repo.addMultiGameDeleteWaitUserFiveMinute(challenge) {
            return data
        }
        return nil 
    }
}
