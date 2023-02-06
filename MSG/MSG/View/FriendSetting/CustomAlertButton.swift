//
//  CustomAlertButton.swift
//  MSG
//
//  Created by sehooon on 2023/01/26.
//

import SwiftUI

struct CustomAlertButton: View {
    typealias Action = () -> ()
    
    private let action: Action
    private let title: Text
    let color: Color?
    
    init(title:Text,color:Color? = nil,action: @escaping Action){
        self.title = title
        self.action = action
        self.color = color
    }
    
    var body: some View {
        Button{
            action()
        }label: {
            title.frame(maxWidth:.infinity, maxHeight: .infinity)
                .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.body, color: FontCustomColor.color4))
        }.background(color)
    }
}

//struct CustomAlertButton_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomAlertButton()
//    }
//}
