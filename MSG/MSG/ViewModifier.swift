 
import SwiftUI

//.font(.custom("MaplestoryOTFLight", size: 30))

struct TextViewModifier: ViewModifier{
    //body
    let size = 30
    let height = UIScreen.main.bounds.size.height
    let color: String
    
    func dynamicFontSize(_ FontSize: CGFloat) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.size.width
        let calculatedFontSize = screenWidth / height * FontSize
        return calculatedFontSize
    }
    
    func body(content: Content) -> some View {

            content
                .foregroundColor(Color(color))
                .font(.custom("MaplestoryOTFLight", size: dynamicFontSize(CGFloat(size))))

            
    }
}

struct TextTitleBold: ViewModifier{
    let size = 50
    let height = UIScreen.main.bounds.size.height
    
    func dynamicFontSize(_ FontSize: CGFloat) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.size.width
        let calculatedFontSize = screenWidth / height * FontSize
        return calculatedFontSize
    }
    
    func body(content: Content) -> some View {

            content
                .foregroundColor(Color("Color2"))
                .font(.custom("MaplestoryOTFBold", size: dynamicFontSize(CGFloat(size))))

            
    }
}

struct TextTitleSemiBold: ViewModifier{
    let size = 40
    let color: String
    let height = UIScreen.main.bounds.size.height
    
    func dynamicFontSize(_ FontSize: CGFloat) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.size.width
        let calculatedFontSize = screenWidth / height * FontSize
        return calculatedFontSize
    }
    
    func body(content: Content) -> some View {

            content
                .foregroundColor(Color(color))
                .font(.custom("MaplestoryOTFBold", size: dynamicFontSize(CGFloat(size))))

            
    }
}


