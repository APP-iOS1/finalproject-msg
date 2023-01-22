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
    
    var body: some View {
        
        ZStack {
            if let game = fireStoreViewModel.currentGame {
                AfterChallengeView(challenge: game)
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
//        .toolbar {
//            ToolbarItem(placement: .navigationBarLeading) {
//                Text("MSG")
//                    .font(.title)
//                    .fontWeight(.bold)
//                    .foregroundColor(Color("Font"))
//            }
//            ToolbarItem(placement: .navigationBarTrailing) {
//                NavigationLink(destination: SettingView(darkModeEnabled: $darkModeEnabled)) {
//                    Image(systemName: "person.circle")
//                        .font(.title2)
//                        .foregroundColor(Color("Font"))
//                }
//
//            }
//        }
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
