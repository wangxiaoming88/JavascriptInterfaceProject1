//
//  GCFAPIClient.h
//  GoFetchCoder
//
//  Created by Kuldeep Mishra on 16/01/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface GCFAPIClient : AFHTTPSessionManager

+(GCFAPIClient *)instance;
//- (NSURLSessionDataTask *)postService:(NSString *)URLString
//                           parameters:(NSDictionary *)parameters
//                           handler:(void (^)(NSURLResponse *urlResponse, id responseObject, NSError *error))handler;
//


- (NSURLSessionDataTask *)postService:(NSString *)URLString
                           parameters:(NSDictionary *)parameters
                                 type:(NSString *)requestType
                              handler:(void (^)(NSURLResponse *urlResponse, id responseObject, NSError *error))handler;
@end
