//
//  ProgressViewModel.swift
//  MSG
//
//  Created by 김민호 on 2023/02/20.
//

import Foundation

class ProgressViewModel: ObservableObject {
    var expenditureUseCase = ExpenditureUseCase(repo: ExpenditureRepositoryImpl(dataSource: FirebaseService()))
    var friendUseCase = DivideFriendUseCase(repo: DivideFriendRepositoryImpl(dataSource: FirebaseService()))
//    self.user = try! await fireStoreViewModel.fetchUserInfo(friend)
//    expenditure = await fireStoreViewModel.fetchExpenditure(friend)
    
    func fetchUserInfo(uid: String) async throws -> Msg? {
        if let data = try? await friendUseCase.fetchUserInfo(uid) {
            return data
        }
        return nil
    }
    func fetchExpenditure(uid: String) async -> Expenditure?{
        if let data = await expenditureUseCase.fetchExpenditure(uid: uid) {
            return data
        }
        return nil
    }
}
