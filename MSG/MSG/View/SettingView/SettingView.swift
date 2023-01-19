//
//  SettingView.swift
//  MSG
//
//  Created by zooey on 2023/01/18.
//
import SwiftUI

struct SettingView: View {
    
    @State private var currentMode: ColorScheme = .light
    @State private var isToggleOn: Bool = false
    
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            VStack {
                Toggle("다크모드 활성화", isOn: $isToggleOn)
                .onChange(of: isToggleOn, perform: { newValue in
                    if isToggleOn == true {
                        currentMode = .dark
                    }
                })
            }
            .padding()
        }
        .preferredColorScheme(currentMode)
    }
}

struct SettignView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
