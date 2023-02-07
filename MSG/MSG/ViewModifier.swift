 
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


struct FontCustomType{
    static var largeTitle = (fontSize:CGFloat(32), fontStyle: Font.TextStyle.largeTitle)
    static var title = (fontSize:CGFloat(28), fontStyle: Font.TextStyle.title)
    static var title2 = (fontSize:CGFloat(22), fontStyle: Font.TextStyle.title2)
    static var title3 = (fontSize:CGFloat(20), fontStyle: Font.TextStyle.title3)
    static var body = (fontSize:CGFloat(17), fontStyle: Font.TextStyle.body)
    static var callout = (fontSize:CGFloat(16), fontStyle: Font.TextStyle.callout)
    static var subhead = (fontSize:CGFloat(15), fontStyle: Font.TextStyle.subheadline)
    static var footnot = (fontSize:CGFloat(13), fontStyle: Font.TextStyle.footnote)
    static var caption = (fontSize:CGFloat(12), fontStyle: Font.TextStyle.caption)
    static var caption2 = (fontSize:CGFloat(11), fontStyle: Font.TextStyle.caption2)
}

enum FontCustomColor: String{
    case color1 = "Color1"
    case color2 = "Color2"
    case color3 = "Color3"
    case color4 = "Color4"
}

enum FontCustomWeight:String {
    case normal = "MaplestoryOTFLight"
    case bold = "MaplestoryOTFBold"
}

struct TextModifier: ViewModifier{
    let fontWeight: FontCustomWeight
    let fontType: (fontSize: CGFloat, fontStyle: Font.TextStyle)
    let color:FontCustomColor
    
    func body(content: Content) -> some View {
            content
            .foregroundColor(Color(color.rawValue))
                .font(.custom(fontWeight.rawValue, size: fontType.fontSize, relativeTo: fontType.fontStyle))
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


    
