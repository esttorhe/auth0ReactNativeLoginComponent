//
//  LinkedInWarpper.m
//  auth0LoginComponent
//
//  Created by Esteban Torres on 16/4/16.
//
//

// Header
#import "LinkedInWrapper.h"

// Frameworks
#import <linkedin-sdk/LISDK.h>

@implementation LinkedInWrapper

+ (void) loginToLinkedInWithSuccessBlock: (void (^_Nonnull)(NSString * _Nonnull accessToken))successBlock errorBlock:(void (^_Nonnull)(NSError * _Nonnull error))errorBlock {
   [LISDKSessionManager createSessionWithAuth:[NSArray arrayWithObjects:LISDK_BASIC_PROFILE_PERMISSION, LISDK_EMAILADDRESS_PERMISSION, nil]
                                        state: @"auth0LoginComponent"
                      showGoToAppStoreDialog :YES
                                successBlock : ^(NSString * returnState){
                                   successBlock([[[LISDKSessionManager sharedInstance] session] accessToken].accessTokenValue);
                                }
                                   errorBlock: errorBlock];
}

+ (BOOL) application: (UIApplication * _Nonnull)application openURL:(NSURL  * _Nonnull )url sourceApplication: (NSString * _Nullable)sourceApplication annotation: (_Nullable id)annotation {
   if ([LISDKCallbackHandler shouldHandleUrl:url]) {
      return [LISDKCallbackHandler application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
   }
   
   return NO;
}

@end
