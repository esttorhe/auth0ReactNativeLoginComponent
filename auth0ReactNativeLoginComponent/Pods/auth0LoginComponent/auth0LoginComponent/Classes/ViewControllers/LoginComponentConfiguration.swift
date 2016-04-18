//
//  LoginComponentConfiguration.swift
//  Pods
//
//  Created by Esteban Torres on 16/4/16.
//
//

//// Native Frameworks
// UI
import UIKit

/**
 *  @author Esteban Torres, 16-04-16
 *
 *  UI Login Component Configuration
 *  Enables customization of fonts, colors, background, etc.
 *
 *  @since 0.1.0
 */
@objc public final class LoginComponentConfiguration: NSObject {
   // MARK: Fonts
   let headerFont: UIFont
   let captionFont: UIFont
   let textFieldFont: UIFont
   let buttonFont: UIFont
   
   // MARK: Colors
   // Text
   let headerTextColor: UIColor
   let captionTextColor: UIColor
   let textFieldTextColor: UIColor
   let buttonTextColor: UIColor
   let spacerBackgroundColor: UIColor
   let backgroundColor: UIColor
   
   init(headerFont: UIFont, captionFont: UIFont, textFieldFont: UIFont, buttonFont: UIFont, headerTextColor: UIColor, captionTextColor: UIColor,
        textFieldTextColor: UIColor, buttonTextColor: UIColor, spacerBackgroundColor: UIColor, backgroundColor: UIColor) {
      self.headerFont            = headerFont
      self.captionFont           = captionFont
      self.textFieldFont         = textFieldFont
      self.buttonFont            = buttonFont
      self.headerTextColor       = headerTextColor
      self.captionTextColor      = captionTextColor
      self.textFieldTextColor    = textFieldTextColor
      self.buttonTextColor       = buttonTextColor
      self.spacerBackgroundColor = spacerBackgroundColor
      self.backgroundColor       = backgroundColor
   }
   
   @objc public static func DefaultConfiguration() -> LoginComponentConfiguration {
      if #available(iOS 9.0, *) {
         return LoginComponentConfiguration(
            headerFont: UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1),
            captionFont: UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1),
            textFieldFont: UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote),
            buttonFont: UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline),
            headerTextColor: .blackColor(),
            captionTextColor: .blackColor(),
            textFieldTextColor: .blackColor(),
            buttonTextColor: .blueColor(),
            spacerBackgroundColor: .lightGrayColor(),
            backgroundColor: .whiteColor()
         )
      } else {
         return LoginComponentConfiguration(
            headerFont: UIFont.boldSystemFontOfSize(20.0),
            captionFont: UIFont.systemFontOfSize(14.0),
            textFieldFont: UIFont.systemFontOfSize(12),
            buttonFont: UIFont.boldSystemFontOfSize(12.0),
            headerTextColor: .blackColor(),
            captionTextColor: .blackColor(),
            textFieldTextColor: .blackColor(),
            buttonTextColor: .blueColor(),
            spacerBackgroundColor: .lightGrayColor(),
            backgroundColor: .whiteColor()
         )
      }
   }
}
