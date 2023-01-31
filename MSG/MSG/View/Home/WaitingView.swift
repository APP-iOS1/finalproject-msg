//
//  WaitingView.swift
//  MSG
//
//  Created by kimminho on 2023/01/30.
//

import SwiftUI

struct WaitingView: View {
    
    
    @State var game: Challenge
    @EnvironmentObject var fireStoreViewModel: FireStoreViewModel
    var body: some View {

        
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                
                Spacer()
                
                VStack(alignment: .leading) {
                    HStack {
                        
                        HStack{
                            Text("게임 대기")
                                .font(.title)
                                .bold()
                            
                            Text("\(game.inviteFriend.count) / \(game.inviteFriend.count + game.waitingFriend.count)" )
                                .font(.body)
                            
                        }
               Spacer()
                        Button {
                            
                        } label: {
                            Image(systemName: "arrow.counterclockwise.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                    }
                    .padding()
                    
                    HStack{
                        
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.blue)
                        
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.blue)
                        
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                        
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                        
                    }
                    .padding()
                    .padding(.bottom, -20)
                }
               

                ProgressView(value: Double(game.inviteFriend.count), total: Double(game.inviteFriend.count + game.waitingFriend.count))
                    .tint(Color("Point2"))
                    .padding()
                    .padding(.bottom, 40)
                
                ScrollView {
                    Section {
                        //                    ForEach(fireStoreViewModel.invitedArray, id: \.self) { user in
                        //                        Text("\(user.nickName)")
                        //                    }
                        
                        ForEach(fireStoreViewModel.invitedArray, id: \.self) { user in
                            HStack {
                                HStack {
                                    if !user.profilImage.isEmpty{
                                        AsyncImage(url: URL(string: user.profilImage)) { Image in
                                            Image
                                                .resizable()
                                                .frame(width: 50, height: 50)
                                        } placeholder: { }
                                    }else{
                                        Image(systemName: "person.crop.circle")
                                            .resizable()
                                            .frame(width: 50, height: 50)
                                    }
                                    
                                    Spacer()
                                    
                                    Text(user.nickName)
                                        .font(.title3)
                                        .bold()
                                    
                                    Spacer()
                                }
                                // 오락실스러운 레디 폰트 추가 예정
                                Text("Ready")
                                    .foregroundColor(Color("Point2"))
                                    .font(.title3)
                                    .bold()
                            }
                        }
                        
                        ForEach(fireStoreViewModel.waitingArray, id: \.self) { user in
                            HStack {
                                HStack {
                                    if !user.profilImage.isEmpty{
                                        AsyncImage(url: URL(string: user.profilImage)) { Image in
                                            Image
                                                .resizable()
                                                .frame(width: 50, height: 50)
                                        } placeholder: { }
                                    }else{
                                        Image(systemName: "person.crop.circle")
                                            .resizable()
                                            .frame(width: 50, height: 50)
                                    }
                                    Spacer()
                                    
                                    Text(user.nickName)
                                        .font(.title3)
                                        .bold()
                                    
                                    Spacer()
                                }
                                // 오락실스러운 레디 폰트 추가 예정
                                Text("Ready")
                                    .foregroundColor(.clear)
                                    .font(.title3)
                                    .bold()
                            }
                        }
                        
                    }
                    
                }
                .padding()
                

            }
            .frame(width: 330, height: 600)
            .task { await fireStoreViewModel.findUser(inviteId: game.inviteFriend, waitingId: game.waitingFriend) }
        }

        
    }
}

struct WaitingView_Previews: PreviewProvider {
    static var previews: some View {
        WaitingView(game: Challenge(id: "", gameTitle: "", limitMoney: 0, startDate: "", endDate: "", inviteFriend: ["애플케로로","구글김민호"], waitingFriend: ["카카오케로로","카카오김민호"]))
   
            
    }
}
