//
//  Extension+String.swift
//  MSG
//
//  Created by zooey on 2023/01/20.
//

import Foundation

extension String {
    var createdDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "yyyy년 MM월 dd일" // "yyyy-MM-dd HH:mm:ss"
        
        let dateCreatedAt = Date(timeIntervalSince1970: Double(self)!)
//        print(dateCreatedAt)
//        print(Date().timeIntervalSince1970)
        return dateFormatter.string(from: dateCreatedAt)
    }

    //공백 제거 후, 문자열 개수 리턴
    var trimSpacingCount:Int{
            return self.trimmingCharacters(in: .whitespaces).count
        }

}

