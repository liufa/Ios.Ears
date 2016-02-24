//
//  NetworkClient.m
//  Emergency
//
//  Created by star on 2/24/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import "NetworkClient.h"

@implementation NetworkClient

+ (NetworkClient*)sharedClient
{
    static NetworkClient *client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSURL *url = [NSURL URLWithString: kAPIBaseURLString];
        client = [[NetworkClient alloc] initWithBaseURL: url];
        
        client.requestSerializer = [AFJSONRequestSerializer serializer];


        //Response;
        AFHTTPResponseSerializer* responseSerializer = [AFHTTPResponseSerializer serializer];
        client.responseSerializer = responseSerializer;
    });
    
    return client;
}

- (void) registerAccount: (NSString*) uuid
                     lat: (float) lat
                     lng: (float) lng
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure
{
    NSDictionary* param = [NSDictionary dictionaryWithObjectsAndKeys:
                           uuid, @"applicationId",
                           [NSString stringWithFormat: @"%f,%f", lat, lng], @"coordinates",
                           nil];
    
    NSLog(@"params = %@", param);
    [self GET: @"api/Account/RegisterCrew"
   parameters: param
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
          
          NSString *result = [[NSString alloc] initWithData: responseObject encoding:NSUTF8StringEncoding];
          success(result);
          
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          
          failure(error);
      }];
}

- (void) startCall: (NSString*) guid
               lat: (float) lat
               lng: (float) lng
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure
{
    NSDictionary* param = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSString stringWithFormat: @"%f,%f", lat, lng], @"coordinates",
                           guid, @"token",
                           nil];
    
    [self GET: @"EmergencyService/Callout"
   parameters: param
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
          
          NSString *result = [[NSString alloc] initWithData: responseObject encoding:NSUTF8StringEncoding];
          success(result);
          
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          
          failure(error);
      }];
}

- (void) updateGPS: (NSString*) guid
             route: (NSString*) route
               lat: (float) lat
               lng: (float) lng
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure
{
    NSDictionary* param = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSString stringWithFormat: @"%f,%f", lat, lng], @"coordinates",
                           guid, @"token",
                           route, @"route",
                           nil];

    
    [self GET: @"EmergencyService/Callout"
   parameters: param
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
          
          NSString *result = [[NSString alloc] initWithData: responseObject encoding:NSUTF8StringEncoding];
          success(result);
          
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          
          failure(error);
      }];
}

- (void) stopCall: (NSString*) guid
            route: (NSString*) route
          success:(void (^)(id responseObject))success
          failure:(void (^)(NSError *error))failure
{
    NSDictionary* param = [NSDictionary dictionaryWithObjectsAndKeys:
                           guid, @"token",
                           route, @"route",
                           nil];
    
    
    [self GET: @"EmergencyService/Finished"
   parameters: param
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
          
          NSString *result = [[NSString alloc] initWithData: responseObject encoding:NSUTF8StringEncoding];
          success(result);
          
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          
          failure(error);
      }];

}

@end
