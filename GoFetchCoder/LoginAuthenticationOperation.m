//
//  LoginAuthenticationOperation.m
//  GoFetchCoder
//
//  Created by Abhishek Bedi on 1/27/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import "LoginAuthenticationOperation.h"

#import "Constants.h"
#import "User.h"
#import "NSUserDefaults+Extension.h"

@implementation LoginAuthenticationOperation


- (void)main {
    @autoreleasepool {
        
        if (self.isCancelled) {
            return;
        }
        
        [super main];
        
        
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrl,kLoginAuthenticateAPI]]];
        
        request.HTTPMethod = @"POST";
        
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        //    NSString *stringData = @"{\"email\":\"thakran1@yopmail.com\",\"password\":\"1234\"}";

//        _username = @"thakran1@yopmail.com";
//        _password = @"1234";
        
        NSString *stringData = [NSString stringWithFormat:@"{\"email\":\"%@\",\"password\":\"%@\"}",_username,_password];
        
        NSData *requestBodyData = [stringData dataUsingEncoding:NSUTF8StringEncoding];
        request.HTTPBody = requestBodyData;
        
        NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
       //     NSLog(@"Response data :%lu bytes",data.length);
            
            BOOL isSuccess = false;
            __block NSDictionary *dict = nil;
            if (!error) {
                error = nil;
                id json  = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                NSLog(@"jsonResponse  : \n\n %@",json);
                if (!error) {
                    /*
                     jsonResponse  :
                     
                     {
                     people =     {
                     email = "thakran1@yopmail.com";
                     firstName = Ashish;
                     id = 1;
                     lastName = Thakran;
                     status = ACTIVE;
                     type = INDIVIDUAL;
                     };
                     status = "LOGIN_SUCCESS";
                     }
                     */
                    dict = [(NSHTTPURLResponse *)response allHeaderFields];
                    if (dict[kAuthToken]) {
                        NSLog(@"AUthToken: %@",dict[kAuthToken]);
                        isSuccess = YES;
                        User *user = [[User alloc] init];
                        [user setUserModel:json];
                        
                        [[NSUserDefaults standardUserDefaults] setObject:dict[kAuthToken] forKey:kUser_FirstName];
                        
                        [[NSUserDefaults standardUserDefaults] setObject:user.firstName forKey:kUser_FirstName];
                        [[NSUserDefaults standardUserDefaults] setObject:user.lastName forKey:kUser_LastName];
                        [[NSUserDefaults standardUserDefaults] setObject:user.email forKey:kUser_Email];
                        [[NSUserDefaults standardUserDefaults] setObject:user.status forKey:kUser_Status];
                        [[NSUserDefaults standardUserDefaults] setInteger:user.identifier forKey:kUser_Identifier];
                        [[NSUserDefaults standardUserDefaults] setInteger:user.enrollmentType forKey:kUser_EnrollmentType];
                        
                        
                    
                        //[[NSUserDefaults standardUserDefaults] saveCustomObject:user key:kUser];
                        
//                        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:user] forKey:kUser];
//                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                    else {
                        dict = (NSDictionary *)json;
                    }
                }
            }
                if (isSuccess) {
                    self.onSuccess(dict[kAuthToken]);
                }
                else {
                    self.onFailure(dict);
                }
            
        }];
        
        [dataTask resume];

    }
}

@end
