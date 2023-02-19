//
//  WaitingRepositoryImpl.swift
//  MSG
//
//  Created by 김민호 on 2023/02/19.
//

import Foundation

struct WaitingRepositoryImpl: WaitingRepository {
    let dataSource: WaitingDataSource
    
    func addMultiGameDeleteWaitUserFiveMinute(_ challenge: Challenge) async -> Challenge?{
        if let data = await dataSource.addMultiGameDeleteWaitUserFiveMinute(challenge) {
            return data
        }
        return nil
    }
}
