//
//  HomeView.swift
//  MSG
//
//  Created by 정소희 on 2023/01/17.
//

import SwiftUI

struct HomeView: View {
    
    @State private var challengeState: Bool = false
    @Binding var darkModeEnabled: Bool
    
    var body: some View {
        ZStack{
            if challengeState {
                AfterChallengeView(challenge: Challenge(id: "", gameTitle: "", limitMoney: 30000, startDate: "2023년01월18일", endDate: "2023년01월31일", inviteFriend: []))
            } else {
                BeforeChallengeView(challengeState: $challengeState)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Text("MSG")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color("Font"))
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: SettingView(darkModeEnabled: $darkModeEnabled)) {
                    Image(systemName: "person.circle")
                        .font(.title2)
                        .foregroundColor(Color("Font"))
                }
                
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(darkModeEnabled: .constant(false))
    }
}
