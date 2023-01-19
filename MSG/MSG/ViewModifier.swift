
import SwiftUI

struct TextViewModifier: ViewModifier{
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color("Font"))
    }
}

