//
//  LogoutOperation.m
//  GoFetchCoder
//
//  Created by Abhishek Bedi on 3/4/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import "LogoutOperation.h"

#import "Constants.h"
#import "User.h"
#import "NSUserDefaults+Extension.h"


@implementation LogoutOperation

- (void)main {
    @autoreleasepool {
        
        if (self.isCancelled) {
            return;
        }
        
        [super main];
        
        
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrl,kLogoutAPI]]];
        
        request.HTTPMethod = @"POST";
        
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        NSString *authToken     = [[NSUserDefaults standardUserDefaults] objectForKey:kAuthToken];
        
        [request setValue:authToken forHTTPHeaderField:kAuthToken];
                
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
                    dict = (NSDictionary *)json;
                    if ([dict[@"status"] isEqualToString:@"LOGOUT_SUCCESS"]) {
                        isSuccess = YES;
                        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kAuthToken];
                        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kUser_FirstName];
                        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kUser_LastName];
                        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kUser_Email];
                        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kUser_Status];
                        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:kUser_Identifier];
                        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:kUser_EnrollmentType];


//                        User *user = [[User alloc] init];
//                        [user setUserModel:json];
                        
//                        [[NSUserDefaults standardUserDefaults] setObject:user.firstName forKey:kUser_FirstName];
//                        [[NSUserDefaults standardUserDefaults] setObject:user.lastName forKey:kUser_LastName];
//                        [[NSUserDefaults standardUserDefaults] setObject:user.email forKey:kUser_Email];
//                        [[NSUserDefaults standardUserDefaults] setObject:user.status forKey:kUser_Status];
//                        [[NSUserDefaults standardUserDefaults] setInteger:user.identifier forKey:kUser_Identifier];
//                        [[NSUserDefaults standardUserDefaults] setInteger:user.enrollmentType forKey:kUser_EnrollmentType];

                        
                        
                        
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
                self.onSuccess();
            }
            else {
                self.onFailure(dict);
            }
            
        }];
        
        [dataTask resume];
        
    }
}

@end
