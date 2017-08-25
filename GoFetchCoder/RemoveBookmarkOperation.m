//
//  RemoveBookmarkOperation.m
//  GoFetchCoder
//
//  Created by Abhishek Bedi on 1/23/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import "RemoveBookmarkOperation.h"
#import "Constants.h"


@implementation RemoveBookmarkOperation

- (void)main {
    @autoreleasepool {
        
        if (self.isCancelled) {
            return;
        }
        
        if (self.bookmarkId == kInvalid)
            return;
        
        [super main];
        
        
        NSString *requestString = [NSString stringWithFormat:@"%@%@%ld",kBaseUrl,kRemoveBookmarkAPI,(long)_bookmarkId];
        
        
        NSLog(@"Request  : \n\n %@",requestString);
        
        NSURL *url                   = [NSURL URLWithString:requestString];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        request.HTTPMethod = @"PUT";
        
        NSString *authToken     = [[NSUserDefaults standardUserDefaults] objectForKey:kAuthToken];
        
        [request setValue:authToken forHTTPHeaderField:kAuthToken];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

        __block BOOL isSuccess = false;
        
        NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
   //         NSLog(@"Response data  : \n\n %@",data);
            
            if (!error) {
                error = nil;
                NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                
                if (responseString) {
                    if ([responseString caseInsensitiveCompare:@"true"] == NSOrderedSame) {
                        NSLog(@"\n\n Bookmark Removed successfully: \n\n");

                        isSuccess = true;
                    }
                }
                
                
                if (self.onCompletion)
                    self.onCompletion(responseString,isSuccess);
                
                
            }
            
        }];
        
        [dataTask resume];
        
    }
}

@end
