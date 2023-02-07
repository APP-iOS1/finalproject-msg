//
//  LicenseDetailView.swift
//  MSG
//
//  Created by zooey on 2023/02/07.
//

import SwiftUI

struct LicenseDetailView: View {
    
    var licenseItem: LicenseItem
    
    var body: some View {
        
        ZStack {
            Color("Color1")
                .ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading) {
                    Text(licenseItem.name)
                        .modifier(TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.body, color: FontCustomColor.color2))
                    Text(licenseItem.text)
                        .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.caption, color: FontCustomColor.color2))
                }
                .background(Color("Color"))
            }
        }
    }
}

struct LicenseDetailView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        LicenseDetailView(licenseItem: LicenseItem(name: "", text: ""))
        
    }
}
