//
//  AccessToken.swift
//  Pods
//
//  Created by Esteban Torres on 16/4/16.
//
//

//// Native Frameworks
// Foundation
import Foundation

@objc public final class AccessToken: NSObject {
   let accessToken: String
   let idToken: String
   let tokenType: String
   
   init(accessToken: String, idToken: String, tokenType: String) {
      self.accessToken = accessToken
      self.idToken     = idToken
      self.tokenType   = tokenType
   }
   
   @objc public func toDictionary() -> [String: String] {
      return [
         "accessToken": accessToken,
         "idToken": idToken,
         "tokenType": tokenType
      ]
   }
}