//
//  AppleLoginView.swift
//  MSG
//
//  Created by 전준수 on 2023/01/18.
//

import SwiftUI
import CryptoKit
import AuthenticationServices
import FirebaseAuth

struct AppleLoginView: View {
    
    @EnvironmentObject var appleUserAuth: AppleUserAuth
    @State var currentNonce: String?
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    var body: some View {
        ZStack {
            Color.yellow
                .ignoresSafeArea()
            
            SignInWithAppleButton(
                onRequest: { request in
                    let nonce = randomNonceString()
                    currentNonce = nonce
                    request.requestedScopes = [.fullName, .email]
                    request.nonce = sha256(nonce)
                },
                onCompletion: { result in
                    switch result {
                                      case .success(let authResults):
                                          switch authResults.credential {
                                          case let appleIDCredential as ASAuthorizationAppleIDCredential:
                                              
                                              guard let nonce = currentNonce else {
                                                  fatalError("Invalid state: A login callback was received, but no login request was sent.")
                                              }
                                              guard let appleIDToken = appleIDCredential.identityToken else {
                                                  fatalError("Invalid state: A login callback was received, but no login request was sent.")
                                              }
                                              guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                                                  print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                                                  return
                                              }
                                              
                                              let credential = OAuthProvider.credential(withProviderID: "apple.com",idToken: idTokenString,rawNonce: nonce)
                                              Auth.auth().signIn(with: credential) { (authResult, error) in
                                                  if (error != nil) {
                                                      // Error. If error.code == .MissingOrInvalidNonce, make sure
                                                      // you're sending the SHA256-hashed nonce as a hex string with
                                                      // your request to Apple.
                                                      print(error?.localizedDescription as Any)
                                                      return
                                                  }
                                                  print("signed in")
                                                  self.appleUserAuth.login()
                                              }
                                              
                                              print("\(String(describing: Auth.auth().currentUser?.uid))")
                                          default:
                                              break
                                              
                                          }
                                      default:
                                          break
                                      }
                }
            )
            .frame(width: 280, height: 45, alignment: .center)
            .padding(EdgeInsets(top: 400, leading: 50, bottom: 20, trailing: 50))
        }
    }
}

struct AppleLoginView_Previews: PreviewProvider {
    static var previews: some View {
        AppleLoginView()
            .environmentObject(AppleUserAuth())
    }
}
