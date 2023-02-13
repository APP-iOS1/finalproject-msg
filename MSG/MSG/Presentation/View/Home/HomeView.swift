//
//  HomeView.swift
//  MSG
//
//  Created by 정소희 on 2023/01/17.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    
    @EnvironmentObject var fireStoreViewModel: FireStoreViewModel
    
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        ZStack {
            if let game = fireStoreViewModel.currentGame {
                if game.waitingFriend.isEmpty {
                    AfterChallengeView(challenge: fireStoreViewModel.currentGame!)
                } else {
                    WaitingView(game: fireStoreViewModel.currentGame!)
                        .refreshable {
                            await fireStoreViewModel.findUser(inviteId: fireStoreViewModel.currentGame!.inviteFriend,waitingId: fireStoreViewModel.currentGame!.waitingFriend)
                            await fireStoreViewModel.fetchGame()
                        }
                }
                
            } else {
                BeforeChallengeView()
            }
        }
        .onAppear {
            Task {
                guard let user = try! await fireStoreViewModel.fetchUserInfo(Auth.auth().currentUser?.uid ?? "") else {return}
                if !(user.game.isEmpty) {
                    await fireStoreViewModel.fetchGame()
                }
            }
      
        }
        .onReceive(timer) { _ in
            guard let game = fireStoreViewModel.currentGame  else { return }
//            print("끝나는시간:",game.endDate)
//            let now = Date().timeIntervalSinceNow
//            print("현재시간:", now)
            if Date().timeIntervalSince1970 > Double(game.endDate)! {
                self.timer.upstream.connect().cancel()
                print("멈췄습니다!")
                Task {
                    await fireStoreViewModel.addGameHistory()
                    fireStoreViewModel.currentGame = nil
                }
            }
        }
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
