//
//  CustomAlertView.swift
//  MSG
//
//  Created by sehooon on 2023/01/26.
//

import SwiftUI
import UIKit
// View프로토콜을 따르는 Content타입
struct CustomAlertView<Content>: View where Content:View {
    let content: Content
    let primaryButton: CustomAlertButton
    let secondButton: CustomAlertButton?
    
     init(@ViewBuilder content: () -> Content, primaryButton: () ->  CustomAlertButton, secondButton: (()->CustomAlertButton)? ){
        self.content = content()
        self.primaryButton = primaryButton()
        self.secondButton = secondButton?()
    }
    
    var body: some View {
        ZStack{
            //alert
            Color(.black).ignoresSafeArea().opacity(0.4)
            content
                .foregroundColor(.black)
                .padding(.bottom, 60)
                .overlay(
                    VStack(spacing:0){
                        HStack(){
                            primaryButton
                            if secondButton != nil{
                                Divider()
                                secondButton
                            }
                        }
                        .frame(height:60)
                        .font(.system(size: 16,weight: .bold))
                    }
                    , alignment: .bottom)
                .background(
                    Color.white
                ).cornerRadius(10)
        }
    }
}

extension UIApplication {
    
    class func topViewController(base: UIViewController? = getRootView()) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}

extension View{
    func alert<Content>(isPresented:Binding<Bool>, alert: () -> CustomAlertView<Content>) -> some View where Content: View{
        
        let vc = UIHostingController(rootView: alert())
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.view.backgroundColor = .clear
        vc.definesPresentationContext = true
        
        return self.onChange(of: isPresented.wrappedValue, perform: {
            if $0{
                UIApplication.topViewController()!.present(vc,animated: true)
            }
            else{
                UIApplication.topViewController()!.dismiss(animated: true)
            }
        })
    }
}
