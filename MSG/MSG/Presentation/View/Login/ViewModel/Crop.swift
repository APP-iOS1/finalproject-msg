//
//  Crop.swift
//  MSG
//
//  Created by zooey on 2023/02/23.
//

import Foundation

// MARK: - 이미지 크기 및 모양 조절
enum Crop: Equatable {
    case circle
    
    func name() -> String {
        switch self {
        case .circle:
            return "사진 크기 조절"
        }
    }
    
    func size() -> CGSize {
        switch self {
        case .circle:
            return .init(width: 300, height: 300)
        }
    }
}
