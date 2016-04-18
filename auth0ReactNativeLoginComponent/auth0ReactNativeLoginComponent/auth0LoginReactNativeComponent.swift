//
//  auth0LoginReactNativeComponent.swift
//  auth0ReactNativeLoginComponent
//
//  Created by Esteban Torres on 17/4/16.
//  Copyright © 2016 Esteban Torres. All rights reserved.
//

//// Native Frameworks
// Foundation
import Foundation

//// Pods
// auth0LoginComponent
import auth0LoginComponent

// React
import React

@objc(Auth0LoginReactNativeComponent)
class Auth0LoginReactNativeComponent: NSObject {
   var bridge: RCTBridge!
   
   @objc func showLoginComponent() -> Void {
      if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate,
         let window = delegate.window,
         let rvc = window.rootViewController {
         Auth0LoginComponent.presentLoginViewControllerWithPresenterController(rvc, successHandler: { accessToken in
            self.bridge.eventDispatcher.sendAppEventWithName("Auth0LoginSuccess", body: accessToken.toDictionary())
            }, errorHandler: { error in
               self.bridge.eventDispatcher.sendAppEventWithName("Auth0LoginFailed", body: NSDictionary(dictionary: ["error": (error as NSError).localizedDescription]))
            }
         )
      }
   }
   
}