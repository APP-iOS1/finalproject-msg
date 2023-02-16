//
//  AppDI.swift
//  MSG
//
//  Created by 정소희 on 2023/02/15.
//

import Foundation

protocol AppDIInterface {
    var challengeViewModel: ChallengeViewModel { get }
}

final class AppDI: AppDIInterface {

    static let shared = AppDI()

    lazy var challengeViewModel: ChallengeViewModel = {

        //MARK: Data Layer
        let dataSource: ChallengeViewDataSource = FirebaseService()

        let repository = ChallengeViewRepositoryImpl(firestoreService: dataSource)

        //MARK: Domain Layer
        let fetchChallengeUseCase = ChallengeViewUseCase(challengeViewRepository: repository)
        
        let viewModel = ChallengeViewModel(challegeUsecase: fetchChallengeUseCase)

        return viewModel
    }()
}
