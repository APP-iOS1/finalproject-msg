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
        
        GeometryReader { g in
            ZStack {
                Color("Color1")
                    .ignoresSafeArea()
                
                VStack {
                    
                    
                    
                    HStack {
                        
                        HStack{
                            Text("게임 대기")
                                .modifier(TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.title2, color: FontCustomColor.color2))
                        }
                        
                        Spacer()
                        
                        Button {
                            Task {
                                await fireStoreViewModel.findUser(inviteId: fireStoreViewModel.currentGame!.inviteFriend, waitingId: fireStoreViewModel.currentGame!.waitingFriend)
                                await fireStoreViewModel.fetchGame()
                            }
                        } label: {
                            Image(systemName: "arrow.counterclockwise.circle.fill")
                                .resizable()
                                .frame(width: g.size.width / 14, height: g.size.height / 28)
                        }
                        
                    }
                    .frame(width: g.size.width / 1.1, height: g.size.height / 12)
                    
                    
                    
                    
                    
                    ZStack {
                        //fireStoreViewModel.currentGame!.inviteFriend.count
                        ProgressView(value: Double(fireStoreViewModel.currentGame!.inviteFriend.count), total: Double(fireStoreViewModel.currentGame!.inviteFriend.count + fireStoreViewModel.currentGame!.waitingFriend.count))
                            .tint(Color("Color2"))
                            .frame(height: g.size.height / 15)
                            .scaleEffect(x: Double(fireStoreViewModel.currentGame!.inviteFriend.count), y: g.size.height / 15, anchor: .center)
                            .clipShape(RoundedRectangle(cornerRadius: 3))
                        
                        Text("\(String(format: "%.0f%%", (Double(fireStoreViewModel.currentGame!.inviteFriend.count) * 100) / Double(fireStoreViewModel.currentGame!.inviteFriend.count + fireStoreViewModel.currentGame!.waitingFriend.count)))")
                            .modifier(TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.title3, color: FontCustomColor.color1))
                        
                        
                    }
                    .frame(width: g.size.width / 1.1, height: g.size.height / 12)
                    
                    
                    Divider()
                        .background(Color("Color2"))
                        .frame(width: g.size.width / 1.1, height: g.size.height / 20)
                    
                    VStack {
                        
                        ForEach(fireStoreViewModel.invitedArray, id: \.self) { user in
                            
                            HStack {
                                
                                
                                if !user.profileImage.isEmpty{
                                    AsyncImage(url: URL(string: user.profileImage)) { Image in
                                        Image
                                            .resizable()
                                            .scaledToFit()
                                            .clipShape(Circle())
                                            .frame(width: g.size.width / 7, height: g.size.height / 14)
                                    } placeholder: { }
                                }else{
                                    Image(systemName: "person.crop.circle")
                                        .resizable()
                                        .frame(width: g.size.width / 7, height: g.size.height / 14)
                                }
                                
                                Spacer()
                                
                                Text(user.nickName)
                                
                                Spacer()
                                
                                Text("Ready")
                                    .foregroundColor(Color("Color2"))
                                
                            }
                            .frame(width: g.size.width / 1.2, height: g.size.height / 12)
                            
                        }
                        
                        ForEach(fireStoreViewModel.waitingArray, id: \.self) { user in
                            
                            HStack {
                                
                                
                                if !user.profileImage.isEmpty{
                                    AsyncImage(url: URL(string: user.profileImage)) { Image in
                                        Image
                                            .resizable()
                                            .scaledToFit()
                                            .clipShape(Circle())
                                            .frame(width: g.size.width / 7, height: g.size.height / 14)
                                    } placeholder: { }
                                }else{
                                    Image(systemName: "person.crop.circle")
                                        .resizable()
                                        .frame(width: g.size.width / 7, height: g.size.height / 14)
                                }
                                
                                Spacer()
                                
                                Text(user.nickName)
                                
                                
                                Spacer()
                                
                                // 오락실스러운 레디 폰트 추가 예정
                                Text("Ready")
                                    .foregroundColor(.clear)
                                
                                
                                
                            }
                            .frame(width: g.size.width / 1.2, height: g.size.height / 12)
                            
                            
                        }
                        
                        
                        
                        
                        
                    }
                    
                    
                    Spacer()
                    
                }
                .frame(width: g.size.width / 1.1, height: g.size.height / 1.2)
                
            }
            .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.body, color: FontCustomColor.color2))
        }
        
    }
}

struct WaitingView_Previews: PreviewProvider {
    static var previews: some View {
        WaitingView(game: Challenge(id: "", gameTitle: "", limitMoney: 0, startDate: "", endDate: "", inviteFriend: ["애플케로로","구글김민호"], waitingFriend: ["카카오케로로","카카오김민호"]))
            .environmentObject(FireStoreViewModel())
        
    }
}
