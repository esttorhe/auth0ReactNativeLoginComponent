//
//  LoginComponentViewController.swift
//  Pods
//
//  Created by Esteban Torres on 16/4/16.
//
//

//// Native Frameworks
// UI
import UIKit

public class LoginComponentViewController: UIViewController {
   // MARK: UI Properties
   @IBOutlet weak var titleLabel: UILabel!
   @IBOutlet weak var usernameLabel: UILabel!
   @IBOutlet weak var passwordLabel: UILabel!
   @IBOutlet weak var usernameTextField: UITextField!
   @IBOutlet weak var passwordTextField: UITextField!
   @IBOutlet weak var linkedInButton: UIButton!
   @IBOutlet weak var emailButton: UIButton!
   @IBOutlet weak var dividerView: UIView!
   @IBOutlet weak var loaderView: UIActivityIndicatorView!
   
   // MARK: Properties
   var dismissLoginViewController: (() -> ())? = nil
   var successHandler: ((AccessToken)->())?    = nil
   var errorHandler: ((ErrorType)->())?        = nil
   var uiConfiguration: LoginComponentConfiguration? = nil
   
   // MARK: Regular Life Cycle
   override public func viewDidLoad() -> Void {
      self.configureUI()
   }
   
   // MARK: Events
   @IBAction func linkedInTouched(sender: UIButton) -> Void {
      self.loaderView.startAnimating()
      Auth0LoginComponent.linkedInLogin({ [unowned self] token in
         dispatch_async(dispatch_get_main_queue()) {
            self.loaderView.stopAnimating()
            self.successHandler?(token)
         }
      }) { [unowned self] error in
         dispatch_async(dispatch_get_main_queue()) {
            self.loaderView.stopAnimating()
            self.errorHandler?(error)
         }
      }
   }
   
   @IBAction func emailLoginTouched(sender: UIButton) -> Void {
      guard let username = self.usernameTextField.text,
         let password = self.passwordTextField.text else {
            return
      }
      
      self.loaderView.startAnimating()
      Auth0LoginComponent.authenticateWithUsername(username, password: password, successHandler: { [unowned self] token in
         dispatch_async(dispatch_get_main_queue()) {
            self.loaderView.stopAnimating()
            self.successHandler?(token)
         }
      }) { [unowned self] error in
         dispatch_async(dispatch_get_main_queue()) {
            self.loaderView.stopAnimating()
            self.errorHandler?(error)
         }
      }
   }
   
   func closeTouched(sender: UIBarButtonItem) -> Void {
      self.dismissLoginViewController?()
   }
}

// MARK: - Private Methods

private extension LoginComponentViewController {
   /**
    Configures the UI with the provided `uiConfiguration` object.
    */
   func configureUI() -> Void {
      // Text
      self.title = "auth0 Login"
      
      // Navigation Bar
      let close = UIBarButtonItem(title: "Cancel", style: .Done, target: self, action: #selector(LoginComponentViewController.closeTouched(_:)))
      self.navigationItem.leftBarButtonItem = close
      
      //*********************************************************************************************//
      //** Configuration
      //*********************************************************************************************//
      let configuration = self.uiConfiguration ?? LoginComponentConfiguration.DefaultConfiguration()
      // Fonts
      self.titleLabel.font                 = configuration.headerFont
      self.usernameLabel.font              = configuration.captionFont
      self.passwordLabel.font              = configuration.captionFont
      self.usernameTextField.font          = configuration.textFieldFont
      self.passwordTextField.font          = configuration.textFieldFont
      self.linkedInButton.titleLabel?.font = configuration.buttonFont
      self.emailButton.titleLabel?.font    = configuration.buttonFont

      // Text Colors
      self.titleLabel.textColor            = configuration.headerTextColor
      self.usernameLabel.textColor         = configuration.captionTextColor
      self.passwordLabel.textColor         = configuration.captionTextColor
      self.usernameTextField.textColor     = configuration.textFieldTextColor
      self.passwordTextField.textColor     = configuration.textFieldTextColor
      self.linkedInButton.setTitleColor(configuration.buttonTextColor, forState: .Normal)
      self.emailButton.setTitleColor(configuration.buttonTextColor, forState: .Normal)
      self.dividerView.backgroundColor     = configuration.spacerBackgroundColor
      self.view.backgroundColor            = configuration.backgroundColor
   }
}