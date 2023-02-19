//
//  AddExpenditureRepositoryImpl.swift
//  MSG
//
//  Created by 김민호 on 2023/02/20.
//

import Foundation

struct ExpenditureRepositoryImpl: ExpenditureRepository {
    let dataSource: ExpenditureDataSource
    
    func addExpenditure(user: Msg, tagName: String, convert: String, addMoney: Int) async {
        print("== Impl ==")
        await dataSource.addExpenditure(user: user, tagName: tagName, convert: convert, addMoney: addMoney)
    }
    func fetchExpenditure(uid: String) async -> Expenditure? {
        if let data = await dataSource.fetchExpenditure(uid: uid) {
            return data
        }
        return nil
    }
}
