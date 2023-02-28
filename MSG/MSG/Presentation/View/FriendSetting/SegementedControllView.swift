//
//  SegementedControllView.swift
//  MSG
//
//  Created by zooey on 2023/01/19.
//

import SwiftUI

struct SegementedControllView: View {
    
    @Binding var selection: Int
    @State private var frames = Array<CGRect>(repeating: .zero, count: 20)
    private let titles: [String]
    private let selectedItemColor: Color
    private let backgroundColor: Color
    private let selectedItemFontColor: Color
    
    init(selection: Binding<Int>, titles: [String], selectedItemColor: Color, backgroundColor: Color, selectedItemFontColor: Color) {
        _selection = selection
        self.titles = titles
        self.selectedItemColor = selectedItemColor
        self.backgroundColor = backgroundColor
        self.selectedItemFontColor = selectedItemFontColor
    }
    
    var body: some View {
        
        VStack {
            ZStack {
                HStack(spacing: 10) {
                    ForEach(self.titles.indices, id: \.self) { index in
                        Text(self.titles[index])
                            .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.body, color: FontCustomColor.color2))
                            .foregroundColor(selectedItemFontColor)
                            .onTapGesture {
                                self.selection = index
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background {
                                GeometryReader { geo in
                                    Color.clear.onAppear {
                                        self.setFrame(index: index, frame: geo.frame(in: .global))
                                    }
                                }
                            }
                    }
                }
                .background(alignment: .bottomLeading) {
                    Rectangle()
                        .fill(selectedItemColor)
                        .frame(width: self.frames[self.selection].width, height: 2)
                        .offset(x: self.frames[self.selection].minX - self.frames[0].minX)
                }
//                .padding()
            }
            .background(backgroundColor)
            .animation(.spring(), value: selection)
        }
        .padding()
    }
    
    private func setFrame(index: Int, frame: CGRect) {
        DispatchQueue.main.async {
            self.frames[index] = frame
        }
    }
}

