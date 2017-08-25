//
//  AddBookmarkOperation.m
//  GoFetchCoder
//
//  Created by Abhishek Bedi on 1/22/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import "AddBookmarkOperation.h"
#import "Constants.h"


@implementation AddBookmarkOperation

- (void)main {
    @autoreleasepool {

        if (self.isCancelled) {
            return;
        }
        
        
        if (self.sequenceId == nil || self.sectionTitle == nil)
            return;

        [super main];
        
        NSString *requestString = [NSString stringWithFormat:@"%@%@",kBaseUrl,kAddBookmarkAPI];
        NSString *stringData = [NSString stringWithFormat:@"{\"sectionSequenceId\" : \"%@\",\"sectionSequenceTitle\" : \"%@\"}", _sequenceId,_sectionTitle];

        
        NSLog(@"Request  : \n\n %@",requestString);
        
        NSURL *url                   = [NSURL URLWithString:requestString];

        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        request.HTTPMethod = @"POST";

        NSString *authToken     = [[NSUserDefaults standardUserDefaults] objectForKey:kAuthToken];

        [request setValue:authToken forHTTPHeaderField:kAuthToken];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];


        NSData *requestBodyData  = [stringData dataUsingEncoding:NSUTF8StringEncoding];
        request.HTTPBody         = requestBodyData;
        NSLog(@"Request Body  : \n\n %@",stringData);
        
        
        // 2
        NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSLog(@"Response data  : \n\n %@",data);

            if (!error) {
                error = nil;
                NSDictionary *jsonResponse  = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                NSLog(@"jsonResponse  : \n\n %@",jsonResponse);

                if (error == nil) {
                    if (jsonResponse[@"id"] != nil) {
                        if (self.onCompletion)
                            self.onCompletion(jsonResponse,YES);
                    }else {
                        self.onCompletion(jsonResponse, NO);
                        
                    }
                }
                else {
                    self.onCompletion(jsonResponse, NO);
                    
                }
            }
            
        }];
                                          
        [dataTask resume];
        
    }
}
@end
