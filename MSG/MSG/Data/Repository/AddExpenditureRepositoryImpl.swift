//
//  AddExpenditureRepositoryImpl.swift
//  MSG
//
//  Created by 김민호 on 2023/02/20.
//

import Foundation

struct AddExpenditureRepositoryImpl: AddExpenditureRepository {
    let dataSource: AddExpenditureDataSource
    func addExpenditure(user: Msg, tagName: String, convert: String, addMoney: Int) async {
        print("== Impl ==")
        await dataSource.addExpenditure(user: user, tagName: tagName, convert: convert, addMoney: addMoney)
    }
}
