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
        
        GeometryReader { g in
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
                VStack {
                    Button {
                        isFirstLaunching = false
                    } label: {
                        Text("로그인 시작하기")
                            .modifier(TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.title3, color: FontCustomColor.color2))
                            .font(.headline)
                            .bold()
                            .frame(width: g.size.width / 1.4, height: g.size.height / 24)
                            .shadow(color: Color("Shadow3"), radius: 8, x: -9, y: -9)
                            .shadow(color: Color("Shadow"), radius: 8, x: 9, y: 9)
                            .padding(20)
                            .background(Color("Color1"))
                            .cornerRadius(20)
                    }
                    .shadow(color: Color("Shadow3"), radius: 8, x: -9, y: -9)
                    .shadow(color: Color("Shadow"), radius: 8, x: 9, y: 9)
                    .padding(.top, 535)
                }

            }
        }
    }
}

struct OnBoardTapView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OnBoardTapView(isFirstLaunching: .constant(false))
                .previewDevice("iPhone 14 Pro Max")
            OnBoardTapView(isFirstLaunching: .constant(false))
                .previewDevice("iPhone 14 Pro")
            OnBoardTapView(isFirstLaunching: .constant(false))
                .previewDevice("iPhone SE (3rd generation)")
        }
//        OnBoardTapView(isFirstLaunching: .constant(false))
    }
}
