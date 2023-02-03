 
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
    static var largeTitle = (fontSize:32, fontStyle: Font.TextStyle.largeTitle)
    static var title = (fontSize:28, fontStyle: Font.TextStyle.title)
    static var title2 = (fontSize:22, fontStyle: Font.TextStyle.title2)
    static var title3 = (fontSize:20, fontStyle: Font.TextStyle.title3)
    static var body = (fontSize:17, fontStyle: Font.TextStyle.body)
    static var callout = (fontSize:16, fontStyle: Font.TextStyle.callout)
    static var subhead = (fontSize:15, fontStyle: Font.TextStyle.subheadline)
    static var footnot = (fontSize:13, fontStyle: Font.TextStyle.footnote)
    static var caption = (fontSize:12, fontStyle: Font.TextStyle.caption)
    static var caption2 = (fontSize:11, fontStyle: Font.TextStyle.caption2)
}

enum FontCustomColor: String{
    case color1 = "Color1"
    case color2 = "Color2"
}

enum FontCustomWeight:String {
    case normal = "MaplestoryOTFLight"
    case bold = "MaplestoryOTFBold"
}

struct TextModifier: ViewModifier{
    let fontWe: FontCustomWeight
    let fontTy: (fontSize: CGFloat, fontStyle: Font.TextStyle)
    let color:FontCustomColor
    
    func body(content: Content) -> some View {
            content
            .foregroundColor(Color(color.rawValue))
                .font(.custom(fontWe.rawValue, size: fontTy.fontSize, relativeTo: fontTy.fontStyle))
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


    
