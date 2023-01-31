//
//  OnBoardTapView.swift
//  MSG
//
//  Created by kimminho on 2023/01/18.
//

import SwiftUI

struct OnBoardTapView: View {
    @Binding var isFirstLaunching: Bool
    
    // timer count
    @State var count: Int = 1
    let timer = Timer.publish(every: 3.0, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        ZStack {
            
            ZStack {
                TabView(selection: $count,
                        content: {
                    if count == 1 {
                        OnBoardView1()
                            .tag(1)
                    } else if count == 2 {
                        OnBoardView2()
                            .tag(2)
                    } else if count == 3 {
                        OnBoardView3()
                            .tag(3)
                    } else if count == 4 {
                        OnBoardView4()
                            .tag(4)
                    } else if count == 5 {
                        OnBoardView5()
                            .tag(5)
                    }
                })
                .ignoresSafeArea()
                .onReceive(timer, perform: { _ in
                    withAnimation(.default) {
                        count = count == 5 ? 1 : count + 1
                    }
                })
            }
            
            Button {
                isFirstLaunching = false
            } label: {
                Text("로그인 시작하기")
                    .modifier(TextTitleBold())
                    .frame(width: 280, height: 45, alignment: .center)
            }
            .background(Color("Point2"))
            .buttonStyle(.bordered)
            .cornerRadius(8)
            .padding(.top, 500)
            
        }
    }
}

struct OnBoardTapView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardTapView(isFirstLaunching: .constant(false))
    }
}
