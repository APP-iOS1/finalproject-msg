//
//  HomeView.swift
//  MSG
//
//  Created by 정소희 on 2023/01/17.
//

import SwiftUI

struct HomeView: View {
    @State private var challengeState: Bool = false
    
    var body: some View {
        
        if challengeState {
            AfterChallengeView()
        } else {
            BeforeChallengeView()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
