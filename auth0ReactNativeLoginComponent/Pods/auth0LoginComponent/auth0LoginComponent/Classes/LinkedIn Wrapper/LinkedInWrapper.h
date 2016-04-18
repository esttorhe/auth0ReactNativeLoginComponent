//
//  LinkedInWrapper.h
//  auth0LoginComponent
//
//  Created by Esteban Torres on 16/4/16.
//
//

//// Native Frameworks
// Foundations
@import Foundation;

/**
 *  @author Esteban Torres, 16-04-16
 *
 *  `LinkedIn` `SDK` wrapper.
 *  Created in order to use the `LinkedIn` `SDK` easier from the `Swift` implementation of the `auth0LoginComponent`.
 *
 *  @since 0.1.0
 */
@interface LinkedInWrapper : NSObject

/**
 *  @author Esteban Torres, 16-04-16
 *
 *  Tries to log the user in using `LinkedIn`.
 *  If the `LinkedIn` app is not installed will show the `AppStore` download dialog.
 *
 *  @param successBlock The block that will be called after successfully authenticating with the `LinkedIn` app. Will return the `LinkedIn` `accessToken` back.
 *  @param errorBlock   The block that will be called if an error occurs. (e.g. App not installed, user rejected authentication, etc).
 *
 *  @since 0.1.0
 */
+ (void) loginToLinkedInWithSuccessBlock: (void (^_Nonnull)(NSString * _Nonnull accessToken))successBlock errorBlock:(void (^_Nonnull)(NSError * _Nonnull error))errorBlock;

/**
 *  @author Esteban Torres, 16-04-16
 *
 *  Handles an application callback from `LinkedIn` application.
 *  Internally will ask the `LinkedIn` `SDK` if it *should* handle the url first; then it will defer the logic to the `SDK`.
 *
 *  @param application       Current application where the wrapper is being executed.
 *  @param url               The url that the `sourceApplication` is trying to open.
 *  @param sourceApplication The name/bundle of the application redirecting the flow to this `application`.
 *  @param annotation        A nullable `id` «context» object.
 *
 *  @return `YES` if the request can be handled, `NO` otherwise.
 *
 *  @since 0.1.0
 */
+ (BOOL) application: (UIApplication * _Nonnull)application openURL:(NSURL  * _Nonnull )url sourceApplication: (NSString * _Nullable)sourceApplication annotation: (_Nullable id)annotation;

@end