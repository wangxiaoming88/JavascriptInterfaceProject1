//
//  GCFAPIClient.m
//  GoFetchCoder
//
//  Created by Kuldeep Mishra on 16/01/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import "GCFAPIClient.h"
#import "Constants.h"

@implementation GCFAPIClient

+(GCFAPIClient *)instance{
    
    GCFAPIClient *client = [[GCFAPIClient alloc]initWithBaseURL:[NSURL URLWithString:@"do.gofetchcode.com"]];
    client.requestSerializer = [AFJSONRequestSerializer serializer];
    client.responseSerializer = [AFJSONResponseSerializer serializer];
    
    return client;
}

- (NSURLSessionDataTask *)postService:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                                 type:(NSString *)requestType
                      handler:(void (^)(NSURLResponse *urlResponse, id responseObject, NSError *error))handler{
    
   NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:requestType
                                                                                URLString:URLString
                                                                               parameters:parameters
                                                                                    error:nil];
    
    NSString *authToken = [[NSUserDefaults standardUserDefaults] objectForKey:kAuthToken];
    [request setValue:authToken forHTTPHeaderField:kAuthToken];

    NSURLSessionDataTask  *dataTask =  [[AFHTTPSessionManager manager] dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        handler(response, responseObject, error);
    }];
    [dataTask resume];
    
    return dataTask;
}

@end
