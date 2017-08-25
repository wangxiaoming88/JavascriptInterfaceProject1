//
//  AddHighLightOperation.m
//  GoFetchCoder
//
//  Created by Sandro Albert on 4/1/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import "AddHighLightOperation.h"
#import "Constants.h"

@implementation AddHighLightOperation
- (void)main {
    @autoreleasepool {
        
        if (self.isCancelled) {
            return;
        }
        
        
        if (self.startIndex == nil || self.endIndex == nil)
            return;
        
        [super main];
        
        NSString *requestString = [NSString stringWithFormat:@"%@%@",kBaseUrl,kAddHighlightAPI];
        NSString *stringData = [NSString stringWithFormat:@"{\"chapter\" : %d, \"startIndex\" : \"%@\",\"endIndex\" : \"%@\"}",_chapter ,_startIndex,_endIndex];
        
        
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
                   
                  if (self.onCompletion)
                    self.onCompletion(jsonResponse,YES);
                } else {
                    self.onCompletion(jsonResponse, NO);
                    
                }
            }
            
        }];
        
        [dataTask resume];
        
    }
}
@end
