

//// Native Frameworks
// Foundation
import Foundation

/**
 Set of `ErrorType`s that `Auth0LoginComponent` can raise.
 
 - InvalidAuth0Domain:        App couldn't read the `Auth0Domain` from the `Info.plist`
 - CannotSerializeParameters: An internal error occured and the framework was unable to serialize the body data for the `auth0` `API` call
 - CannotSerializeResponse:   An internal error occured and the framework was unable to deserialize the response from the `auth0` `API` call.
 - UnableToDecodeAccessToken: Unable to decode `auth0` response into a correct access token.
 */
public enum Auth0LoginComponentError: ErrorType {
   case InvalidAuth0Domain
   case CannotSerializeParameters(ErrorType)
   case CannotSerializeResponse(ErrorType)
   case UnableToDecodeAccessToken
}

/// Drop in login component that internally uses `auth0` authentication mechanisms.
@objc public class Auth0LoginComponent: NSObject {
   // MARK: Properties
   private static let UrlSession: NSURLSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
   private class var Auth0URL: NSURL? {
      let bundle = NSBundle.mainBundle()
      if let auth0Namespace = bundle.infoDictionary?["Auth0Domain"] {
         return NSURL(string: "https://\(auth0Namespace)/oauth")
      }
      
      return nil
   }
   
   private class var Auth0ClientId: String? {
      let bundle = NSBundle.mainBundle()
      if let clientId = bundle.infoDictionary?["Auth0ClientId"] as? String {
         return clientId
      }
      
      return nil
   }
   
   // MARK: Public Methods
   /**
    Displays a customizable login component to authenticated against `LinkedIn` `SDK` or username/password and then against `auth0` to retrieve an access token.
    
    - parameter presenter:       The `UIViewController` used as the presenter for the login view controller.
    - parameter uiConfiguration: The `LoginComponentConfiguration` object detailing the `UI` details for the controller.
    - parameter successHandler:  Success closure that will be called upon successful authentication. Passses the generated `AccessToken` object.
    - parameter errorHandler:    Error closure that gets called if something fails. Passes `Auth0LoginComponentError`s.
    */
   public static func presentLoginViewControllerWithPresenterController(presenter: UIViewController, uiConfiguration: LoginComponentConfiguration=LoginComponentConfiguration.DefaultConfiguration(), successHandler:(AccessToken)->(), errorHandler:(ErrorType)->()) -> Void {
      dispatch_async(dispatch_get_main_queue()) {
         let podBundle = NSBundle(forClass: LoginComponentViewController.self)
         if let bundleURL = podBundle.URLForResource("auth0LoginComponent", withExtension: "bundle") {
            if let auth0Bundle = NSBundle(URL: bundleURL) {
               let loginVC                        = LoginComponentViewController(nibName: "LoginComponent", bundle: auth0Bundle)
               loginVC.uiConfiguration            = uiConfiguration
               loginVC.successHandler             = successHandler
               loginVC.errorHandler               = errorHandler
               loginVC.dismissLoginViewController = {
                  presenter.dismissViewControllerAnimated(true, completion: nil)
               }
               let navigationController           = UINavigationController(rootViewController: loginVC)
               presenter.presentViewController(navigationController, animated: true, completion: nil)
            }
         }
      }
   }
   
   /**
    Creates a new `LoginComponentViewController` but doesn't presents it but returns it instead.
    
    - parameter uiConfiguration: The `LoginComponentConfiguration` object detailing the `UI` details for the controller.
    - parameter successHandler:  Success closure that will be called upon successful authentication. Passses the generated `AccessToken` object.
    - parameter errorHandler:    Error closure that gets called if something fails. Passes `Auth0LoginComponentError`s.
    - parameter cancelHandler:   Cancel closure that gets called when the `LoginComponentViewController` gets a touch event on the `Cancel` button.
    
    - returns: A fully initialized `LoginComponentViewController` with the passed in closures as parameters or `nil` if there's an error.
    */
   @objc public static func createLoginViewController(uiConfiguration: LoginComponentConfiguration=LoginComponentConfiguration.DefaultConfiguration(), successHandler:([String: String])->(), errorHandler:(NSError)->(), cancelHandler:()->()) -> LoginComponentViewController? {
      let podBundle = NSBundle(forClass: LoginComponentViewController.self)
      if let bundleURL = podBundle.URLForResource("auth0LoginComponent", withExtension: "bundle") {
         if let auth0Bundle = NSBundle(URL: bundleURL) {
            let loginVC                        = LoginComponentViewController(nibName: "LoginComponent", bundle: auth0Bundle)
            loginVC.uiConfiguration            = uiConfiguration
            loginVC.successHandler             = { accessToken in
               successHandler(accessToken.toDictionary())
            }
            loginVC.errorHandler               = { error in
               errorHandler(error as NSError)
            }
            loginVC.dismissLoginViewController = cancelHandler
            
            return loginVC
         }
      }
      
      return nil
   }
   
