//
//  GameRequestAlertView.swift
//  MSG
//
//  Created by sehooon on 2023/01/25.
//

import SwiftUI

struct GameRequestAlertView: View {
    @EnvironmentObject private var firestoreViewModel: FireStoreViewModel
    @EnvironmentObject private var realtimeViewModel: RealtimeViewModel
    var body: some View {
        ZStack{
            Color("Background").ignoresSafeArea()
            if realtimeViewModel.requsetGameArr.isEmpty{
                Text("비어있습니다.")
            }
            ForEach(realtimeViewModel.requsetGameArr){ sendUser in
                HStack{
                    Text("\(sendUser.nickName)")
                    Button {
                        Task{
                            await firestoreViewModel.acceptGame(sendUser.game)
                            realtimeViewModel.acceptGameRequest(friend: sendUser)
                        }
                    } label: {
                        Text("수락하기")
                    }
                }
            }
        }
        .onAppear{
            realtimeViewModel.fetchGameRequest()
        }
    }
}

struct GameRequestAlertView_Previews: PreviewProvider {
    static var previews: some View {
        GameRequestAlertView()
    }
}
