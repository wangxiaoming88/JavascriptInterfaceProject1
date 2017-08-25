//
//  LoginAuthenticationOperation.h
//  GoFetchCoder
//
//  Created by Abhishek Bedi on 1/27/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginAuthenticationOperation : NSOperation


typedef void(^SuccessBlock)(NSString *authToken);
typedef void(^FailureBlock)(NSDictionary *failureDict);


@property (nonatomic,copy)NSString *username;
@property (nonatomic,copy)NSString *password;

@property (nonatomic, copy)SuccessBlock onSuccess;
@property (nonatomic, copy)FailureBlock onFailure;

@end