   public static func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
      return LinkedInWrapper.application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
   }
}

// MARK: - Private Methods

internal extension Auth0LoginComponent {
   /**
    Using the `LinkedIn` `SDK` will authenticate against their `API`.
    Upon successfully authenticating the user will get a valid access token from `auth0` `API`.
    
    - parameter successHandler: Success handler that will be called upon receiving a correct response from `auth0`.
    - parameter errorHandler:   Error handler in case of an error. Sends back `Auth0LoginComponentError`s.
    */
   static func linkedInLogin(successHandler:(accessToken: AccessToken) -> (), errorHandler:(error: ErrorType) -> ()) -> Void {
      LinkedInWrapper.loginToLinkedInWithSuccessBlock({ accessToken in
         do {
            let parameters = [
               "client_id": Auth0ClientId!,
               "access_token": accessToken,
               "connection": "linkedin"
            ]
            
            let dataTask = try createDataTaskWithPathComponent("access_token", andParameters: parameters, completionHandler: { (accessToken) in
               successHandler(accessToken: accessToken)
               }, errorHandler: { (error) in
                  errorHandler(error: error)
            })
            
            dataTask.resume()
         }
         catch {
            errorHandler(error: error)
         }
         }, errorBlock: { error in
            errorHandler(error: error)
      })
   }
   
   /**
    Authenticates the user against `auth0` using username & password.
    
    - parameter username:       The username of the user that will be used to authenticate.
    - parameter password:       The password of the user.
    - parameter successHandler: The closure that will be called upon receiving a correct response from `auth0`.
    - parameter errorHandler:   Error handler in case of an error. Sends back `Auth0LoginComponentError`s.
    */
   static func authenticateWithUsername(username: String, password: String, successHandler:(accessToken: AccessToken) -> (), errorHandler:(error: ErrorType) -> ()) -> Void {
      do {
         let parameters = [
            "client_id": Auth0ClientId!,
            "username": username,
            "password": password,
            "connection": "Username-Password-Authentication",
            "grant_type": "password",
            "scope": "openid name email"
         ]
         
         let dataTask = try createDataTaskWithPathComponent("ro", andParameters: parameters, completionHandler: { (accessToken) in
            successHandler(accessToken: accessToken)
            }, errorHandler: { (error) in
               errorHandler(error: error)
         })
         
         dataTask.resume()
      }
      catch {
         errorHandler(error: error)
      }
   }
   
   /**
    Creates an `NSURLSessionDataTask` for the `auth0` `API`.
    
    - parameter pathComponent:     The path component that will be appended to the `auth0` `API` `URL`.
    - parameter parameters:        The dictionary of body parameters that will be passed to the `pathComponent`
    - parameter completionHandler: The completion handler that will be called upon successfully deserializing the `auth0` response.
    - parameter errorHandler:      The error handler that will be called if an error occurs.
    
    - throws: Throws some `Auth0LoginComponentError`s if any detected.
    
    - returns: A fully initialized `NSURLSessionDataTask` with the `pathComponent` as the last part of the request's `URL`.
    */
   static func createDataTaskWithPathComponent(pathComponent: String, andParameters parameters: [String: AnyObject]?=nil, completionHandler:(accessToken: AccessToken) -> (), errorHandler: (error: ErrorType) -> ()) throws -> NSURLSessionDataTask {
      guard let url = Auth0URL?.URLByAppendingPathComponent(pathComponent) else {
         throw Auth0LoginComponentError.InvalidAuth0Domain
      }
      
      let request = NSMutableURLRequest(URL: url)
      request.HTTPMethod = "POST"
      request.addValue("application/json", forHTTPHeaderField: "Content-Type")
      request.addValue("application/json", forHTTPHeaderField: "Accept")
      
      if let parameters = parameters {
         do {
            let body = try NSJSONSerialization.dataWithJSONObject(parameters, options: [])
            request.HTTPBody = body
         } catch {
            throw Auth0LoginComponentError.CannotSerializeParameters(error)
         }
      }
      
      let dataTask = UrlSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
         if let data = data {
            do {
               let object = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
               guard let at = object["access_token"] as? String,
                  let idt = object["id_token"] as? String,
                  let tokenType = object["token_type"] as? String else {
                     errorHandler(error: Auth0LoginComponentError.UnableToDecodeAccessToken)
                     
                     return
               }
               
               let accessToken = AccessToken(accessToken: at, idToken: idt, tokenType: tokenType)
               completionHandler(accessToken: accessToken)
            } catch {
               errorHandler(error: Auth0LoginComponentError.CannotSerializeResponse(error))
            }
         }
         print(response)
      })
      
      return dataTask
   }
}