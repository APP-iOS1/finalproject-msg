//
//  LicenseView.swift
//  MSG
//
//  Created by zooey on 2023/02/07.
//

import SwiftUI

struct LicenseView: View {
    
    var body: some View {
        
        GeometryReader { g in
            ZStack {
                Color("Color1")
                    .ignoresSafeArea()
                VStack {
                    VStack(alignment: .leading) {
                        Text("Licenses")
                            .modifier(TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.largeTitle, color: FontCustomColor.color2))
                        Text("Money Save Game")
                            .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.caption, color: FontCustomColor.color2))
                    }
                    .frame(width: g.size.width / 1.1, height: g.size.height / 12, alignment: .leading)
                    
                    List(licenseListItem, id: \.self) { item in
                        NavigationLink(
                            destination: LicenseDetailView(licenseItem: item),
                            label: {
                                Text(item.name)
                                    .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.body, color: FontCustomColor.color2))
                            }
                        )
                        .listRowBackground(Color("Color1"))
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LicenseView_Previews: PreviewProvider {
    static var previews: some View {
        LicenseView()
    }
}
