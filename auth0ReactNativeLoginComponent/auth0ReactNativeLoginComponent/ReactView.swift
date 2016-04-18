//
//  ReactView.swift
//  auth0ReactNativeLoginComponent
//
//  Created by Esteban Torres on 17/4/16.
//  Copyright © 2016 Esteban Torres. All rights reserved.
//

//// Native Frameworks
// UI
import UIKit

//// Pods
// React
import React

class ReactView: UIView {
   let rootView: RCTRootView = RCTRootView(bundleURL: NSURL(string: "http://localhost:8081/index.ios.bundle?platform=ios"),
                                           moduleName: "auth0ReactNativeExample", initialProperties: nil, launchOptions: nil)
   
   override func layoutSubviews() {
      super.layoutSubviews()
      
      loadReact()
   }
   
   func loadReact () {
      addSubview(rootView)
      rootView.frame = self.bounds
   }
}
