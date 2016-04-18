//
//  Auth0Login.m
//  auth0ReactNativeLoginComponent
//
//  Created by Esteban Torres on 17/4/16.
//  Copyright © 2016 Esteban Torres. All rights reserved.
//

// Header
#import "Auth0LoginManager.h"

//// Pods
// auth0
@import auth0LoginComponent;

@interface AuthLoginManager ()

@property (nonatomic, strong) LoginComponentViewController *loginVC;

@end

@implementation AuthLoginManager

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE()

- (instancetype)init {
   if (self = [super init]) {
      self.loginVC = [Auth0LoginComponent createLoginViewController:[LoginComponentConfiguration DefaultConfiguration] successHandler:^(NSDictionary<NSString *,NSString *> * _Nonnull accessToken) {
         [self.bridge.eventDispatcher sendAppEventWithName:@"Auth0LoginSuccess" body:accessToken];
      } errorHandler:^(NSError * _Nonnull error) {
         [self.bridge.eventDispatcher sendAppEventWithName:@"Auth0LoginFailed" body:@{ @"error": error.localizedDescription }];
      } cancelHandler:^{
         [self.bridge.eventDispatcher sendAppEventWithName:@"Auth0LoginCancelled" body:@{ @"reason": @"User cancelled the flow." }];
      }];
      
      return self;
   }
   
   return nil;
}

- (UIView *)view {
   return self.loginVC.view;
}

- (dispatch_queue_t)methodQueue {
   return dispatch_get_main_queue();
}

@end
