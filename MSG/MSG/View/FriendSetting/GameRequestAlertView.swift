//
//  GameRequestAlertView.swift
//  MSG
//
//  Created by sehooon on 2023/01/25.
//

import SwiftUI

struct GameRequestAlertView: View {
    @State private var isPresent = false
    @State private var challengeInfo: Challenge?
    @EnvironmentObject private var firestoreViewModel: FireStoreViewModel
    @EnvironmentObject private var realtimeViewModel: RealtimeViewModel
    var body: some View {
        ZStack{
            ScrollView{
                Color("Background").ignoresSafeArea()
                if realtimeViewModel.requsetGameArr.isEmpty{
                    Text("비어있습니다.")
                }
                ForEach(realtimeViewModel.requsetGameArr){ sendUser in
                    HStack{
                        Image(systemName: "person.circle")
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .frame(height: 60)
                        Text("\(sendUser.nickName)")
                        Spacer()
                        Button {
                            Task{
                                //                            challengeInfo = await firestoreViewModel.fetchChallengeInformation(sendUser.game)
                                //                            await firestoreViewModel.acceptGame(sendUser.game)
                                //                            realtimeViewModel.acceptGameRequest(friend: sendUser)
                                isPresent = true
                            }
                        } label: {
                            Text("확인하기✉️💌")
                                .padding(.trailing)
                        }
                        .alert(isPresented: $isPresent) {
                            CustomAlertView {
                                VStack(spacing: 10){
                                    Text("\(sendUser.nickName)님의 도전장👊")
                                        .padding()
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    Divider()
                                    Spacer()
                                    Text("\(challengeInfo?.gameTitle ?? "제목없음")")
                                        .font(.title3)
                                    VStack(spacing: 10){
                                        Text("목표금액💶")
                                            .font(.headline)
                                            .fontWeight(.bold)
                                        Text("\(challengeInfo?.limitMoney ?? 0)")
                                            .fontWeight(.bold)
                                            .font(.title2)
                                    }.padding()
                                    VStack(spacing: 10){
                                        Text("챌린지 기간🗓")
                                            .font(.headline)
                                            .fontWeight(.bold)
                                        Text("\(challengeInfo?.startDate.createdDate ?? "제목없음")")
                                            .font(.title2)
                                            .fontWeight(.bold)
                                        Text("\(challengeInfo?.endDate.createdDate ?? "제목없음")")
                                            .font(.title2)
                                            .fontWeight(.bold)
                                    }.padding()
                                    
                                    
                                    Spacer()
                                }
                                .frame(width: 300, height: 400)
                            } primaryButton: {
                                CustomAlertButton(title: Text("거절")) {
                                    isPresent = false
                                    print("도전")
                                }
                            } secondButton: {
                                CustomAlertButton(title: Text("수락")) {
                                    isPresent = false
                                    print("도망")
                                }
                            }
                        }
                        .onAppear{
                            Task{
                                challengeInfo = await firestoreViewModel.fetchChallengeInformation(sendUser.game)
                            }
                        }
                    }
                    .padding()
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
