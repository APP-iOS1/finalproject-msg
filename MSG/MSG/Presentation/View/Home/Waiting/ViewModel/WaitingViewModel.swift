//
//  WaitingViewModel.swift
//  MSG
//
//  Created by kimminho on 2023/01/30.
//

protocol WaitingViewModelInput {
    func fetchGame() async
    func findUser() async
    func afterFiveMinuteDeleteChallenge(friend: String) async
    func addMultiGameDeleteWaitUserFiveMinute(_ challenge: Challenge) async -> Challenge?
}


import SwiftUI

class WaitingViewModel: ObservableObject, WaitingViewModelInput {
    let challengeUseCase = ChallengeViewUseCase(challengeViewRepository: ChallengeViewRepositoryImpl(firestoreService: FirebaseService()))
    let gameRequestUseCase = GameRequestUseCase(repo:GameRequestRepositoryImpl(dataSourceFirebase: FirebaseService(), dataSourceRealtimeDB: Real()))
    let waitingUseCsae = WaitingUseCase(repo: WaitingRepositoryImpl(dataSource: FirebaseService()))
    
    @Published var currentGame: Challenge?
    @Published var invitedFriend: [Msg] = []
    @Published var waitingFriend: [Msg] = []

    @MainActor
    func fetchGame() async {
        print("실행되나요")
        self.currentGame = await challengeUseCase.fetchGameReturn()
    }
    
    @MainActor
    func findUser() async{
        guard let currentGame else { return }
        let data = await challengeUseCase.findUser(inviteId: currentGame.inviteFriend, waitingId: currentGame.waitingFriend)
        invitedFriend = data.0
        waitingFriend = data.1
    }
    
    func afterFiveMinuteDeleteChallenge(friend: String) async{
        await gameRequestUseCase.afterFiveMinuteDeleteChallenge(friend: friend)
    }
    
    func addMultiGameDeleteWaitUserFiveMinute(_ challenge: Challenge) async -> Challenge? {
        let data = await waitingUseCsae.addMultiGameDeleteWaitUserFiveMinute(challenge)
        return data
    }
    
    
    //fetchGame -> ChallengeViewDataSource
    //fireStoreViewModel.findUser(inviteId: fireStoreViewModel.currentGame!.inviteFriend,waitingId: fireStoreViewModel.currentGame!.waitingFriend) -> ChallengeViewDataSource
    //fireStoreViewModel.fetchGame()
    //                        await realtimeViewModel.afterFiveMinuteDeleteChallenge(friend: user)
}
//await fireStoreViewModel.addMultiGameDeleteWaitUserFiveMinute(fireStoreViewModel.currentGame!)

// GameRequestDataSourceWithRealtimeDB
