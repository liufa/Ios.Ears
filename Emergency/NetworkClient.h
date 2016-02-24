//
//  NetworkClient.h
//  Emergency
//
//  Created by star on 2/24/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPSessionManager.h>

@interface NetworkClient : AFHTTPSessionManager
{
    
}

+ (NetworkClient*) sharedClient;
- (void) registerAccount: (NSString*) uuid
                     lat: (float) lat
                     lng: (float) lng
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure;

- (void) startCall: (NSString*) guid
               lat: (float) lat
               lng: (float) lng
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

- (void) updateGPS: (NSString*) guid
             route: (NSString*) route
               lat: (float) lat
               lng: (float) lng
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

- (void) stopCall: (NSString*) guid
            route: (NSString*) route
          success:(void (^)(id responseObject))success
          failure:(void (^)(NSError *error))failure;


@end
